part of '../../network.dart';

@freezed
class DownloadedMediaResponse with _$DownloadedMediaResponse {
  const factory DownloadedMediaResponse({
    required List<String> ids,
    required String filename,
  }) = _DownloadedMediaResponse;
}
