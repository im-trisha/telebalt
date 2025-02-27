import 'dart:math';

import 'package:dio/dio.dart' hide Headers;
import 'package:path/path.dart' as p;
import 'package:retrofit/retrofit.dart';
import 'package:telebalt/services/network/network.dart';

part 'cobalt.g.dart';

@RestApi()
abstract class CobaltService {
  factory CobaltService(Dio dio, {String baseUrl}) = _CobaltService;

  @GET('/')
  Future<ServerInfo> serverInfo();

  @POST('/')
  @Headers({'Accept': 'application/json', 'Content-Type': 'application/json'})
  Future<MediaResponse> getMedia(@Body() MediaRequest request);
}

const _c = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
final _r = Random.secure();

extension Download on CobaltService {
  String _randId([int len = 32]) {
    return List.generate(len, (index) => _c[_r.nextInt(_c.length)]).join();
  }

  Future<DownloadedMediaResponse> download(
    MediaResponse media,
    String savePath,
  ) async {
    final (List<String> fileIds, urls, filename) = switch (media) {
      TunnelResponse res => ([_randId()], [res.url], res.filename),
      RedirectResponse res => ([_randId()], [res.url], res.filename),
      PickerResponse res => (
        List.generate(res.picker.length, (_) => _randId()),
        res.picker.map((e) => e.url).toList(),
        'multiples',
      ),
      ErrorResponse r =>
        throw Exception('Error while handling response: ${r.toJson()}'),
    };

    for (int i = 0; i < urls.length; i++) {
      await Dio().download(urls[i], p.join(savePath, fileIds[i]));
    }

    return DownloadedMediaResponse(ids: fileIds, filename: filename);
  }
}
