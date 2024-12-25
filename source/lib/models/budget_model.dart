import 'package:flutter/foundation.dart';
import 'package:first/models/storage_helper.dart';
import 'package:first/models/budget.dart';

class BudgetModel extends Budget with ChangeNotifier {
  double _expenses = 0.0;

  BudgetModel(double totalAmount, int totalDays) : super(totalAmount: totalAmount, dailyLimit: 0.0, totalDays: totalDays) {
    _recalculateDailyBudget();
  }

  double get expenses => _expenses;
  double get remainingDailyBudget => dailyLimit - _expenses;
  double get totalRemainingBudget => totalAmount - _expenses;

  bool get isOverBudget => _expenses > dailyLimit;

  void addExpense(double expense) {
    _expenses += expense;
    notifyListeners();
    saveModel();
  }

  void nextDay() {
    if (currentDay < totalDays) {
      totalAmount = totalAmount - _expenses;
      currentDay++;
      _expenses = 0;
      _recalculateDailyBudget();
      notifyListeners();
      saveModel();
    }
  }

  void _recalculateDailyBudget() {
    double remainingBudget = totalAmount / totalDays - currentDay - 1;
    int denominator = totalDays - (currentDay - 1);

    if (denominator != 0) { // Добавили проверку на 0
      dailyLimit = remainingBudget / denominator;
    } else {
      dailyLimit = 0; // Или другое подходящее значение
    }

    saveModel();
  }

  void updateTotalDays(int newDays) {
    totalDays = newDays;
    StorageHelper.saveData('totalDays', newDays.toString());
    notifyListeners();
  }

  Future<void> clearStorage() async { // Changed to instance method
    await StorageHelper.clearData();
    notifyListeners();
  }

  Future<void> saveModel() async {
    await StorageHelper.saveData('totalAmount', totalAmount.toString());
    await StorageHelper.saveData('totalDays', totalDays.toString());
    await StorageHelper.saveData('currentDay', currentDay.toString());
  }

  static Future<BudgetModel> loadModel() async {
    final _totalAmount =
    double.parse(await StorageHelper.loadData('totalAmount') ?? '0');
    final _totalDays =
    int.parse(await StorageHelper.loadData('totalDays') ?? '0');
    final _currentDay = int.parse(await StorageHelper.loadData('currentDay') ?? '1');
    final model = BudgetModel(_totalAmount, _totalDays);
    model.currentDay = _currentDay;
    model._recalculateDailyBudget();
    return model;
  }

  void resetBudget() {
    currentDay = 0;
    _expenses = 0;
  }

  void updateModel(BudgetModel newModel) {
    totalAmount = newModel.totalAmount; // Используем сеттер
    dailyLimit = newModel.dailyLimit; // Используем сеттер
    currentDay = newModel.currentDay;
    totalDays = newModel.totalDays; // Используем сеттер
    // expenses = newModel.expenses;
    notifyListeners();
  }


}