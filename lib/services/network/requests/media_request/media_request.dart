part of '../../network.dart';

@freezed
sealed class MediaRequest with _$MediaRequest {
  const factory MediaRequest({
    required String url,
    @Default(VideoQuality.max) VideoQuality videoQuality,
    @Default(AudioFormat.best) AudioFormat audioFormat,
    @Default(AudioBitrate.b128) AudioBitrate audioBitrate,
    @Default(FilenameStyle.nerdy) FilenameStyle filenameStyle,
    @Default(DownloadMode.auto) DownloadMode downloadMode,
    @Default(VideoCodec.h264) VideoCodec? youtubeVideoCodec,
    @JsonKey(defaultValue: null, includeIfNull: false) String? youtubeDubLang,
    @Default(false) bool? alwaysProxy,
    @Default(false) bool? disableMetadata,
    @Default(false) bool? tiktokFullAudio,
    @Default(false) bool? tiktokH265,
    @Default(true) bool? twitterGif,
    @Default(false) bool? youtubeHLS,
  }) = _MediaRequest;

  factory MediaRequest.fromJson(Map<String, Object?> json) =>
      _$MediaRequestFromJson(json);
}

@JsonEnum(valueField: 'style')
enum FilenameStyle {
  classic("classic"),
  pretty("pretty"),
  basic("basic"),
  nerdy("nerdy");

  const FilenameStyle(this.style);
  final String style;
}

@JsonEnum(valueField: 'codec')
enum VideoCodec {
  h264("h264"),
  av1("av1"),
  vp9("vp9");

  const VideoCodec(this.codec);
  final String codec;
}

@JsonEnum(valueField: 'quality')
enum VideoQuality {
  q144p("144"),
  q240p("240"),
  q360p("360"),
  q480p("480"),
  q720p("720"),
  q1080p("1080"),
  q1440p("1440"),
  q2180p("2160"),
  max("max");

  const VideoQuality(this.quality);
  final String quality;
}

@JsonEnum(valueField: 'format')
enum AudioFormat {
  mp3("mp3"),
  ogg("ogg"),
  opus("opus"),
  wav("wav"),
  best("best");

  const AudioFormat(this.format);
  final String format;
}

@JsonEnum(valueField: 'bitrate')
enum AudioBitrate {
  b320("320"),
  b256("256"),
  b128("128"),
  b96("96"),
  b64("64"),
  b8("8");

  const AudioBitrate(this.bitrate);
  final String bitrate;
}

@JsonEnum(valueField: 'mode')
enum DownloadMode {
  auto("auto"),
  audio("b256"),
  mute("b128");

  const DownloadMode(this.mode);
  final String mode;
}
