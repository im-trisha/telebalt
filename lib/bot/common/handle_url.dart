import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:telebalt/bot/common/context.dart';
import 'package:telebalt/bot/common/utils.dart';
import 'package:telebalt/services/local/database/database.dart';
import 'package:telebalt/services/network/network.dart';
import 'package:televerse/telegram.dart' as tg;
import 'package:televerse/televerse.dart';

Future<Media> handleUrl(
  TgContext ctx, {
  required String url,
  required ID chat,
  String? caption,
  bool sendIfExists = true,
  bool isInline = false,
}) async {
  final media = await ctx.media.read(url);

  if (media != null) {
    if (!sendIfExists) return media;

    await _sendMedia(
      ctx,
      caption: caption,
      mediaName: media.name,
      isPicker: media.isPicker,
      mediaIds: media.fileIds,
      isLocal: false,
      chatId: chat,
      url: url,
    );

    return media;
  }

  final res = await ctx.cobalt.getMedia(MediaRequest(url: url));
  if (res is ErrorResponse) throw res;

  if (!isInline) await ctx.replyWithChatAction(ChatAction.uploadDocument);

  final downloadRes = await ctx.cobalt.download(res, ctx.settings.storagePath);

  final fileIds = await _sendMedia(
    ctx,
    caption: caption,
    mediaName: downloadRes.filename,
    isPicker: res.status == ResponseStatus.picker,
    mediaIds: downloadRes.ids,
    isLocal: true,
    chatId: chat,
    url: url,
  );

  return await ctx.media.create(
    url: url,
    fileIds: fileIds,
    videoIds: downloadRes.ids,
    isPicker: res.status == ResponseStatus.picker,
    name: downloadRes.filename,
  );
}

Future<List<String>> _sendMedia(
  TgContext ctx, {
  required String mediaName,
  required bool isPicker,
  required List<String> mediaIds,
  required bool isLocal,
  required ID chatId,
  String? caption,
  required String url,
}) async {
  if (mediaIds.length == 1) {
    late final tg.Message res;
    late final InputFile inputFile;

    if (isLocal) {
      final file = File(p.join(ctx.settings.storagePath, mediaIds.first));
      inputFile = InputFile.fromFile(file, name: mediaName);
    } else {
      inputFile = InputFile.fromFileId(mediaIds.first, name: mediaName);
    }

    if (isPicker) {
      res = await ctx.api.sendPhoto(
        chatId,
        inputFile,
        caption: caption,
        replyMarkup: shareButton(url),
      );
    } else {
      res = await ctx.api.sendVideo(
        chatId,
        inputFile,
        caption: caption,
        replyMarkup: shareButton(url),
      );
    }
    return [res.video?.fileId ?? res.photo!.first.fileId];
  }

  final resultIds = <String>[];
  for (var i = 0; i < mediaIds.length; i += 10) {
    int end = (i + 10 < mediaIds.length) ? i + 10 : mediaIds.length;
    final chunk = mediaIds.sublist(i, end);

    final inputs =
        chunk.map((id) {
          if (isLocal) {
            final file = File(p.join(ctx.settings.storagePath, id));
            return tg.InputMediaPhoto(media: InputFile.fromFile(file));
          } else {
            return tg.InputMediaPhoto(media: InputFile.fromFileId(id));
          }
        }).toList();

    final msg = await ctx.replyWithMediaGroup(inputs);
    resultIds.addAll(msg.map((e) => e.photo!.first.fileId));
  }

  if (caption != null) await ctx.api.sendMessage(chatId, caption);

  return resultIds;
}
