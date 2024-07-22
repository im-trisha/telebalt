part of '../handlers.dart';

Future<void> promote(TgContext ctx) async {
  final user = await ctx.user();
  if (user == null || !user.isAdmin) return;

  final target = await ctx.target();
  if (target == null) return;

  await ctx.users.patch(target.id, isAdmin: true);
  await ctx.reply(ctx.t(user).commands.promote.success);
}

Future<void> demote(TgContext ctx) async {
  final user = await ctx.user();
  if (user == null || !user.isAdmin) return;

  final target = await ctx.target();
  if (target == null) return;

  await ctx.users.patch(target.id, isAdmin: false);
  await ctx.reply(ctx.t(user).commands.demote.success);
}
