part of '../models.dart';

@freezed
class Settings with _$Settings {
  const factory Settings({
    @JsonKey(name: 'TOKEN') required String botToken,
    @JsonKey(name: 'COBALT_URL') required String cobaltUrl,
    @JsonKey(name: 'STORAGE_PATH') required String storagePath,
    @JsonKey(name: 'ADMIN_ID') required String adminId,
    @JsonKey(name: 'API_URL') String? apiUrl,
  }) = _Settings;

  factory Settings.fromJson(Map<String, Object?> json) =>
      _$SettingsFromJson(json);
}
