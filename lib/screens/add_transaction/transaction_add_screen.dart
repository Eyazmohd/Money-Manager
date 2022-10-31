import 'package:flutter/material.dart';
import 'package:money_manager_1/db/category/category_db.dart';
import 'package:money_manager_1/db/transaction/transaction_db.dart';

import 'package:money_manager_1/models/category/category_model.dart';
import 'package:money_manager_1/models/transaction/transaction_model.dart';

// Future<void> pushToTransactionAddScreen(BuildContext context) async {
//   Navigator.of(context).push(
//     MaterialPageRoute(
//       builder: (context) {
//         return AddTransaction();
//       },
//     ),
//   );
// }

class ScreenAddTransaction extends StatefulWidget {
  const ScreenAddTransaction({super.key});

  static const routName = 'add-transaction';

  @override
  State<ScreenAddTransaction> createState() => _ScreenAddTransactionState();
}

class _ScreenAddTransactionState extends State<ScreenAddTransaction> {
  DateTime? _selectedDate;
  CategoryType? _selectedCategoryType;
  CategoryModel? _selectedCategoryModel;

  String? _categoryID;
  final _purposeTextEditingController = TextEditingController();
  final _amountTextEditingController = TextEditingController();

  @override
  void initState() {
    _selectedCategoryType = CategoryType.income;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _purposeTextEditingController,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  hintText: 'Purpose',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: _amountTextEditingController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: 'Amount',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextButton.icon(
                onPressed: () async {
                  final _selectedDateTemp = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate:
                        DateTime.now().subtract(const Duration(days: 30)),
                    lastDate: DateTime.now(),
                  );
                  if (_selectedDateTemp == null) {
                    return;
                  } else {
                    setState(() {
                      _selectedDate = _selectedDateTemp;
                    });
                  }
                },
                icon: const Icon(Icons.calendar_month),
                label: Text(_selectedDate == null
                    ? 'Select Date'
                    : _selectedDate.toString()),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Radio(
                          value: CategoryType.income,
                          groupValue: _selectedCategoryType,
                          onChanged: (newValue) {
                            setState(() {
                              _selectedCategoryType = newValue;
                              _categoryID = null;
                            });
                          }),
                      const Text('Income'),
                    ],
                  ),
                  Row(
                    children: [
                      Radio(
                          value: CategoryType.expense,
                          groupValue: _selectedCategoryType,
                          onChanged: (newValue) {
                            setState(() {
                              _selectedCategoryType = newValue;
                              _categoryID = null;
                            });
                          }),
                      const Text('Expense'),
                    ],
                  ),
                ],
              ),

              //Category
              DropdownButton<String>(
                hint: const Text('Select Category'),
                value: _categoryID,
                items: (_selectedCategoryType == CategoryType.expense
                        ? CategoryDb().expenseCategoryListNotifier
                        : CategoryDb().incomeCategoryListNotifier)
                    .value
                    .map((e) {
                  return DropdownMenuItem(
                    onTap: () {
                      _selectedCategoryModel = e;
                    },
                    value: e.name,
                    child: Text(e.name),
                  );
                }).toList(),
                onChanged: (selectedItem) {
                  setState(() {
                    _categoryID = selectedItem;
                  });
                },
              ),

              ElevatedButton(
                onPressed: () {
                  addTransaction();
                },
                child: const Text('Add'),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> addTransaction() async {
    final _purposeText = _purposeTextEditingController.text;
    final _amountText = _amountTextEditingController.text;

    if (_purposeText.isEmpty) {
      return;
    }

    if (_amountText.isEmpty) {
      return;
    }
    if (_categoryID == null) {
      return;
    }
    if (_selectedDate == null) {
      return;
    }
    final _parsedAmount = double.tryParse(_amountText);
    if (_parsedAmount == null) {
      return;
    }
    if (_selectedCategoryModel == null) {
      return;
    }
    // _selectedDate
    // _selectedCategoryType
    final _model = TransactionModel(
      purpose: _purposeText,
      amount: _parsedAmount,
      date: _selectedDate!,
      type: _selectedCategoryType!,
      category: _selectedCategoryModel!,
    );
    await TransactionDB.instance.addTransaction(_model);
    Navigator.of(context).pop();
  }
}
