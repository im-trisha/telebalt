part of '../handlers.dart';

Future<void> onMessage(TgContext ctx) async {
  final text = ctx.message?.text, user = await ctx.user();
  // Invalid message
  if (text == null || user == null || !K.urlRegex.hasMatch(text)) return;

  // Unauthorized user
  if (!user.isAuthorized && !user.isAdmin) return;

  final media = await ctx.media.read(text);
  if (media != null) {
    _sendFromMedia(ctx, media);
    return;
  }

  final res = await ctx.cobalt.getMedia(MediaRequest(url: text));

  await ctx.react('👍');
  await ctx.replyWithChatAction(ChatAction.uploadDocument);

  final downloadRes = await ctx.cobalt.download(
    res,
    savePath: ctx.settings.storagePath,
  );

  await ctx.media.create(text, downloadRes.ids, downloadRes.filename);
  await _sendFromMedia(ctx, (await ctx.media.read(text))!);
}

Future<void> _sendFromMedia(TgContext ctx, Media media) async {
  final ids = media.videoIds;
  final user = await ctx.user();
  final caption = ctx.t(user).commands.sentBy(name: user?.firstName ?? '???');
  await ctx.deleteMessage();

  if (ids.length == 1) {
    final file = File(p.join(ctx.settings.storagePath, ids.first));
    await ctx.replyWithVideo(
      InputFile.fromFile(file, name: media.name),
      caption: caption,
    );
    return;
  }

  for (var i = 0; i < ids.length; i += 10) {
    int end = (i + 10 < ids.length) ? i + 10 : ids.length;
    final chunk = ids.sublist(i, end);

    await ctx.replyWithMediaGroup([
      for (final id in chunk)
        tg.InputMediaPhoto(
          media: InputFile.fromFile(File(p.join(ctx.settings.storagePath, id))),
        ),
    ]);
  }
  await ctx.reply(caption);
}
