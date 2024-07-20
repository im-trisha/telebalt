part of '../handlers.dart';

Future<void> onMessage(TgContext ctx) async {
  final text = ctx.message?.text?.trim(), user = await ctx.user();
  // Invalid message
  if (text == null || user == null || !K.urlRegex.hasMatch(text)) return;

  // Unauthorized user
  if (!user.isAuthorized && !user.isAdmin) return;

  await ctx.react('👍');

  final fromName = user.friendlyNickname ?? user.firstName;
  final caption = ctx.t(user).commands.sentBy(name: fromName);

  await handleUrl(ctx, url: text, chat: ctx.chat!.getId(), caption: caption);
}
