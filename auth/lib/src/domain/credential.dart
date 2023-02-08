import 'package:flutter/foundation.dart';

class Credential {
  final AuthType type;
  late final String name;
  late final String email;
  late final String password;

  Credential({
    @required required this.type,
    required this.name,
    @required required this.email,
    required this.password
  });
}

enum AuthType {email, google}
