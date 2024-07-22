part of '../handlers.dart';

Future<void> authorize(TgContext ctx) async {
  final user = await ctx.user();
  if (user == null || !user.isAdmin) return;

  final target = await ctx.target();
  if (target == null) return;

  await ctx.users.patch(target.id, isAuthorized: true);
  await ctx.reply(ctx.t(user).commands.authorize.success);
}

Future<void> unauthorize(TgContext ctx) async {
  final user = await ctx.user();
  if (user == null || !user.isAdmin) return;

  final target = await ctx.target();
  if (target == null) return;

  await ctx.users.patch(target.id, isAuthorized: false);
  await ctx.reply(ctx.t(user).commands.unauthorize.success);
}
