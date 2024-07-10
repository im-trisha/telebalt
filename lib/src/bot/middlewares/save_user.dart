part of '../middlewares.dart';

class SaveUser implements Middleware<TgContext> {
  @override
  Future<void> handle(
    TgContext ctx,
    NextFunction next,
  ) async {
    final user = ctx.from;
    if (user != null) {
      await ctx.users.patch(
        user.id,
        firstName: user.firstName,
        lastName: user.lastName,
        language: user.languageCode,
        username: user.username,
      );
    }

    await next();
  }
}
