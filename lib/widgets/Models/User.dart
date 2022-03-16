class User {
  int? id;
  String? firstName;
  String? lastName;
  String? birthDate;
  int? organDonnor;
  String? allergy;
  String? email;
  String? contact;
  String? pathology;
  String? medication;
  String? persontocontact;
  String? relation;
  String? contactnumber;

  User(
      {this.id,
      this.firstName,
      this.lastName,
      this.birthDate,
      this.organDonnor,
      this.allergy,
      this.email,
      this.contact,
      this.pathology,
      this.medication,
      this.persontocontact,
      this.relation,
      this.contactnumber});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        id: json["id"] as int,
        firstName: json["firstname"] as String,
        lastName: json["lastname"] as String,
        birthDate: json["birthdate"] as String,
        organDonnor: json["organdonor"] as int,
        allergy: json["allergy"] as String,
        email: json["username"] as String,
        contact: json["cpnumber"] as String,
        pathology: json["pathology"] as String,
        medication: json["medications"] as String,
        persontocontact: json["persontocontact"] as String,
        relation: json["relation"] as String,
        contactnumber: json["contactnumber"] as String);
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "firstname": firstName,
        "lastname": lastName,
        "birthdate": birthDate,
        "organdonor": organDonnor,
        "allergy": allergy,
        "username": email,
        "cpnumber": contact,
        "pathology": pathology,
        "medication": medication,
        "persontocontact": persontocontact,
        "relation": relation,
        "contactnumber": contactnumber
      };
}
