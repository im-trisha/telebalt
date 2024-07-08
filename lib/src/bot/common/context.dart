import 'package:talker/talker.dart';
import 'package:telebalt/src/consts.dart';
import 'package:telebalt/src/i18n/strings.g.dart';
import 'package:telebalt/src/models/models.dart';
import 'package:telebalt/src/services/local/database/database.dart';
import 'package:telebalt/src/services/network/network.dart';
import 'package:televerse/televerse.dart';

final _translations = AppLocale.values.asNameMap();

class TgContext extends Context {
  final Settings settings;
  final Database db;
  final Talker logger;
  final CobaltService cobalt;

  final UsersDAO users;
  final MediaDAO media;

  TgContext({
    required super.api,
    required super.me,
    required super.update,
    required this.settings,
    required this.db,
    required this.logger,
    required this.cobalt,
  })  : media = MediaDAO(db),
        users = UsersDAO(db);

  // Static method that returns ContextConstructor
  static ContextConstructor<TgContext> create(
    Settings settings,
    Database db,
    Talker logger,
    CobaltService cobalt,
  ) {
    return ({required api, required me, required update}) async {
      return TgContext(
        api: api,
        me: me,
        update: update,
        settings: settings,
        db: db,
        logger: logger,
        cobalt: cobalt,
      );
    };
  }

  Translations t(User? user) =>
      (_translations[user?.language ?? K.defaultLang]!).translations;

  User? _user;
  Future<User?> user() async {
    if (_user != null) return _user;

    final tgUser = from;
    if (tgUser == null) return null;
    _user = await users.read(tgUser.id);
    return _user;
  }

  Future<User?> target() async {
    final i18n = t(await user());

    if (args.length != 1) {
      await reply(i18n.badArgsUser);
      return null;
    }

    final maybeId = int.tryParse(args.first);
    final target = maybeId == null
        ? await users.readUsername(args.first)
        : await users.read(maybeId);

    if (target == null) {
      await reply(i18n.unknownUsername);
      return null;
    }

    return target;
  }
}
