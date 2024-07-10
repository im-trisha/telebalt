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
  error.ctx?.logger.error("""An error has occurred. Here's some info:
IsMiddleware: ${error.sourceIsMiddleware}
Update: ${error.ctx?.update.type.name}
Text (If any): ${error.ctx?.message?.text}
Error: ${error.error}
Stacktrace: ${error.stackTrace}
""");
}
