import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:telebalt/src/bot/common/context.dart';
import 'package:telebalt/src/consts.dart';
import 'package:telebalt/src/services/local/database/database.dart';
import 'package:telebalt/src/services/network/network.dart';
import 'package:televerse/telegram.dart' as tg;
import 'package:televerse/televerse.dart';

part 'handlers/on_message.dart';
part 'handlers/promote.dart';
part 'handlers/authorize.dart';
part 'handlers/misc_handlers.dart';
part 'handlers/nickname.dart';
