part of '../handlers.dart';

Future<void> status(TgContext ctx) async {
  final user = await ctx.user();
  if (user == null || !user.isAdmin) return;

  final target = await ctx.target();
  if (target == null) return;

  final text = ctx.t(user).commands.status.success(
        id: target.id,
        firstName: target.firstName,
        lastName: target.lastName ?? '???',
        username: target.username != null ? '@${target.username}' : '???',
        language: target.language,
        friendlyNickname: target.friendlyNickname ?? '???',
        isAdmin: target.isAdmin,
        isAuthorized: target.isAuthorized,
        isPremium: target.isPremium,
      );
  await ctx.reply(text);
  await ctx.deleteMessage();
}
