import 'package:televerse/televerse.dart';

class K {
  const K._();

  static const defaultLang = 'en';

  static const allowedUpdates = [
    UpdateType.message,
    UpdateType.inlineQuery,
    UpdateType.chatMember,
    UpdateType.myChatMember,
  ];

  static final urlRegex = RegExp(
    r'http[s]?://(?:[a-zA-Z]|[0-9]|[$-_@.&+]|[!*\(\),]|(?:%[0-9a-fA-F][0-9a-fA-F]))+',
  );
}
