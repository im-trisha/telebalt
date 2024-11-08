import 'package:dart_dotenv/dart_dotenv.dart';
import 'package:dio/dio.dart';
import 'package:riverpod/riverpod.dart';
import 'package:talker/talker.dart';
import 'package:telebalt/bot/common/context.dart';
import 'package:telebalt/consts.dart';
import 'package:telebalt/models/models.dart';
import 'package:telebalt/services/local/database/database.dart';
import 'package:telebalt/services/network/cobalt_service/cobalt.dart';
import 'package:televerse/televerse.dart';

part 'services/settings.dart';
part 'services/bot.dart';
part 'services/cobalt.dart';
part 'services/database.dart';
part 'services/logger.dart';
part 'services/dio.dart';
