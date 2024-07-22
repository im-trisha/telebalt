part of '../../network.dart';

@freezed
class ServerInfo with _$ServerInfo {
  const factory ServerInfo({
    required String version,
    required String commit,
    required String branch,
    required String name,
    required String url,
    required int cors,
    required String startTime,
  }) = _ServerInfo;

  factory ServerInfo.fromJson(Map<String, Object?> json) =>
      _$ServerInfoFromJson(json);
}
