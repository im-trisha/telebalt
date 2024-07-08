
FROM dart:stable AS build

WORKDIR /app

COPY pubspec.* ./
RUN dart pub get

COPY . .
RUN dart run slang
RUN dart run build_runner build -d

RUN dart compile exe bin/telebalt.dart -o /app/telebalt

FROM alpine:latest

RUN apk add --no-cache libstdc++ sqlite-libs gcompat ca-certificates
RUN ln -s /usr/lib/libsqlite3.so.0 /usr/lib/libsqlite3.so

WORKDIR /app

COPY --from=build /app/telebalt /app/telebalt
COPY .env /app/.env

CMD ["./telebalt"]