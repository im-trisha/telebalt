import 'package:riverpod/riverpod.dart';
import 'package:telebalt/bot/common/context.dart';
import 'package:telebalt/bot/handlers.dart';
import 'package:telebalt/bot/middlewares.dart';
import 'package:telebalt/providers/providers.dart';

void main(List<String> args) async {
  final container = ProviderContainer();
  final bot = container.read(botProvider);

  bot.contextBuilder(TgContext.create(container));

  bot.use(SaveUser());

  bot.onError(onError);

  bot.command('help', help);
  bot.command('start', start);
  bot.command('promote', promote);
  bot.command('demote', demote);
  bot.command('authorize', authorize);
  bot.command('unauthorize', unauthorize);
  bot.command('nickname', nickname);
  bot.command('status', status);
  bot.command('users', users);

  bot.onInlineQuery(onInlineQuery);

  bot.onMyChatMember(myChatMember);

  bot.onText(onMessage);

  final talker = container.read(loggerProvider);
  bot.onStop(() => talker.info("The bot has been stopped."));

  talker.info("Starting bot...");

  await bot.start();

  talker.info("Tidying resources...");
  container.dispose();
}
