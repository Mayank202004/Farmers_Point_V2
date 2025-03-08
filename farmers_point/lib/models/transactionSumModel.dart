class TransactionSumModel {
  String? croptype;
  double? totalProfit;
  double? yieldValue;
  double? totalExpense;

  TransactionSumModel(
      {this.croptype, this.totalProfit, this.yieldValue, this.totalExpense});

  TransactionSumModel.fromJson(Map<String, dynamic> json) {
    croptype = json['croptype'];
    totalProfit = (json['total_profit'] is int)
        ? (json['total_profit'] as int).toDouble()
        : json['total_profit']?.toDouble();
    yieldValue = (json['yield_value'] is int)
        ? (json['yield_value'] as int).toDouble()
        : json['yield_value']?.toDouble();
    totalExpense = (json['total_expense'] is int)
        ? (json['total_expense'] as int).toDouble()
        : json['total_expense']?.toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['croptype'] = croptype;
    data['total_profit'] = totalProfit;
    data['yield_value'] = yieldValue;
    data['total_expense'] = totalExpense;
    return data;
  }
}
