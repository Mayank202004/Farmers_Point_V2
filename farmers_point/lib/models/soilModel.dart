class SoilModel {
  String? soilName;
  String? description;
  KeyCharacteristics? keyCharacteristics;
  List<String>? plantsThatCanGrowWell;
  List<String>? bestFor;
  String? wateringRequirements;

  SoilModel(
      {this.soilName,
        this.description,
        this.keyCharacteristics,
        this.plantsThatCanGrowWell,
        this.bestFor,
        this.wateringRequirements});

  SoilModel.fromJson(Map<String, dynamic> json) {
    soilName = json['soil_name'];
    description = json['description'];
    keyCharacteristics = json['key_characteristics'] != null
        ? KeyCharacteristics.fromJson(json['key_characteristics'])
        : null;
    plantsThatCanGrowWell = json['plants_that_can_grow_well'].cast<String>();
    bestFor = json['best_for'].cast<String>();
    wateringRequirements = json['watering_requirements'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['soil_name'] = soilName;
    data['description'] = description;
    if (keyCharacteristics != null) {
      data['key_characteristics'] = keyCharacteristics!.toJson();
    }
    data['plants_that_can_grow_well'] = plantsThatCanGrowWell;
    data['best_for'] = bestFor;
    data['watering_requirements'] = wateringRequirements;
    return data;
  }
}

class KeyCharacteristics {
  String? texture;
  String? color;
  String? drainage;
  String? pHRange;
  String? organicMatter;

  KeyCharacteristics(
      {this.texture,
        this.color,
        this.drainage,
        this.pHRange,
        this.organicMatter});

  KeyCharacteristics.fromJson(Map<String, dynamic> json) {
    texture = json['texture'];
    color = json['color'];
    drainage = json['drainage'];
    pHRange = json['pH_range'];
    organicMatter = json['organic_matter'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['texture'] = texture;
    data['color'] = color;
    data['drainage'] = drainage;
    data['pH_range'] = pHRange;
    data['organic_matter'] = organicMatter;
    return data;
  }
}
