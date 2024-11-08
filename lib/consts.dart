class K {
  const K._();

  static const defaultLang = 'en';

  static final urlRegex = RegExp(
    r'http[s]?://(?:[a-zA-Z]|[0-9]|[$-_@.&+]|[!*\(\),]|(?:%[0-9a-fA-F][0-9a-fA-F]))+',
  );
}
