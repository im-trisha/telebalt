part of '../handlers.dart';

String _mapChat(Chat u) {
  return '${u.id}: ${u.title ?? u.firstName ?? 'Idk'} (${u.username ?? 'No username'})';
}

Future<void> chats(TgContext ctx) async {
  final user = await ctx.user();
  if (user == null || !user.isAdmin) return;

  final chats = await ctx.chats.all();

  // This is a private bot, as such we shouldn't really have that much chats, so no bothering in splitting up the message
  final textified = chats.map(_mapChat).join('\n');

  await ctx.reply(ctx.t(user).commands.users.success(users: textified));
  await ctx.deleteMessage();
}

Future<void> authorizeChat(TgContext ctx) async {
  final user = await ctx.user();
  if (user == null || !user.isAdmin) return;

  final target = await ctx.targetChat();
  if (target == null) return;

  await ctx.chats.patch(target.id, isAuthorized: true);
  await ctx.reply(ctx.t(user).commands.authorize.chatSuccess);
}

Future<void> unauthorizeChat(TgContext ctx) async {
  final user = await ctx.user();
  if (user == null || !user.isAdmin) return;

  final target = await ctx.targetChat();
  if (target == null) return;

  await ctx.users.patch(target.id, isAuthorized: false);
  await ctx.reply(ctx.t(user).commands.unauthorize.chatSuccess);
}
