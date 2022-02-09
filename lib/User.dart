class User {
  int? id;
  String? firstName;
  String? middleName;
  String? lastName;
  String? email;
  String? contact;

  User(
      {this.id,
      this.firstName,
      this.middleName,
      this.lastName,
      this.email,
      this.contact});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json["ID"] as int,
      firstName: json["FirstName"] as String,
      middleName: json["MiddleName"] as String,
      lastName: json["LastName"] as String,
      email: json["Email"] as String,
      contact: json["ContactNo"] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        "ID": id,
        "FirstName": firstName,
        "MiddleName": middleName,
        ":astName": lastName,
        "Email": email,
        "ContactNo": contact
      };
}
