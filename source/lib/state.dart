import 'package:flutter/foundation.dart';
import 'storage.dart';

class BudgetModel with ChangeNotifier {
  double _totalBudget;
  double _dailyBudget;
  double _expenses = 0.0;
  int _currentDay = 1;
  int _totalDays;

  BudgetModel(this._totalBudget, this._totalDays) : _dailyBudget = 0.0 {
    _recalculateDailyBudget();
  }

  double get totalBudget => _totalBudget;
  double get dailyBudget => _dailyBudget;
  double get remainingDailyBudget => _dailyBudget - _expenses;
  int get currentDay => _currentDay;
  int get totalDays => _totalDays;
  int get remainingDays => _totalDays - _currentDay + 1;
  double get totalRemainingBudget =>
      _totalBudget - (_dailyBudget * (_currentDay - 1)) - _expenses;

  bool get isOverBudget => _expenses > _dailyBudget;

  void addExpense(double expense) {
    _expenses += expense;
    notifyListeners();
    StorageHelper.saveData('spentToday', _expenses.toString());
  }

  void nextDay() {
    if (_currentDay < _totalDays) {
      _totalBudget -= _expenses;
      _currentDay++;
      _expenses = 0;
      _recalculateDailyBudget();
      notifyListeners();
      StorageHelper.saveData('currentDay', _currentDay.toString());
    }
  }

  void _recalculateDailyBudget() {
    _dailyBudget = _totalBudget / remainingDays;
  }

  static Future<BudgetModel> loadModel() async {
    final _totalBudget =
        double.parse(await StorageHelper.loadData('totalBudget') ?? '0');
    final _totalDays =
        int.parse(await StorageHelper.loadData('totalDays') ?? '0');
    final currentDay =
        int.parse(await StorageHelper.loadData('currentDay') ?? '1');
    final spentToday =
        double.parse(await StorageHelper.loadData('spentToday') ?? '0.0');

    final model = BudgetModel(_totalBudget, _totalDays);
    model._currentDay = currentDay;
    model._expenses = spentToday;
    return model;
  }
}
