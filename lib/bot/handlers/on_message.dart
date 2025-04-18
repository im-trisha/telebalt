part of '../handlers.dart';

Future<void> onMessage(TgContext ctx) async {
  final text = ctx.message?.text?.trim(), user = await ctx.user();
  // Invalid message
  if (text == null || user == null || !K.urlRegex.hasMatch(text)) return;

  // Unauthorized user
  if (!user.isAuthorized && !user.isAdmin) return;

  final fromName = user.friendlyNickname ?? user.firstName;
  final caption = ctx.t(user).commands.sentBy(name: fromName);

  try {
    await ctx.react('👍');
    await handleUrl(ctx, url: text, chat: ctx.chat!.getId(), caption: caption);
    await ctx.deleteMessage();
  } on ErrorResponse catch (e) {
    await ctx.react('💔');

    final code = e.error.code.split('error.api.').last;
    final errorContext = e.error.context?.toJson() ?? {};
    await ctx.reply(ctx.t(user).errors.api[code]?.format(errorContext) ?? code);
  } catch (e) {
    await ctx.react('💔');
    await ctx.reply(ctx.t(user).errors.generic);
  }
}
