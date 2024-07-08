part of '../handlers.dart';

Future<void> myChatMember(TgContext ctx) async {
  if (ctx.chat?.type != ChatType.private) await ctx.leaveChat();
}
