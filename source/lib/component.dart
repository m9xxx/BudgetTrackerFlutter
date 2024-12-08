import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './state.dart';
import 'storage.dart';

class BudgetTracker extends StatelessWidget {
  const BudgetTracker({Key? key}) : super(key: key);

  Future<void> _resetBudget(BuildContext context) async {
    // 1. Очисти данные в shared_preferences
    await StorageHelper.clearData();

    // 2. Создай новый BudgetModel с начальными значениями
    final newModel = BudgetModel(0, 0); // Или другие начальные значения

    // 3. Обнови Provider
    Provider.of<BudgetModel>(context, listen: false).updateModel(newModel);

  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BudgetModel>(
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          title: const Text('Budget Tracker'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        'Day ${model.currentDay} of ${model.totalDays}',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Daily Budget: \₽${model.dailyBudget.toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Remaining Today: \₽${model.remainingDailyBudget.toStringAsFixed(2)}',
                        style: TextStyle(
                          color: model.isOverBudget ? Colors.red : Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        'Total Remaining Budget',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '\₽${model.totalRemainingBudget.toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ExpenseInput(),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: model.nextDay,
                child: const Text('Next Day'),
              ),
              ElevatedButton(
                onPressed: () {
                  // Вызовем функцию для сброса данных
                  _resetBudget(context);
                },
                child: const Text('Начать заново'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ExpenseInput extends StatelessWidget {
  ExpenseInput({Key? key}) : super(key: key);

  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<BudgetModel>(context, listen: false);

    return Column(
      children: [
        TextField(
          controller: _controller,
          decoration: const InputDecoration(
            labelText: 'Enter Expense',
          ),
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: () {
            final expense = double.tryParse(_controller.text);
            if (expense != null) {
              model.addExpense(expense);
              _controller.clear();
            }
          },
          child: const Text('Add Expense'),
        ),
      ],
    );
  }
}
