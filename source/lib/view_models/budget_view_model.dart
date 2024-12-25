import 'package:flutter/foundation.dart';
import 'package:first/models/budget_model.dart';

class BudgetViewModel with ChangeNotifier {
  late final BudgetModel _budgetModel;

  BudgetViewModel(this._budgetModel);

  double get totalAmount => _budgetModel.totalAmount;
  double get dailyLimit => _budgetModel.dailyLimit;
  int get currentDay => _budgetModel.currentDay;
  int get totalDays => _budgetModel.totalDays;
  double get expenses => _budgetModel.expenses;
  double get remainingDailyBudget => _budgetModel.remainingDailyBudget;
  double get totalRemainingBudget => _budgetModel.totalRemainingBudget;
  bool get isOverBudget => _budgetModel.isOverBudget;

  void addExpense(double expense) {
    _budgetModel.addExpense(expense);
    notifyListeners();
  }

  void nextDay() {
    _budgetModel.nextDay();
    notifyListeners();
  }

  void updateTotalAmount(double newTotalAmount) {
    _budgetModel.resetBudget(); // Сбрасываем предыдущие значения
    _budgetModel.totalAmount = newTotalAmount;
    notifyListeners();
  }

  void updateTotalDays(int newTotalDays) {
    _budgetModel.resetBudget();
    _budgetModel.totalDays = newTotalDays;
    notifyListeners();
  }

  // void updateTotalDays(int newDays) {
  //   _budgetModel.updateTotalDays(newDays);
  //   notifyListeners();
  // }

  Future<void> clearStorage() async {
    await _budgetModel.clearStorage();
    notifyListeners();
  }

  Future<void> saveModel() async {
    await _budgetModel.saveModel();
  }

  Future<void> loadModel() async {
    _budgetModel = await BudgetModel.loadModel();
    notifyListeners();
  }
}
