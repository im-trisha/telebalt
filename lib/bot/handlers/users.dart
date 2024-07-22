part of '../handlers.dart';

String _mapper(User u) {
  return '${u.id}: ${u.friendlyNickname ?? 'No nickname'} (${u.username ?? 'No username'})';
}

Future<void> users(TgContext ctx) async {
  final user = await ctx.user();
  if (user == null || !user.isAdmin) return;

  final users = await ctx.users.all();
  // This is a private bot, as such we shouldn't really have that much users, so no bothering in splitting up the message
  final textified = users.map(_mapper).join('\n');

  await ctx.reply(ctx.t(user).commands.users.success(users: textified));
  await ctx.deleteMessage();
}
