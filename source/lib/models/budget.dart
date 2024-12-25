class Budget {
  double _totalAmount;
  double _dailyLimit;
  int currentDay;
  int _totalDays;

  Budget({
    required double totalAmount,
    required double dailyLimit,
    this.currentDay = 1,
    required int totalDays,
  })  : _totalAmount = totalAmount,
        _dailyLimit = dailyLimit,
        _totalDays = totalDays;

  set totalAmount(double newTotalAmount) {
    _totalAmount = newTotalAmount;
  }

  set dailyLimit(double newDailyLimit) {
    _dailyLimit = newDailyLimit;
  }

  set totalDays(int newDays) {
    _totalDays = newDays;
  }

  // Геттеры для доступа к приватным переменным
  double get totalAmount => _totalAmount;
  double get dailyLimit => _dailyLimit;
  int get totalDays => _totalDays;
}

