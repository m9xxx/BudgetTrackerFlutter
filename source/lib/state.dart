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

  double get expenses => _expenses;
  double get totalBudget => _totalBudget;
  double get dailyBudget => _dailyBudget;
  double get remainingDailyBudget => _dailyBudget - _expenses;
  int get currentDay => _currentDay;
  int get totalDays => _totalDays;
  double get totalRemainingBudget => _totalBudget - _expenses;

  bool get isOverBudget => _expenses > _dailyBudget;

  Future<void> saveModel() async {
    await StorageHelper.saveData('totalBudget', totalBudget.toString());
    await StorageHelper.saveData('totalDays', totalDays.toString());
    await StorageHelper.saveData('currentDay', currentDay.toString());
  }

  void addExpense(double expense) {
    _expenses += expense;
    notifyListeners();
    saveModel();
  }

  void nextDay() {
    if (_currentDay < _totalDays) {
      _totalBudget -= _expenses;
      _currentDay++;
      _expenses = 0;
      _recalculateDailyBudget();
      notifyListeners();
      saveModel();
    }
  }

  void _recalculateDailyBudget() {
    double remainingBudget = _totalBudget - (_expenses * (_currentDay - 1));
    _dailyBudget = remainingBudget / (_totalDays - (_currentDay - 1));
    saveModel();
  }

  set totalDays(int newDays) {
    _totalDays = newDays;
    notifyListeners();
  }

  void updateTotalDays(int newDays) {
    totalDays = newDays;
    StorageHelper.saveData('totalDays', newDays.toString()); // Добавлено сохранение
    notifyListeners();
  }

  static Future<BudgetModel> loadModel() async {
    final _totalBudget =
        double.parse(await StorageHelper.loadData('totalBudget') ?? '0');
    final _totalDays =
        int.parse(await StorageHelper.loadData('totalDays') ?? '0');
    final _currentDay = int.parse(await StorageHelper.loadData('currentDay') ?? '1');
    final model = BudgetModel(_totalBudget, _totalDays);
    model._currentDay = _currentDay;
    model._recalculateDailyBudget();
    return model;
  }

  void updateModel(BudgetModel newModel) {
    _totalBudget = newModel.totalBudget;
    _totalDays = newModel.totalDays;
    _currentDay = newModel.currentDay;
    _expenses = newModel.expenses;
    _dailyBudget = newModel.dailyBudget;
    notifyListeners();
  }


}
