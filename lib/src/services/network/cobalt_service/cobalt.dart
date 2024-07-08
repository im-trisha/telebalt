import 'dart:math';

import 'package:dio/dio.dart' hide Headers;
import 'package:path/path.dart' as p;
import 'package:retrofit/retrofit.dart';
import 'package:telebalt/src/consts.dart';
import 'package:telebalt/src/services/network/network.dart';

part 'cobalt.g.dart';

@RestApi()
abstract class CobaltService {
  factory CobaltService(Dio dio, {String baseUrl}) = _CobaltService;

  @GET('/api/serverInfo')
  Future<ServerInfo> serverInfo();

  @POST('/api/json')
  @Headers({
    'Accept': 'application/json',
    'Content-Type': 'application/json',
  })
  Future<MediaResponse> getMedia(@Body() MediaRequest request);
}

const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';

extension Download on CobaltService {
  String randomId([int len = 32]) {
    var r = Random();
    return List.generate(len, (index) => _chars[r.nextInt(_chars.length)])
        .join();
  }

  Future<DownloadedMediaResponse> download(
    MediaResponse media, {
    required String savePath,
  }) async {
    final single = media.status != MediaStatus.picker;
    final urls =
        single ? [media.url!] : media.picker.map((e) => e.url).toList();
    final fileIds = List.generate(urls.length, (_) => randomId());

    late Response lastRes;
    for (int i = 0; i < urls.length; ++i) {
      lastRes = await Dio().download(urls[i], p.join(savePath, fileIds[i]));
    }

    final header = (lastRes.headers['content-disposition'] ?? [''])[0];
    final filename = K.filenameRegex.firstMatch(header);

    return DownloadedMediaResponse(
      ids: fileIds,
      filename: filename?.group(1) ?? savePath,
    );
  }
}
