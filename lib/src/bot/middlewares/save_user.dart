part of '../middlewares.dart';

class SaveUser implements Middleware<TgContext> {
  @override
  Future<void> handle(
    TgContext ctx,
    NextFunction next,
  ) async {
    final user = ctx.from, chat = ctx.chat;
    if (user != null) {
      await ctx.users.patch(
        user.id,
        firstName: user.firstName,
        lastName: user.lastName,
        language: user.languageCode,
        username: user.username,
      );
    }

    if (chat != null) {}
    
    await next();
  }
}
