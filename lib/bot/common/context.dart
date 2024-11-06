import 'package:riverpod/riverpod.dart';
import 'package:talker/talker.dart';
import 'package:telebalt/consts.dart';
import 'package:telebalt/i18n/strings.g.dart';
import 'package:telebalt/models/models.dart';
import 'package:telebalt/providers/providers.dart';
import 'package:telebalt/services/local/database/database.dart';
import 'package:telebalt/services/network/network.dart';
import 'package:televerse/televerse.dart';

final _translations = AppLocale.values.asNameMap();

class TgContext extends Context {
  final ProviderContainer container;
  late final UsersDAO users;
  late final MediaDAO media;

  Settings get settings => container.read(settingsProvider);
  Database get db => container.read(databaseProvider);
  Talker get logger => container.read(loggerProvider);
  CobaltService get cobalt => container.read(cobaltServiceProvider);

  TgContext({
    required super.api,
    required super.me,
    required super.update,
    required this.container,
  }) {
    media = MediaDAO(db);
    users = UsersDAO(db);
  }
  // Static method that returns ContextConstructor
  static ContextConstructor<TgContext> create(ProviderContainer container) {
    return ({required api, required me, required update}) async {
      return TgContext(
        api: api,
        me: me,
        update: update,
        container: container,
      );
    };
  }

  Translations t(User? user) {
    final validUser = user != null && _translations.containsKey(user.language);
    final lang = validUser ? user.language : K.defaultLang;
    return (_translations[lang]!).translations;
  }

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

    if (args.isEmpty) {
      await reply(i18n.notEnoughArgs);
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
