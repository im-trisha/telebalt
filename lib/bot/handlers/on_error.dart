part of '../handlers.dart';

Future<void> onError(BotError<TgContext> error) async {
  if (error.ctx == null) {
    print(error.pretty());
    return;
  }

  error.ctx?.logger.error(error.pretty());

  try {
    final user = await error.ctx?.user();
    if (error.ctx?.inlineQuery != null || user == null) return;

    await error.ctx?.reply(error.ctx!.t(user).errors.generic);
  } catch (e) {
    // Ignore error
  }
}

extension on BotError<TgContext> {
  String pretty() {
    return """An error has occurred. Here's some info:
IsMiddleware: $sourceIsMiddleware
Update: ${ctx?.update.type.name}
Text (If any): ${ctx?.message?.text}
Error: ${toString()}
Stacktrace: ${stackTrace.toString()}""";
  }
}
