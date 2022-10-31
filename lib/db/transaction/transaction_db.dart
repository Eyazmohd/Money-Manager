import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:money_manager_1/models/transaction/transaction_model.dart';

const TRASACTION_DB_NAME = 'transaction_db';

abstract class TransactionDBFunction {
  Future<void> addTransaction(TransactionModel obj);
  Future<List<TransactionModel>> getTransactions();
  Future<void> deleteTransaction(String transactionID);
}

class TransactionDB implements TransactionDBFunction {
  ValueNotifier<List<TransactionModel>> transactionListNotifier =
      ValueNotifier([]);

  TransactionDB._internal();

  static TransactionDB instance = TransactionDB._internal();

  factory TransactionDB() {
    return instance;
  }
  @override
  Future<void> addTransaction(TransactionModel obj) async {
    final _db = await Hive.openBox<TransactionModel>(TRASACTION_DB_NAME);
    await _db.put(obj.id, obj);
    refreshUI();
  }

  @override
  Future<List<TransactionModel>> getTransactions() async {
    final _db = await Hive.openBox<TransactionModel>(TRASACTION_DB_NAME);
    return _db.values.toList();
  }

  Future<void> refreshUI() async {
    final _allTransaction = await getTransactions();
    _allTransaction.sort((first, second) => second.date.compareTo(first.date));
    transactionListNotifier.value.clear();
    transactionListNotifier.value.addAll(_allTransaction);

    transactionListNotifier.notifyListeners();
  }

  @override
  Future<void> deleteTransaction(String transactionID) async {
    final _db = await Hive.openBox<TransactionModel>(TRASACTION_DB_NAME);
    await _db.delete(transactionID);
    refreshUI();
  }
}
