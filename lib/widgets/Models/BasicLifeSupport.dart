class BasicLifeSupport {
  int? id;
  String? title;
  String? description;
  String? subDescription;
  String? image;

  BasicLifeSupport(
      {this.id, this.title, this.description, this.image, this.subDescription});

  factory BasicLifeSupport.fromJson(Map<String, dynamic> json) {
    return BasicLifeSupport(
      id: json["ID"] as int,
      title: json["Title"] as String,
      description: json["Description"] as String,
      subDescription: json["SubDescription"] as String,
      image: json["Image"] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        "ID": id,
        "Title": title,
        "Description": description,
        "SubDescription": subDescription,
        "Image": image
      };
}
