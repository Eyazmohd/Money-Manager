import 'package:flutter/material.dart';

import 'package:money_manager_1/screens/add_transaction/transaction_add_screen.dart';
import 'package:money_manager_1/screens/category/add_category_popup.dart';
import 'package:money_manager_1/screens/category/screen_category.dart';
import 'package:money_manager_1/screens/home/widgets/bottom_navigation.dart';
import 'package:money_manager_1/screens/transaction/screen_transaction.dart';

class ScreenHome extends StatelessWidget {
  const ScreenHome({super.key});

  static ValueNotifier<int> selectedIndexNotifier = ValueNotifier(0);
  final _pages = const [ScreenTransaction(), ScreenCategory()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('MONEY MANAGER'),
        centerTitle: true,
      ),
      bottomNavigationBar: const MoneyManagerBottomNavigation(),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (selectedIndexNotifier.value == 0) {
              Navigator.of(context).pushNamed(ScreenAddTransaction.routName);
            } else {
              showCategoryAddPopup(context);
            }
          },
          child: const Icon(
            Icons.add,
          )),
      body: SafeArea(
        child: ValueListenableBuilder(
          valueListenable: selectedIndexNotifier,
          builder: (BuildContext context, int updatedIndex, _) {
            return _pages[updatedIndex];
          },
        ),
      ),
    );
  }
}
