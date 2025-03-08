class TopFarmerModel {
  String? userId;
  String? name;
  double? profitPerAcre;
  double? totalLandAreaAcres;  // Changed to double
  double? totalProfit;  // Changed to double
  double? totalExpense;  // Added totalExpense as double
  String? image;
  bool? isVerified;

  TopFarmerModel(
      {this.userId,
        this.name,
        this.profitPerAcre,
        this.totalLandAreaAcres,
        this.totalProfit,
        this.totalExpense,  // Added totalExpense
        this.image,
        this.isVerified});

  TopFarmerModel.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    name = json['name'];
    profitPerAcre = (json['profit_per_acre'] as num?)?.toDouble();
    totalLandAreaAcres = (json['total_land_area_acres'] as num?)?.toDouble();  // Handle conversion from int or double
    totalProfit = (json['total_profit'] as num?)?.toDouble();  // Handle conversion from int or double
    totalExpense = (json['total_expense'] as num?)?.toDouble();  // Convert total_expense to double
    image = json['image'];
    isVerified = json['isverified'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userId'] = userId;
    data['name'] = name;
    data['profit_per_acre'] = profitPerAcre;
    data['total_land_area_acres'] = totalLandAreaAcres;
    data['total_profit'] = totalProfit;
    data['total_expense'] = totalExpense;  // Added total_expense to the map
    data['image'] = image;
    data['isverified'] = isVerified;
    return data;
  }
}
