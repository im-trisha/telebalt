part of '../handlers.dart';

Future<void> nickname(TgContext ctx) async {
  final user = await ctx.user();
  if (user == null || (!user.isAdmin && !user.isAuthorized)) return;

  if (ctx.args.length < 2) {
    await ctx.reply(ctx.t(user).errors.notEnoughArgs);
    return;
  }

  final target = await ctx.target();
  if (target == null) return;

  final friendlyNickname = ctx.args.sublist(1).join(' ');
  await ctx.users.patch(target.id, friendlyNickname: friendlyNickname);

  final text = ctx.t(user).commands.nickname.success(name: target.firstName);
  await ctx.reply(text);
  await ctx.deleteMessage();
}
