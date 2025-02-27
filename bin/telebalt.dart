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
  bot.use(SaveChat());

  bot.onError(onError);

  bot.command('help', help);
  bot.command('start', start);
  bot.command('promote', promote);
  bot.command('demote', demote);
  bot.command('uauthorize', authorizeUser);
  bot.command('uunauthorize', unauthorizeUser);
  bot.command('cauthorize', authorizeChat);
  bot.command('cunauthorize', unauthorizeChat);
  bot.command('nickname', nickname);
  bot.command('status', status);
  bot.command('users', users);
  bot.command('chats', chats);

  bot.onInlineQuery(onInlineQuery);

  bot.onMyChatMember(myChatMember);

  bot.onText(onMessage);

  final talker = container.read(loggerProvider);
  bot.onStop(() => talker.info("The bot has been stopped."));

  // Need to send a pr to televerse: final botUser = await bot.getMe();
  // talker.info("Starting bot ${botUser.firstName} (${botUser.username})...");

  await bot.start();

  talker.info("Tidying resources...");
  container.dispose();
  talker.info("Resources tidied up. Bye bye!");
}
