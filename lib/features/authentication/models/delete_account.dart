class DeleteAccount{
  int id;
  String password;

  DeleteAccount({required this.id, required this.password});

  Map<String, dynamic> toJson() {
    return {
      'id' : id,
      'password': password,
    };
  }
}