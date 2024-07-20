part of '../handlers.dart';

Future<void> onInlineQuery(TgContext ctx) async {
  final user = await ctx.user();
  if (user == null || (!user.isAuthorized && !user.isAdmin)) return;

  final url = ctx.inlineQuery!.query;

  if (url.trim().isEmpty) return;

  final Media media = await handleUrl(
    ctx,
    url: url,
    chat: ID.create(user.id),
    sendIfExists: false,
    isInline: true,
  );

  if (media.isPicker && media.fileIds.length > 1) {
    final title = ctx.t(user).pickerUnsupported;
    final content = ctx.t(user).pickerUnsupportedDetails;
    await ctx.answerInlineQuery([textInlineQuery('invalid', title, content)]);
  }

  late final tg.InlineQueryResult result;

  final title = ctx.t(user).inline.hereAreTheResults;
  if (media.isPicker) {
    result = tg.InlineQueryResultCachedPhoto(
      photoFileId: media.fileIds.first,
      id: 'result',
      title: title,
    );
  } else {
    result = tg.InlineQueryResultCachedVideo(
      videoFileId: media.fileIds.first,
      id: 'result',
      title: title,
    );
  }

  await ctx.answerInlineQuery([result], cacheTime: 3600);
}
