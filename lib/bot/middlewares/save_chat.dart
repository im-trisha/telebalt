part of '../middlewares.dart';

class SaveChat implements Middleware<TgContext> {
  @override
  Future<void> handle(TgContext ctx, NextFunction next) async {
    final chat = ctx.chat;
    final isPrivate = [ChatType.private, ChatType.sender].contains(chat?.type);

    if (chat == null || isPrivate) return;

    await ctx.chats.upsert(
      chat.id,
      type: DbChatType.fromTelegram(chat.type),
      title: chat.title,
      firstName: chat.firstName,
      lastName: chat.lastName,
      username: chat.username,
      isForum: chat.isForum,
      isAuthorized: false,
    );

    await next();
  }
}
