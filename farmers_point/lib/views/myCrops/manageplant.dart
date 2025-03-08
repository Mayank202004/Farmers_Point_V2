import 'package:cropunity/controller/transaction.dart';
import 'package:cropunity/views/utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../models/transactionModel.dart';

class ManagePlant extends StatefulWidget {
  const ManagePlant({super.key});

  @override
  State<ManagePlant> createState() => _ManagePlantState();
}

class _ManagePlantState extends State<ManagePlant> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final GlobalKey<FormState> _expenseFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _profitFormKey = GlobalKey<FormState>();
  String crop = Get.arguments;
  TransactionController controller = Get.put(TransactionController());

  @override
  void initState() {
    controller.crop=crop;
    controller.fetchTransactions();
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  void addTransaction(String type, String category, double amount,
      DateTime? selectedDate) async {
    try {

      if (type == "Profit") {
        await controller.insertProfit();
      } else {
        await controller.insertExpense();
      }
      setState(() {
        controller.isAddingTransaction = false;
      });
      resetForm();
      showSnackBar("Success", "$type added successfully");
    } catch (e) {
      setState(() {
        controller.isAddingTransaction = false;
      });
      showSnackBar("Error", "Something went wrong");
      print(e);
    }
  }

  void resetForm() {
    controller.selectedCategory = "";
    controller.amount = 0.0;
    controller.selectedDate = null;
  }

  @override
  Widget build(BuildContext context) {
    return Obx((){
      if (controller.loading.value) {return loaderPage();} else {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Manage Transactions"),
          ),
          body: Column(
            children: [
              _overallProfitSection(),
              _addTransactionButton(),
              Expanded(
                child: controller.isAddingTransaction
                    ? _transactionForm()
                    : _transactionHistory(),
              ),
            ],
          ),
        );
      }
    }
    );
  }

  Widget _overallProfitSection() {
    return Container(
      margin: const EdgeInsets.all(16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: controller.totalProfit>0 ? Color(0x5180DD86) : Color(0x47EF9A9A),
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Overall $crop Profit",style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          // Use Obx to reactively update the Overall Profit
          Obx(() {
            return Text(
              "₹${controller.overallProfit.value.toStringAsFixed(2)}",
              style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            );
          }),
          const Divider(
            color: Color(0xff242424),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Use Obx to reactively update Total Expense
              Column(
                children: [
                  const Text("Profit"),
                  Obx(() {
                    return Text(
                      "₹${controller.totalProfit.value.toStringAsFixed(2)}",
                      style: const TextStyle(fontSize: 16, color: Colors.green,fontWeight: FontWeight.bold),
                    );
                  }),
                ],
              ),
              Column(
                children: [
                  const Text("Expense"),
                  Obx(() {
                    return Text(
                      "₹${controller.totalExpense.value.toStringAsFixed(2)}",
                      style: const TextStyle(fontSize: 16, color: Colors.red,fontWeight: FontWeight.bold),
                    );
                  }),
                ],
              ),
              // Use Obx to reactively update Total Profit
            ],
          ),
        ],
      ),
    );
  }

  Widget _addTransactionButton() {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          controller.isAddingTransaction = !controller.isAddingTransaction;
        });
      },
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Text(
          controller.isAddingTransaction ? "Cancel" : "Add Transaction"),
    );
  }

  Widget _transactionForm() {
    return Column(
      children: [
        TabBar(
          controller: _tabController,
          labelColor: Colors.black,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Colors.black,
          tabs: const [
            Tab(text: "Add Expense"),
            Tab(text: "Add Profit"),
          ],
          onTap: (index) {
            setState(() {
              controller.currentType = index == 0 ? "Expense" : "Profit";
              resetForm();
            });
          },
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _expenseForm(),
              _profitForm(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _expenseForm() {
    return _transactionInputForm(
      formKey: _expenseFormKey,
      categories: controller.expenseCategories,
      type: "Expense",
    );
  }

  Widget _profitForm() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _profitFormKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: "Source"),
                keyboardType: TextInputType.text,
                onChanged: (value) {
                  controller.sourceValue = value;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter a source";
                  }
                  return null;
                },
              ),
              SizedBox(height: 16,),
              Row(
                children: [
                  Expanded(
                    flex: 5,
                    child: TextFormField(
                      decoration: const InputDecoration(labelText: "Yield"),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        controller.yieldValue = double.tryParse(value) ?? 0.0;
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter yield";
                        }
                        if (double.tryParse(value) == null || double.tryParse(
                            value)! <= 0) {
                          return "Enter a valid positive yield";
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 4,
                    child: DropdownButtonFormField<String>(
                      value: controller.selectedUnit,
                      items: controller.units
                          .map((unit) =>
                          DropdownMenuItem(value: unit, child: Text(unit)))
                          .toList(),
                      onChanged: (value) =>
                          setState(() {
                            controller.selectedUnit = value!;
                          }),
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(), labelText: "Unit"),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Amount per ${controller.selectedUnit}",
                  border: const OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  controller.amount = double.tryParse(value) ?? 0.0;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Enter amount per ${controller.selectedUnit}";
                  }
                  if (double.tryParse(value) == null ||
                      double.tryParse(value)! <= 0) {
                    return "Enter a valid positive amount";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () async {
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (picked != null) {
                    setState(() {
                      controller.selectedDate = picked;
                    });
                  }
                },
                child: AbsorbPointer(
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: controller.selectedDate == null
                          ? "Select Date"
                          : "Date: ${formatNonStringDate(
                          controller.selectedDate!)}",
                      suffixIcon: const Icon(Icons.calendar_today),
                      border: const OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (controller.selectedDate == null) {
                        return "Please select a date";
                      }
                      return null;
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _submitButton("Profit"),
            ],
          ),
        ),
      ),
    );
  }


  Widget _transactionInputForm({
    required GlobalKey<FormState> formKey,
    required List<String> categories,
    required String type,
  }) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              DropdownButtonFormField<String>(
                value: controller.selectedCategory.isNotEmpty ? controller
                    .selectedCategory : null,
                decoration: const InputDecoration(
                  labelText: "Select Category",
                  border: OutlineInputBorder(),
                ),
                items: categories
                    .map((category) =>
                    DropdownMenuItem(value: category, child: Text(category)))
                    .toList(),
                onChanged: (value) =>
                    setState(() {
                      controller.selectedCategory = value!;
                    }),
                validator: (value) =>
                value == null || value.isEmpty
                    ? "Please select a category"
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: "Amount",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  controller.amount = double.tryParse(value) ?? 0.0;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Enter an amount";
                  }
                  if (double.tryParse(value) == null ||
                      double.tryParse(value)! <= 0) {
                    return "Enter a valid positive amount";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () async {
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (picked != null) {
                    setState(() {
                      controller.selectedDate = picked;
                    });
                  }
                },
                child: AbsorbPointer(
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: controller.selectedDate == null
                          ? "Select Date"
                          : "Date: ${formatNonStringDate(
                          controller.selectedDate!)}",
                      suffixIcon: const Icon(Icons.calendar_today),
                      border: const OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (controller.selectedDate == null) {
                        return "Please select a date";
                      }
                      return null;
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _submitButton(type),
            ],
          ),
        ),
      ),
    );
  }

  Widget _submitButton(String type) {
    return ElevatedButton(
      onPressed: () {
        final formKey = type == "Expense" ? _expenseFormKey : _profitFormKey;
        if (formKey.currentState!.validate()) {
          addTransaction(type, controller.selectedCategory, controller.amount,
              controller.selectedDate);
        }
      },
      child: Text("Add $type"),
    );
  }

  Widget _transactionHistory() {
    return Obx(() {
      return ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: controller.transactions.length,
        itemBuilder: (context, index) {
          final transaction = controller.transactions[index];
          final String formattedDate = DateFormat('dd MMM yyyy').format(
              DateTime.parse(transaction.createdAt!));

          return GestureDetector(
            onLongPress: () => showDeleteConfirmationDialog(context, index, controller),
            child: Column(
              children: [
                ListTile(
                  title: Text("${transaction.type} - ${transaction.category}",style: TextStyle(fontWeight: FontWeight.bold,),),
                  subtitle: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Amount: ₹${transaction.type == 'Expense' ? (transaction.amount ?? 0.0) : (transaction.amountPerUnit ?? 0.0) * (transaction.yield ?? 0.0)}",
                      ),
                      Text(formattedDate),
                    ],
                  ),
                  leading: Icon(
                    transaction.type == "Expense"
                        ? Icons.remove_circle_outline
                        : Icons.add_circle_outline,
                    color: transaction.type == "Expense" ? Colors.red : Colors.green,
                  ),
                ),
                Divider()
              ],
            ),
          );
        },
      );
    });
  }

  Widget loaderPage(){
    return Scaffold(appBar: AppBar(
      title: const Text("Manage Transactions"),
    ),body: Padding(
      padding: const EdgeInsets.all(10.0),
      child: SizedBox(width:context.width,child: const Column(crossAxisAlignment: CrossAxisAlignment.center,children: [CircularProgressIndicator()],)),
    ),);
  }
}

// Delete dialog box
void showDeleteConfirmationDialog(BuildContext context, int index, TransactionController controller) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Delete Transaction"),
        content: const Text("Are you sure you want to delete this transaction?"),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              try {
                // Call the controller's delete method for the specific transaction
                final transactionId = controller.transactions[index].id;
                Navigator.pop(context);
                await controller.deleteTransaction(transactionId!);
              } catch (e) {
                showSnackBar("Error", "Failed to delete transaction: $e");
              }
            },
            child: const Text("Delete"),
          ),
        ],
      );
    },
  );
}

