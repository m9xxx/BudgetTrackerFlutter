import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:first/view_models/budget_view_model.dart';

class BudgetSetupScreen extends StatefulWidget {
  const BudgetSetupScreen({Key? key}) : super(key: key);

  @override
  _BudgetSetupScreenState createState() => _BudgetSetupScreenState();
}

class _BudgetSetupScreenState extends State<BudgetSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _totalAmountController = TextEditingController();
  final _totalDaysController = TextEditingController();

  @override
  void dispose() {
    _totalAmountController.dispose();
    _totalDaysController.dispose();
    super.dispose();
  }

  void _submitData() {
    if (_formKey.currentState!.validate()) {
      final totalAmount = double.parse(_totalAmountController.text);
      final totalDays = int.parse(_totalDaysController.text);

      Provider.of<BudgetViewModel>(context, listen: false).updateTotalAmount(totalAmount); // Обновляем totalAmount
      Provider.of<BudgetViewModel>(context, listen: false).updateTotalDays(totalDays); // Обновляем totalDays

      // Переход на экран отслеживания бюджета
      Navigator.of(context).pushReplacementNamed('/budget_tracker');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Настройка бюджета'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _totalAmountController,
                decoration: const InputDecoration(labelText: 'Общая сумма бюджета'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Введите общую сумму бюджета';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Введите число';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _totalDaysController,
                decoration: const InputDecoration(labelText: 'Количество дней'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Введите количество дней';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Введите число';
                  }
                  return null;
                },
              ),
              ElevatedButton(
                onPressed: _submitData,
                child: const Text('Сохранить'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}