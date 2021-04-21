class AccountDto {
  final String url;
  final String token;
  String? name;

  AccountDto({ required this.url, required this.token, this.name });

  @override
  String toString() {
    // TODO: implement toString
    return 'Account($url, $token, $name)';
  }
}
