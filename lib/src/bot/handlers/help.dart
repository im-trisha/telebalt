part of '../handlers.dart';

Future<void> help(TgContext ctx) async {
  await ctx.reply(ctx.t(await ctx.user()).commands.help);
}
