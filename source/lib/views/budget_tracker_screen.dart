import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:first/view_models/budget_view_model.dart';

class BudgetTrackerScreen extends StatefulWidget {
  const BudgetTrackerScreen({Key? key}) : super(key: key);

  @override
  _BudgetTrackerScreenState createState() => _BudgetTrackerScreenState();
}

class _BudgetTrackerScreenState extends State<BudgetTrackerScreen> {
  final _expenseAmountController = TextEditingController();

  @override
  void dispose() {
    _expenseAmountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Отслеживание бюджета'),
      ),
      body: Consumer<BudgetViewModel>(
        builder: (context, viewModel, child) {
          return Column(
            children: [
              Text('Общая сумма бюджета: ${viewModel.totalAmount}'),
              Text('Дневной лимит: ${viewModel.remainingDailyBudget}'),
              Text('Оставшийся бюджет: ${viewModel.totalRemainingBudget}'),
              // ... другие элементы для отображения данных ...

              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextFormField(
                  controller: _expenseAmountController,
                  decoration: const InputDecoration(labelText: 'Сумма расхода'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Введите сумму расхода';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Введите число';
                    }
                    return null;
                  },
                ),
              ),

              ElevatedButton(
                onPressed: () {
                  final expenseAmount = double.tryParse(_expenseAmountController.text) ?? 0.0;
                  viewModel.addExpense(expenseAmount);
                  _expenseAmountController.clear(); // Очищаем поле ввода
                },
                child: const Text('Добавить расход'),
              ),
              ElevatedButton(
                onPressed: () {
                  viewModel.nextDay();
                },
                child: const Text('Следующий день'),
              ),
            ],
          );
        },
      ),
    );
  }
}