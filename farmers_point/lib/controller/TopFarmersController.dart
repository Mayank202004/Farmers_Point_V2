import 'dart:convert';

import 'package:cropunity/models/expenseSummaryModel.dart';
import 'package:cropunity/models/infoModel.dart';
import 'package:cropunity/models/topFarmerModel.dart';
import 'package:cropunity/models/transactionSumModel.dart';
import 'package:cropunity/services/supabaseService.dart';
import 'package:cropunity/views/utils/helper.dart';
import 'package:get/get.dart';

class TopFarmerController extends GetxController{
  final SupabaseService supabaseService = Get.find<SupabaseService>();
  var loading = false.obs;
  Rx<InfoModel> farmerInfo=Rx<InfoModel>(InfoModel());
  RxList<TopFarmerModel> fetchedFarmers = RxList<TopFarmerModel>();
  RxList<TransactionSumModel> fetchedSum = RxList<TransactionSumModel>();
  RxList<ExpenseSummaryModel> expenseSummary = RxList<ExpenseSummaryModel>();
  int FarmerIndex=0;

  @override
  void onInit(){
    fetchFarmersProfit();
    super.onInit();


  }

  Future<void> fetchFarmersProfit() async {
    try{
      loading.value=true;
      var id=supabaseService.currentUser.value?.id;
      final response = await SupabaseService.SupabaseClientclient.rpc('get_farmers_profit_per_acre');
      if(response.isNotEmpty){
        fetchedFarmers.value=[for (var item in response) TopFarmerModel.fromJson(item)];
      }
      loading.value=false;
    } catch(error){
      loading.value=false;
      showSnackBar("Error", "Something went wrong");
    }
  }


  Future<void> fetchProfitPerCrop() async {
    loading.value = true;
    try {
      var id=fetchedFarmers[FarmerIndex].userId;
      final response = await SupabaseService.SupabaseClientclient.rpc(
          'calculate_total_profit_and_yield',params: {'user_uuid': id});
      if(response!=null) {
        fetchedSum.value=[for (var item in response) TransactionSumModel.fromJson(item)];
      }
      loading.value = false;
    }catch(e){
      loading.value = false;
      showSnackBar("Error", "Something went wrong");
    }
  }

  Future<void> fetchExpenseSummary() async {
    loading.value = true;
    try {
      var id=fetchedFarmers[FarmerIndex].userId;
      final response = await SupabaseService.SupabaseClientclient.rpc(
          'get_expense_summary',params: {'user_uuid': id});
      if(response!=null) {
        expenseSummary.value=[for (var item in response) ExpenseSummaryModel.fromJson(item)];
      }
      loading.value = false;
    }catch(e){
      loading.value = false;
      showSnackBar("Error", "Something went wrong");
    }
  }

  Future<void> fetchFarmerInfo() async {
    loading.value = true;
    var id = fetchedFarmers[FarmerIndex].userId;
    if (id != null) {
      try {
        final response = await SupabaseService.SupabaseClientclient
            .from('farmer_info')
            .select()
            .eq('userId', id).single();
        if(response.isNotEmpty){
          farmerInfo.value=InfoModel();
          farmerInfo.value=InfoModel.fromJson(response);
        }
        loading.value = false;
      } catch (error) {
        loading.value = false;
        showSnackBar("Error", "Error fetching user crop data");
      }
    }
  }

}