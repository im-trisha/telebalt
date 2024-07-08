import 'package:dart_dotenv/dart_dotenv.dart';
import 'package:dio/dio.dart';
import 'package:talker/talker.dart';
import 'package:telebalt/src/bot/common/context.dart';
import 'package:telebalt/src/bot/handlers.dart';
import 'package:telebalt/src/bot/middlewares.dart';
import 'package:telebalt/src/models/models.dart';
import 'package:telebalt/src/services/local/database/database.dart';
import 'package:telebalt/src/services/network/network.dart';
import 'package:televerse/televerse.dart';

void main(List<String> args) async {
  final settings = Settings.fromJson(DotEnv().getDotEnv());

  final customUrl = Uri.tryParse(settings.apiUrl ?? '')?.toString();
  final bot = Bot<TgContext>(
    settings.botToken,
    baseURL: customUrl ?? RawAPI.defaultBase,
  );

  final talker = Talker(settings: TalkerSettings(useHistory: false));
  final founderId = int.tryParse(settings.adminId);
  if (founderId == null) {
    talker.error("ADMIN_ID must be an integer.");
    return;
  }

  final database = Database(settings.storagePath, founderId);
  final cobalt = CobaltService(Dio(BaseOptions(baseUrl: settings.cobaltUrl)));

  bot.contextBuilder(TgContext.create(settings, database, talker, cobalt));

  bot.use(SaveUser());

  bot.help(help);
  bot.onMyChatMember(myChatMember);
  bot.onError(onError);
  bot.onStop(() => onStop(database));

  bot.hears(RegExp('/start'), start);
  bot.hears(RegExp('/promote .*'), promote);
  bot.hears(RegExp('/demote .*'), demote);
  bot.hears(RegExp('/authorize .*'), authorize);
  bot.hears(RegExp('/unauthorize .*'), unauthorize);
  bot.onText(onMessage);

  talker.info("Starting bot...");

  await bot.start();
}
