class ExpenseSummaryModel {
  String? category;
  int? totalExpense;

  ExpenseSummaryModel({this.category, this.totalExpense});

  ExpenseSummaryModel.fromJson(Map<String, dynamic> json) {
    category = json['category'];
    totalExpense = json['total_expense'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['category'] = category;
    data['total_expense'] = totalExpense;
    return data;
  }
}
