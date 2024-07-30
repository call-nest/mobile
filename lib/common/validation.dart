class Validation{
  static bool isEmail(String email){
    return RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);
  }

  static bool isPassword(String password){
    return password.length >= 6;
  }

  static bool isName(String name){
    return name.length >= 3;
  }
}