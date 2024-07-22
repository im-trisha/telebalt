
FROM dart:stable AS build

WORKDIR /app

# Cache dart pub get
COPY pubspec.* ./
RUN dart pub get

# Cache slang generated files
COPY lib/i18n lib/i18n 
RUN dart run slang

# Cache generated files
COPY lib/models lib/models
COPY lib/services lib/services
RUN dart run build_runner build -d

COPY . .
RUN dart compile exe bin/telebalt.dart -o /app/telebalt

FROM alpine:latest

RUN apk add --no-cache libstdc++ sqlite-libs gcompat ca-certificates
RUN ln -s /usr/lib/libsqlite3.so.0 /usr/lib/libsqlite3.so

WORKDIR /app

COPY --from=build /app/telebalt /app/telebalt
COPY .env /app/.env

CMD ["./telebalt"]