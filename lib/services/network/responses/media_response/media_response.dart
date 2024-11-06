part of '../../network.dart';

@Freezed(unionKey: 'status')
sealed class MediaResponse with _$MediaResponse {
  const factory MediaResponse({
    required ResponseStatus status,
  }) = _MediaResponse;

  @FreezedUnionValue('tunnel')
  @FreezedUnionValue('redirect')
  const factory MediaResponse.tunnelRedirect({
    required ResponseStatus status,
    required String url,
    required String filename,
  }) = RedirectResponse;

  @FreezedUnionValue('picker')
  const factory MediaResponse.picker({
    required ResponseStatus status,
    String? audio,
    String? audioFilename,
    required List<PickerItem> picker,
  }) = PickerResponse;

  @FreezedUnionValue('error')
  const factory MediaResponse.error({
    required ResponseStatus status,
    required ErrorDetail error,
  }) = ErrorResponse;

  factory MediaResponse.fromJson(Map<String, dynamic> json) =>
      _$MediaResponseFromJson(json);
}

@freezed
class PickerItem with _$PickerItem {
  const factory PickerItem({
    required String type,
    required String url,
    String? thumb,
  }) = _PickerItem;

  factory PickerItem.fromJson(Map<String, dynamic> json) =>
      _$PickerItemFromJson(json);
}

@freezed
class ErrorDetail with _$ErrorDetail {
  const factory ErrorDetail({
    required String code,
    ErrorContext? context,
  }) = _ErrorDetail;

  factory ErrorDetail.fromJson(Map<String, dynamic> json) =>
      _$ErrorDetailFromJson(json);
}

@freezed
class ErrorContext with _$ErrorContext {
  const factory ErrorContext({
    String? service,
    int? limit,
  }) = _ErrorContext;

  factory ErrorContext.fromJson(Map<String, dynamic> json) =>
      _$ErrorContextFromJson(json);
}

@JsonEnum(valueField: 'status')
enum ResponseStatus {
  error("error"),
  picker("picker"),
  redirect("redirect"),
  tunnel("tunnel");

  const ResponseStatus(this.status);
  final String status;
}

@JsonEnum(valueField: 'status')
enum PickerStatus {
  photo("photo"),
  video("video"),
  gif("gif");

  const PickerStatus(this.status);
  final String status;
}
