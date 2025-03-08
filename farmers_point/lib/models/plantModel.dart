class PlantModel {
  String? plantName;
  String? scientificName;
  String? description;
  List<String>? uses;
  Climate? climate;
  List<Disease>? diseases;
  List<String>? preventivePractices;

  PlantModel(
      {this.plantName,
        this.scientificName,
        this.description,
        this.uses,
        this.climate,
        this.diseases,
        this.preventivePractices});

  PlantModel.fromJson(Map<String, dynamic> json) {
    plantName = json['plant_name'];
    scientificName = json['scientific_name'];
    description = json['description'];
    uses = json['uses'].cast<String>();
    climate =
    json['climate'] != null ? Climate.fromJson(json['climate']) : null;
    if (json['diseases'] != null) {
      diseases = <Disease>[];
      json['diseases'].forEach((v) {
        diseases!.add(Disease.fromJson(v));
      });
    }
    preventivePractices = json['preventive_practices'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['plant_name'] = plantName;
    data['scientific_name'] = scientificName;
    data['description'] = description;
    data['uses'] = uses;
    if (climate != null) {
      data['climate'] = climate!.toJson();
    }
    if (diseases != null) {
      data['diseases'] = diseases!.map((v) => v.toJson()).toList();
    }
    data['preventive_practices'] = preventivePractices;
    return data;
  }
}

class Climate {
  Temperature? temperature;
  Humidity? humidity;
  Soil? soil;
  String? watering;

  Climate({this.temperature, this.humidity, this.soil, this.watering});

  Climate.fromJson(Map<String, dynamic> json) {
    temperature = json['temperature'] != null
        ? Temperature.fromJson(json['temperature'])
        : null;
    humidity = json['humidity'] != null
        ? Humidity.fromJson(json['humidity'])
        : null;
    soil = json['soil'] != null ? Soil.fromJson(json['soil']) : null;
    watering = json['watering'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (temperature != null) {
      data['temperature'] = temperature!.toJson();
    }
    if (humidity != null) {
      data['humidity'] = humidity!.toJson();
    }
    if (soil != null) {
      data['soil'] = soil!.toJson();
    }
    data['watering'] = watering;
    return data;
  }
}

class Temperature {
  String? optimalRange;
  String? tooLow;
  String? tooHigh;

  Temperature({this.optimalRange, this.tooLow, this.tooHigh});

  Temperature.fromJson(Map<String, dynamic> json) {
    optimalRange = json['optimal_range'];
    tooLow = json['too_low'];
    tooHigh = json['too_high'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['optimal_range'] = optimalRange;
    data['too_low'] = tooLow;
    data['too_high'] = tooHigh;
    return data;
  }
}

class Humidity {
  String? optimalRange;

  Humidity({this.optimalRange});

  Humidity.fromJson(Map<String, dynamic> json) {
    optimalRange = json['optimal_range'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['optimal_range'] = optimalRange;
    return data;
  }
}

class Soil {
  String? type;
  String? pHRange;

  Soil({this.type, this.pHRange});

  Soil.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    pHRange = json['pH_range'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    data['pH_range'] = pHRange;
    return data;
  }
}

class Disease {
  String? diseaseName;
  String? scientificName;
  List<String>? symptoms;
  Background? background;
  List<String>? cure;
  String? fertilizers;
  List<String>? prevention;

  Disease(
      {this.diseaseName,
        this.scientificName,
        this.symptoms,
        this.background,
        this.cure,
        this.fertilizers,
        this.prevention});

  Disease.fromJson(Map<String, dynamic> json) {
    diseaseName = json['disease_name'];
    scientificName = json['scientific_name'];
    symptoms = json['symptoms'].cast<String>();
    background = json['background'] != null
        ? Background.fromJson(json['background'])
        : null;
    cure = json['cure'].cast<String>();
    fertilizers = json['fertilizers'];
    prevention = json['prevention'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['disease_name'] = diseaseName;
    data['scientific_name'] = scientificName;
    data['symptoms'] = symptoms;
    if (background != null) {
      data['background'] = background!.toJson();
    }
    data['cure'] = cure;
    data['fertilizers'] = fertilizers;
    data['prevention'] = prevention;
    return data;
  }
}

class Background {
  String? cause;
  String? spreadBy;

  Background({this.cause, this.spreadBy});

  Background.fromJson(Map<String, dynamic> json) {
    cause = json['cause'];
    spreadBy = json['spread_by'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['cause'] = cause;
    data['spread_by'] = spreadBy;
    return data;
  }
}
