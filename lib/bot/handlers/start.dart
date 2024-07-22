part of '../handlers.dart';

Future<void> start(TgContext ctx) async {
  await ctx.reply(ctx.t(await ctx.user()).commands.start);
}
