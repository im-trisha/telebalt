part of '../../network.dart';

@freezed
class Picker with _$Picker {
  const factory Picker({
    required String url,
    @JsonKey(name: 'thumb') String? thumbnail,
    String? type,
  }) = _Picker;

  factory Picker.fromJson(Map<String, Object?> json) => _$PickerFromJson(json);
}

@freezed
class MediaResponse with _$MediaResponse {
  const factory MediaResponse({
    required MediaStatus status,
    String? url,
    @JsonKey(defaultValue: PickerType.none) required PickerType pickerType,
    @JsonKey(defaultValue: []) required List<Picker> picker,
    // dynamic because this seems to be bool sometimes, even if it should be String?
    dynamic audio,
    String? text,
  }) = _MediaResponse;

  factory MediaResponse.fromJson(Map<String, Object?> json) =>
      _$MediaResponseFromJson(json);
}

@JsonEnum(valueField: 'status')
enum MediaStatus {
  success("success"),
  error("error"),
  redirect("redirect"),
  stream("stream"),
  limited("rate-limit"),
  picker("picker");

  const MediaStatus(this.status);
  final String status;
}

@JsonEnum(valueField: 'type')
enum PickerType {
  various("various"),
  images("images"),
  none(null);

  const PickerType(this.type);
  final String? type;
}
