part of '../../network.dart';

@Freezed(unionKey: 'status')
sealed class MediaResponse with _$MediaResponse {
  @FreezedUnionValue('tunnel')
  const factory MediaResponse.tunnel({
    required ResponseStatus status,
    required String url,
    required String filename,
  }) = TunnelResponse;

  // Seems like we can't just use the same constructor for two different UnionValue
  @FreezedUnionValue('redirect')
  const factory MediaResponse.redirect({
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
sealed class PickerItem with _$PickerItem {
  const factory PickerItem({
    required String type,
    required String url,
    String? thumb,
  }) = _PickerItem;

  factory PickerItem.fromJson(Map<String, dynamic> json) =>
      _$PickerItemFromJson(json);
}

@freezed
sealed class ErrorDetail with _$ErrorDetail {
  const factory ErrorDetail({
    required String code,
    ErrorContext? context,
  }) = _ErrorDetail;

  factory ErrorDetail.fromJson(Map<String, dynamic> json) =>
      _$ErrorDetailFromJson(json);
}

@freezed
sealed class ErrorContext with _$ErrorContext {
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
