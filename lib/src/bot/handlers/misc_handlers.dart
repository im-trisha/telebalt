part of '../handlers.dart';

Future<void> start(TgContext ctx) async {
  await ctx.reply(ctx.t(await ctx.user()).commands.start);
}

Future<void> help(TgContext ctx) async {
  await ctx.reply(ctx.t(await ctx.user()).commands.help);
}

Future<void> myChatMember(TgContext ctx) async {
  if (ctx.chat?.type != ChatType.private) await ctx.leaveChat();
}

Future<void> onError(BotError<TgContext> error) async {
  final message = """An error has occurred. Here's some info:
IsMiddleware: <code>${error.sourceIsMiddleware}</code>
Update: <code>${error.ctx?.update.type.name}</code>
Text (If any): <code>${error.ctx?.message?.text}</code>
Error: <code>${error.error}</code>
Stacktrace: <code>${error.stackTrace}</code>""";
  error.ctx?.logger.error(message);

  final chatId = ID.create(error.ctx?.settings.adminId);
  try {
    // TODO: Televerse produces an error, add ParseMode as soon as the lib fixes the error
    await error.ctx?.api.sendMessage(chatId, message);
  } catch (_, __) {
    await error.ctx?.api.sendMessage(chatId, "An error has occurred");
  }
}
