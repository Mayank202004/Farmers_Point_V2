class HealthyPlantModel {
  String? name;
  String? appearanceWhenHealthy;
  String? maintenanceInstructions;
  String? optimalConditions;
  String? growthStages;
  String? keyBenefits;

  HealthyPlantModel(
      {this.name,
        this.appearanceWhenHealthy,
        this.maintenanceInstructions,
        this.optimalConditions,
        this.growthStages,
        this.keyBenefits});

  HealthyPlantModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    appearanceWhenHealthy = json['appearance_when_healthy'];
    maintenanceInstructions = json['maintenance_instructions'];
    optimalConditions = json['optimal_conditions'];
    growthStages = json['growth_stages'];
    keyBenefits = json['key_benefits'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['appearance_when_healthy'] = appearanceWhenHealthy;
    data['maintenance_instructions'] = maintenanceInstructions;
    data['optimal_conditions'] = optimalConditions;
    data['growth_stages'] = growthStages;
    data['key_benefits'] = keyBenefits;
    return data;
  }
}