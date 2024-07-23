part of '../handlers.dart';

Future<void> onInlineQuery(TgContext ctx) async {
  final user = await ctx.user();
  if (user == null || (!user.isAuthorized && !user.isAdmin)) return;

  final url = ctx.inlineQuery!.query.trim();
  if (url.isEmpty) return;

  var title = ctx.t(user).pickerUnsupported;
  final content = ctx.t(user).pickerUnsupportedDetails;

  late final Media media;
  try {
    media = await handleUrl(
      ctx,
      url: url,
      chat: ID.create(user.id),
      sendIfExists: false,
      isInline: true,
    );
  } catch (e) {
    await ctx.answerInlineQuery([textInlineQuery('invalid', title, content)]);
    return;
  }

  if (media.isPicker && media.fileIds.length > 1) {
    await ctx.answerInlineQuery([textInlineQuery('invalid', title, content)]);
    return;
  }

  late final tg.InlineQueryResult result;

  title = ctx.t(user).inline.hereAreTheResults;
  if (media.isPicker) {
    result = tg.InlineQueryResultCachedPhoto(
      photoFileId: media.fileIds.first,
      id: 'result',
      title: title,
      replyMarkup: shareButton(url),
    );
  } else {
    result = tg.InlineQueryResultCachedVideo(
      videoFileId: media.fileIds.first,
      id: 'result',
      title: title,
      replyMarkup: shareButton(url),
    );
  }

  await ctx.answerInlineQuery([result], cacheTime: 3600);
}
