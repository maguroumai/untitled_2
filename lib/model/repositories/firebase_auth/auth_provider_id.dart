enum AuthProviderId {
  google('google.com'),
  email('password');

  const AuthProviderId(this.value);
  final String value;
}
