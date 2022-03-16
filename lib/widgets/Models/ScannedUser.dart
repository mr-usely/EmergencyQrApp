class ScannedUser {
  String? name;
  String? birthDate;
  bool? organDonnor;
  String? allergy;
  String? email;
  String? contact;

  ScannedUser(
      {this.name,
      this.birthDate,
      this.organDonnor,
      this.allergy,
      this.email,
      this.contact});

  factory ScannedUser.fromJson(Map<String, dynamic> json) {
    return ScannedUser(
      name: json["Name"] as String,
      birthDate: json["Birthday"] as String,
      organDonnor: json["OrganDonnor"] as bool,
      allergy: json["Allergy"] as String,
      email: json["Email"] as String,
      contact: json["ContactNo"] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        "name": name,
        "Birthday": birthDate,
        "OrganDonnor": organDonnor,
        "Allergy": allergy,
        "Email": email,
        "ContactNo": contact
      };
}
