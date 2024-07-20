part of '../handlers.dart';

Future<void> onInlineQuery(TgContext ctx) async {
  final user = await ctx.user();
  if (user == null || (!user.isAuthorized && !user.isAdmin)) return;

  final url = ctx.inlineQuery!.query;

  final media = await handleUrl(
    ctx,
    url: url,
    chat: ID.create(user.id),
    sendIfExists: false,
    isInline: true,
  );

  if (media.isPicker && media.fileIds.length > 1) {
    await ctx.answerInlineQuery(
      InlineQueryResultBuilder()
          .article(
            'invalid-url',
            ctx.t(user).pickerUnsupported,
            (gen) => gen.text(ctx.t(user).pickerUnsupportedDetails),
          )
          .build(),
    );
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
