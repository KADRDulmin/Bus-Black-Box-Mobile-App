class LoggedUser {
  static int User = 1;
  static int Guardian = 2;
  static int Admin = 3;
  static int Doctor = 4;

  var uid, name, mobile, email, type, user;

  LoggedUser({this.uid, this.name, this.email, this.type, this.user});
}
