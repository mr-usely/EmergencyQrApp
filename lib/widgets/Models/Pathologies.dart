class Pathologies {
  int? accountID;
  int? medID;
  String? sickness;
  List<String>? medicines;

  Pathologies({this.accountID, this.medID, this.medicines, this.sickness});

  factory Pathologies.fromJson(Map<String, dynamic> json) {
    return Pathologies(
        accountID: json["AccountID"] as int,
        medID: json["ID"] as int,
        sickness: json["Sickness"] as String,
        medicines: json["Medicines"] as List<String>);
  }

  Map<String, dynamic> toJson() => {
        "AccountID": accountID,
        "ID": medID,
        "Sickness": sickness,
        "Medicines": medicines
      };
}
