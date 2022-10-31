import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:money_manager_1/db/category/category_db.dart';
import 'package:money_manager_1/db/transaction/transaction_db.dart';
import 'package:money_manager_1/models/category/category_model.dart';
import 'package:money_manager_1/models/transaction/transaction_model.dart';

class ScreenTransaction extends StatelessWidget {
  const ScreenTransaction({super.key});

  @override
  Widget build(BuildContext context) {
    TransactionDB.instance.refreshUI();
    CategoryDb.instance.refreshUI();
    return ValueListenableBuilder(
      valueListenable: TransactionDB.instance.transactionListNotifier,
      builder: (BuildContext context, List<TransactionModel> newList, _) {
        return ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            itemBuilder: (context, index) {
              final _transaction = newList[index];

              return Slidable(
                key: Key(_transaction.id!),
                startActionPane: ActionPane(
                  motion: const ScrollMotion(),
                  children: [
                    SlidableAction(
                      onPressed: (ctx) {
                        TransactionDB.instance
                            .deleteTransaction(_transaction.id!);
                      },
                      icon: Icons.delete,
                      foregroundColor: Colors.red,
                      label: 'Delete',
                    )
                  ],
                ),
                child: Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: _transaction.type == CategoryType.income
                          ? Colors.green
                          : Colors.red,
                      radius: 30,
                      child: Text(
                        parseDate(_transaction.date),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    title: Text('Rs. ${_transaction.amount}'),
                    subtitle: Text(_transaction.category.name),
                  ),
                ),
              );
            },
            separatorBuilder: (context, index) {
              return const SizedBox(
                height: 10,
              );
            },
            itemCount: newList.length);
      },
    );
  }

  String parseDate(DateTime date) {
    final _date = DateFormat.MMMd().format(date);
    final _splitDate = _date.split(' ');
    return '${_splitDate.last}\n${_splitDate.first}';

    // return '${date.day}\n ${date.month}';
  }
}
