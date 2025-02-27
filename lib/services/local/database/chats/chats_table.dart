part of '../database.dart';

enum DbChatType {
  private,
  group,
  supergroup,
  channel;

  const DbChatType();
  ChatType asTelegram() => switch (this) {
    DbChatType.private => ChatType.private,
    DbChatType.group => ChatType.group,
    DbChatType.supergroup => ChatType.supergroup,
    DbChatType.channel => ChatType.channel,
  };

  static DbChatType fromTelegram(ChatType type) => switch (type) {
    ChatType.private || ChatType.sender => DbChatType.private,
    ChatType.group => DbChatType.group,
    ChatType.supergroup => DbChatType.supergroup,
    ChatType.channel => DbChatType.channel,
  };
}

@TableIndex(name: 'usernames', columns: {#username})
@TableIndex(name: 'titles', columns: {#title})
@DataClassName('Chat')
class Chats extends Table with Timestamps {
  IntColumn get id => integer()();

  TextColumn get type => textEnum<DbChatType>()();
  TextColumn get title => text().nullable()();
  TextColumn get username => text().nullable()();
  TextColumn get firstName => text().nullable()();
  TextColumn get lastName => text().nullable()();
  BoolColumn get isForum => boolean().nullable()();

  BoolColumn get isAuthorized => boolean().withDefault(Constant(false))();

  @override
  Set<Column<Object>>? get primaryKey => {id};
}
