import 'package:televerse/telegram.dart';

InlineQueryResult textInlineQuery(String id, String title, String content) {
  return InlineQueryResultArticle(
    id: id,
    title: title,
    inputMessageContent: InputTextMessageContent(messageText: content),
  );
}
