import 'package:televerse/telegram.dart';
import 'package:televerse/televerse.dart';

InlineMenu shareButton(String url) => InlineMenu().switchInlineQuery('➕', url);

InlineQueryResult textInlineQuery(String id, String title, String content) {
  return InlineQueryResultArticle(
    id: id,
    title: title,
    inputMessageContent: InputTextMessageContent(messageText: content),
  );
}
