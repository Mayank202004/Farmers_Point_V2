class SeasonModel {
  String? seasonName;
  String? description;
  KeyCharacteristics? keyCharacteristics;
  List<String>? plantsThatCanGrowWell;
  List<String>? bestFor;
  String? wateringRequirements;
  List<String>? maintenanceTips;

  SeasonModel(
      {this.seasonName,
        this.description,
        this.keyCharacteristics,
        this.plantsThatCanGrowWell,
        this.bestFor,
        this.wateringRequirements,
        this.maintenanceTips});

  SeasonModel.fromJson(Map<String, dynamic> json) {
    seasonName = json['season_name'];
    description = json['description'];
    keyCharacteristics = json['key_characteristics'] != null
        ? KeyCharacteristics.fromJson(json['key_characteristics'])
        : null;
    plantsThatCanGrowWell = json['plants_that_can_grow_well'].cast<String>();
    bestFor = json['best_for'].cast<String>();
    wateringRequirements = json['watering_requirements'];
    maintenanceTips = json['maintenance_tips'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['season_name'] = seasonName;
    data['description'] = description;
    if (keyCharacteristics != null) {
      data['key_characteristics'] = keyCharacteristics!.toJson();
    }
    data['plants_that_can_grow_well'] = plantsThatCanGrowWell;
    data['best_for'] = bestFor;
    data['watering_requirements'] = wateringRequirements;
    data['maintenance_tips'] = maintenanceTips;
    return data;
  }
}

class KeyCharacteristics {
  String? temperatureRange;
  String? humidity;
  String? precipitation;
  String? daylightHours;

  KeyCharacteristics(
      {this.temperatureRange,
        this.humidity,
        this.precipitation,
        this.daylightHours});

  KeyCharacteristics.fromJson(Map<String, dynamic> json) {
    temperatureRange = json['temperature_range'];
    humidity = json['humidity'];
    precipitation = json['precipitation'];
    daylightHours = json['daylight_hours'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['temperature_range'] = temperatureRange;
    data['humidity'] = humidity;
    data['precipitation'] = precipitation;
    data['daylight_hours'] = daylightHours;
    return data;
  }
}
