part of '../../network.dart';

@JsonEnum(valueField: 'pattern')
enum FilenamePattern {
  classic("classic"),
  pretty("pretty"),
  basic("basic"),
  nerdy("nerdy");

  const FilenamePattern(this.pattern);
  final String pattern;
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

@freezed
class MediaRequest with _$MediaRequest {
  const factory MediaRequest({
    required String url,
    @Default(VideoQuality.max) VideoQuality vQuality,
    @Default(AudioFormat.best) AudioFormat aFormat,
    @Default(FilenamePattern.nerdy) FilenamePattern filenamePattern,
    @Default(true) bool? tiktokH265,
    @Default(VideoCodec.h264) VideoCodec? vCodec,
    @Default(false) bool? isAudioOnly,
    @Default(false) bool? isTTFullAudio,
    @Default(false) bool? isAudioMuted,
    @Default(false) bool? dubLang,
    @Default(false) bool? disableMetadata,
    @Default(false) bool? twitterGif,
  }) = _MediaRequest;

  factory MediaRequest.fromJson(Map<String, Object?> json) =>
      _$MediaRequestFromJson(json);
}
