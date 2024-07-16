part of '../handlers.dart';

Future<void> onError(BotError<TgContext> error) async {
  final msg = """An error has occurred. Here's some info:
IsMiddleware: ```${error.sourceIsMiddleware}```
Update: ```${error.ctx?.update.type.name}```
Text (If any): ```${_escapeMDV2(error.ctx?.message?.text)}```
Error: ```${_escapeMDV2(error.error.toString())}```
Stacktrace: ```${_escapeMDV2(error.stackTrace.toString())}```""";

  if (error.ctx == null) {
    print(msg);
    return;
  }

  error.ctx?.logger.error(msg);

  final to = ID.create(error.ctx?.settings.adminId);
  try {
    await error.ctx?.api.sendMessage(to, msg, parseMode: ParseMode.markdownV2);
  } catch (e, s) {
    print(e);
    print(s);
    await error.ctx?.api.sendMessage(to, "An error has occurred");
  }
}

String? _escapeMDV2(String? input) {
  K.mdv2Characters.forEach((k, v) => input = input?.replaceAll(k, v));
  return input;
}
