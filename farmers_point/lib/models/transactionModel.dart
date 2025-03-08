class TransactionModel {
  int? id;
  String? userId;
  String? category;
  double? amount;
  double? yield;
  double? amountPerUnit;
  String? unit;
  String? createdAt;
  String? type;
  // Constructor
  TransactionModel({
    this.id,
    this.userId,
    this.category,
    this.amount,
    this.yield,
    this.amountPerUnit,
    this.unit,
    this.createdAt,
    this.type,
  });

  // From JSON constructor
  TransactionModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    category = json['category'];

    // Safely parse 'amount', 'yield', and 'amountPerUnit' as doubles, even if they are integers
    amount = _parseDouble(json['amount']);
    yield = _parseDouble(json['yield']);
    amountPerUnit = _parseDouble(json['amountPerUnit']);

    unit = json['unit'];
    createdAt = json['created_at'];
    type = json['type'];
  }

  // To JSON method
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['userId'] = userId;
    data['category'] = category;
    data['amount'] = amount;
    data['yield'] = yield;
    data['amountPerUnit'] = amountPerUnit;
    data['unit'] = unit;
    data['created_at'] = createdAt;
    data['type'] = type;
    return data;
  }
  // Helper function to safely parse double values
  static double? _parseDouble(dynamic value) {
    if (value == null) {
      return null;
    }
    if (value is double) {
      return value;
    }
    if (value is int) {
      return value.toDouble();
    }
    return null; // Handle any other type or throw error as needed
  }
}
