part of '../middlewares.dart';

class SaveUser implements Middleware<TgContext> {
  @override
  Future<void> handle(TgContext ctx, NextFunction next) async {
    final user = ctx.from;
    if (user == null) return await next();

    await ctx.users.upsert(
      user.id,
      firstName: user.firstName,
      lastName: user.lastName,
      language: user.languageCode,
      username: user.username,
    );

    await next();
  }
}
