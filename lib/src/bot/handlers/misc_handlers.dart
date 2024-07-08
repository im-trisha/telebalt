part of '../handlers.dart';

Future<void> start(TgContext ctx) async {
  await ctx.reply(ctx.t(await ctx.user()).commands.start);
}

Future<void> help(TgContext ctx) async {
  await ctx.reply(ctx.t(await ctx.user()).commands.help);
}

Future<void> onError(BotError<TgContext> error) async {
  error.ctx?.logger.error("""An error has occurred. Here's some info:
IsMiddleware: ${error.sourceIsMiddleware}
Error: ${error.error}
Stacktrace: ${error.stackTrace}
""");
}

Future<void> onStop(Database database) async {
  await database.close();
}
