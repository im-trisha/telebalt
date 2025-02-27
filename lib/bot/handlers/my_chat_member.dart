part of '../handlers.dart';

Future<void> myChatMember(TgContext ctx) async {
  final chatMember = ctx.myChatMember!;
  final chat = chatMember.chat;

  switch (chat.type) {
    case ChatType.channel:
      await ctx.leaveChat();
      break;
    case ChatType.group || ChatType.supergroup:
      final dbchat = await ctx.chats.read(chat.id);
      if (dbchat != null && dbchat.isAuthorized) return;

      if (chatMember.newChatMember.status.isMember()) await ctx.leaveChat();

      break;
    default:
      return;
  }
}

extension on ChatMemberStatus {
  bool isMember() =>
      this == ChatMemberStatus.member ||
      this == ChatMemberStatus.administrator ||
      this == ChatMemberStatus.creator;
}
