class Contacts {
  int? accountID;
  String? contactName;
  String? contactRelation;
  String? phoneNumber;

  Contacts(
      {this.accountID,
      this.contactName,
      this.contactRelation,
      this.phoneNumber});

  factory Contacts.fromJson(Map<String, dynamic> json) {
    return Contacts(
        accountID: json["AccountID"] as int,
        contactName: json["ContactName"] as String,
        contactRelation: json["ContactRelation"] as String,
        phoneNumber: json["PhoneNumber"] as String);
  }

  Map<String, dynamic> toJson() => {
        "AccountID": accountID,
        "ContactName": contactName,
        "ContactRelation": contactRelation,
        "PhoneNumber": phoneNumber
      };
}
