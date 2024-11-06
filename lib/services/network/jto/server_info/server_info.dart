part of '../../network.dart';

@freezed
class ServerInfo with _$ServerInfo {
  const factory ServerInfo({
    required CobaltInfo cobalt,
    required GitInfo git,
  }) = _ServerInfo;

  factory ServerInfo.fromJson(Map<String, Object?> json) =>
      _$ServerInfoFromJson(json);
}

@freezed
class CobaltInfo with _$CobaltInfo {
  const factory CobaltInfo({
    required String version,
    required String url,
    required String startTime,
    required double durationLimit,
    required List<String> services,
  }) = _CobaltInfo;

  factory CobaltInfo.fromJson(Map<String, Object?> json) =>
      _$CobaltInfoFromJson(json);
}

@freezed
class GitInfo with _$GitInfo {
  const factory GitInfo({
    required String commit,
    required String branch,
    required String remote,
  }) = _GitInfo;

  factory GitInfo.fromJson(Map<String, Object?> json) =>
      _$GitInfoFromJson(json);
}
