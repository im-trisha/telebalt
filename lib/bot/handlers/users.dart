part of '../handlers.dart';

String _mapUser(User u) {
  return '${u.id}: ${u.friendlyNickname ?? 'No nickname'} (${u.username ?? 'No username'})';
}

Future<void> users(TgContext ctx) async {
  final user = await ctx.user();
  if (user == null || !user.isAdmin) return;

  final users = await ctx.users.all();

  // This is a private bot, as such we shouldn't really have that much users, so no bothering in splitting up the message
  final textified = users.map(_mapUser).join('\n');

  await ctx.reply(ctx.t(user).commands.users.success(users: textified));
  await ctx.deleteMessage();
}

Future<void> authorizeUser(TgContext ctx) async {
  final user = await ctx.user();
  if (user == null || !user.isAdmin) return;

  final target = await ctx.target();
  if (target == null) return;

  await ctx.users.patch(target.id, isAuthorized: true);
  await ctx.reply(ctx.t(user).commands.authorize.userSuccess);
}

Future<void> unauthorizeUser(TgContext ctx) async {
  final user = await ctx.user();
  if (user == null || !user.isAdmin) return;

  final target = await ctx.target();
  if (target == null) return;

  await ctx.users.patch(target.id, isAuthorized: false);
  await ctx.reply(ctx.t(user).commands.unauthorize.userSuccess);
}
