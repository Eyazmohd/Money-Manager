import 'package:flutter/cupertino.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:money_manager_1/models/category/category_model.dart';

const CATEGORY_DB_NAME = 'category_database';

abstract class CategoryDbFunctions {
  Future<List<CategoryModel>> getCategories();
  Future<void> insertCategory(CategoryModel value);
  Future<void> deleteCategory(String categoryId);
}

class CategoryDb implements CategoryDbFunctions {
  ValueNotifier<List<CategoryModel>> incomeCategoryListNotifier =
      ValueNotifier([]);
  ValueNotifier<List<CategoryModel>> expenseCategoryListNotifier =
      ValueNotifier([]);

  CategoryDb._internal();
  static CategoryDb instance = CategoryDb._internal();

  factory CategoryDb() {
    return instance;
  }

  @override
  Future<void> insertCategory(CategoryModel value) async {
    final _category_db = await Hive.openBox<CategoryModel>(CATEGORY_DB_NAME);
    await _category_db.put(value.id, value);
    refreshUI();
  }

  @override
  Future<List<CategoryModel>> getCategories() async {
    final _category_db = await Hive.openBox<CategoryModel>(CATEGORY_DB_NAME);
    return _category_db.values.toList();
  }

  Future<void> refreshUI() async {
    final _allCategories = await getCategories();
    incomeCategoryListNotifier.value.clear();
    expenseCategoryListNotifier.value.clear();
    incomeCategoryListNotifier.notifyListeners();
    expenseCategoryListNotifier.notifyListeners();
    Future.forEach(_allCategories, (CategoryModel category) {
      if (category.type == CategoryType.income) {
        incomeCategoryListNotifier.value.add(category);
      } else {
        expenseCategoryListNotifier.value.add(category);
      }

      incomeCategoryListNotifier.notifyListeners();
      expenseCategoryListNotifier.notifyListeners();
    });
  }

  @override
  Future<void> deleteCategory(String categoryId) async {
    final _category_db = await Hive.openBox<CategoryModel>(CATEGORY_DB_NAME);
    await _category_db.delete(categoryId);
    refreshUI();
  }
}
