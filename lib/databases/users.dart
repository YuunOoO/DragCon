import 'dart:html';

final String userNotes = "users";

class UsersFields {
  static final String key_id = '_key_id';
  static final String admin = 'admin';
  static final String password = 'password';
  static final String id = 'id';
}

class Users {
  final int? key_id;
  final bool admin;
  final String password;
  final String id;

  const Users(
      {this.key_id,
      required this.admin,
      required this.id,
      required this.password});

  Map<String, Object?> toJson() => {
        UsersFields.key_id: key_id,
        UsersFields.admin: admin ? 1 : 0,
        UsersFields.id: id,
        UsersFields.password: password
      };

  Users copy({
    int? key_id,
    bool? admin,
    String? id,
    String? password,
  }) =>
      Users(
        key_id: key_id ?? this.key_id,
        admin: admin ?? this.admin,
        id: id ?? this.id,
        password: password ?? this.password,
      );
}
