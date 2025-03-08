class InfoModel {
  int? id;
  String? createdAt;
  String? farmAddress;
  int? farmArea;
  String? unit;
  String? contact;
  int? age;
  String? qualification;
  String? agriculturalDegree;
  String? description;
  String? userId;

  InfoModel(
      {this.id,
        this.createdAt,
        this.farmAddress,
        this.farmArea,
        this.unit,
        this.contact,
        this.age,
        this.qualification,
        this.agriculturalDegree,
        this.description,
        this.userId});

  InfoModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['created_at'];
    farmAddress = json['farmAddress'];
    farmArea = json['farmArea'];
    unit = json['unit'];
    contact = json['contact'];
    age = json['age'];
    qualification = json['qualification'];
    agriculturalDegree = json['agriculturalDegree'];
    description = json['description'];
    userId = json['userId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['created_at'] = createdAt;
    data['farmAddress'] = farmAddress;
    data['farmArea'] = farmArea;
    data['unit'] = unit;
    data['contact'] = contact;
    data['age'] = age;
    data['qualification'] = qualification;
    data['agriculturalDegree'] = agriculturalDegree;
    data['description'] = description;
    data['userId'] = userId;
    return data;
  }
}
