import 'dart:convert';

import 'package:cropunity/views/utils/helper.dart';
import 'package:get/get.dart';
import '../models/transactionModel.dart';
import '../services/supabaseService.dart';

class TransactionController extends GetxController {
  final SupabaseService supabaseService = Get.find<SupabaseService>();
  RxBool loading = false.obs;
  String selectedCategory = "";
  String crop="";
  String sourceValue = "";
  double amount = 0.0;
  double yieldValue = 0.0; // Renamed to avoid conflict with the `yield` keyword
  String selectedUnit = "kg";
  DateTime? selectedDate;
  final List<String> expenseCategories = ["Electricity", "Pesticides", "Seeds", "Labor"];
  final List<String> units = ["kg", "ton"];
  bool isAddingTransaction = false;
  String currentType = "Expense";
  RxList<TransactionModel> transactions = RxList<TransactionModel>();

  RxDouble totalExpense = 0.0.obs;
  RxDouble totalProfit = 0.0.obs;
  // Calculate overall profit dynamically
  RxDouble get overallProfit => (totalProfit.value - totalExpense.value).obs;
  void updateProfitAndExpense() {
    totalExpense.value = transactions.where((t) => t.type == "Expense")
        .fold(0.0, (sum, t) => sum + (t.amount ?? 0.0));

    totalProfit.value = transactions.where((t) => t.type == "Profit")
        .fold(0.0, (sum, t) => sum + ((t.yield ?? 0.0) * (t.amountPerUnit ?? 0.0)));
    overallProfit.value=totalProfit.value-totalExpense.value;
  }


  Future<void> insertProfit() async {
    try{
      loading.value=true;
      await SupabaseService.SupabaseClientclient.from('transactions').insert({
        'cropType': crop,
        'type': 'Profit',
        'category': sourceValue,
        'yield': yieldValue,
        'amountPerUnit': amount,
        'unit': selectedUnit,
        'userId': supabaseService.currentUser.value?.id,
        'created_at': selectedDate?.toIso8601String() ?? DateTime.now().toIso8601String(),
      });
      loading.value=false;
      fetchTransactions();
    } catch (e) {
        rethrow;
    }
  }

  Future<void> insertExpense() async {
    try {
      loading.value=true;
      await SupabaseService.SupabaseClientclient.from('transactions').insert({
        'cropType': crop,
        'type': 'Expense',
        'category': selectedCategory,
        'amount': amount,
        'userId': supabaseService.currentUser.value?.id,
        'created_at': selectedDate?.toIso8601String() ?? DateTime.now().toIso8601String(),
      });
      loading.value=false;
      fetchTransactions();
    } catch (e) {
      loading.value=false;
        rethrow;
    }
  }

  // Fetch transactions
  Future<void> fetchTransactions() async {
    try {
      loading.value=true;
      var id =supabaseService.currentUser.value?.id;
      if (id == null) {
        showSnackBar("Error", "User not logged in");
        loading.value = false;
        return;
      }
      print("Crop:$crop");
      // Fetch transactions from the Supabase table
      final response = await SupabaseService.SupabaseClientclient
          .from('transactions')
          .select()
          .eq('userId',id)
          .eq('cropType',crop)
          .order('created_at', ascending: false) // Sort by date in descending order
          .order('id', ascending: false); // Sort by ID in descending order if date is equal
      transactions.value = [for(var item in response) TransactionModel.fromJson(item)];
      updateProfitAndExpense();
      print(response);
      loading.value=false;
    } catch (e) {
      loading.value=false;
      print("Error fetching transactions: $e");
      showSnackBar("Error", "Failed to load transactions");
    }
  }
  Future<void> deleteTransaction(int transactionId) async {
    try {
      loading.value = true;
      await SupabaseService.SupabaseClientclient
          .from('transactions')
          .delete()
          .eq('id', transactionId);
      loading.value = false;
      fetchTransactions();
      showSnackBar("Success", "Transaction deleted successfully.");
    } catch (e) {
      loading.value = false;
      showSnackBar("Error", "Failed to delete transaction");
    }
  }


  @override
  void onClose() {
    super.onClose();
  }
}
