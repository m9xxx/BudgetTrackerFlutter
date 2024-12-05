import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './state.dart';
import './component.dart';
import './storage.dart'; // Импортируем файл с классом StorageHelper

void main() {
  WidgetsFlutterBinding
      .ensureInitialized(); // Инициализация для асинхронных операций
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Budget Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const BudgetLoader(),
    );
  }
}

class BudgetLoader extends StatelessWidget {
  const BudgetLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<BudgetModel>(
      future: BudgetModel.loadModel(), // Загрузка сохраненных данных
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Показываем индикатор загрузки
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          // Обрабатываем ошибку, если она произошла
          return Scaffold(
            body: Center(child: Text('Error: ${snapshot.error}')),
          );
        } else {
          // Если данные успешно загружены
          final budgetModel = snapshot.data!;
          if (budgetModel.totalBudget == 0 || budgetModel.totalDays == 0) {
            // Если данных нет, показываем экран настройки бюджета
            return const BudgetSetup();
          } else {
            // Если данные есть, показываем экран отслеживания бюджета
            return ChangeNotifierProvider(
              create: (context) => budgetModel,
              child: const BudgetTracker(),
            );
          }
        }
      },
    );
  }
}

class BudgetSetup extends StatefulWidget {
  const BudgetSetup({Key? key}) : super(key: key);

  @override
  _BudgetSetupState createState() => _BudgetSetupState();
}

class _BudgetSetupState extends State<BudgetSetup> {
  final _formKey = GlobalKey<FormState>();
  final _budgetController = TextEditingController();
  final _daysController = TextEditingController();

  @override
  void dispose() {
    _budgetController.dispose();
    _daysController.dispose();
    super.dispose();
  }

  void _submitData() {
    if (_formKey.currentState!.validate()) {
      final double budget = double.parse(_budgetController.text);
      final int days = int.parse(_daysController.text);

      // Сохраняем данные в SharedPreferences
      StorageHelper.saveData('totalBudget', budget.toString());
      StorageHelper.saveData('totalDays', days.toString());

      // Переходим на экран отслеживания бюджета
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => ChangeNotifierProvider(
            create: (context) => BudgetModel(budget, days),
            child: const BudgetTracker(),
          ),
        ),
      );
    }
  }

  Future<void> _loadPreviousSession() async {
    final savedBudget = await StorageHelper.loadData('totalBudget');
    final savedDays = await StorageHelper.loadData('totalDays');

    if (savedBudget != null && savedDays != null) {
      final double budget = double.parse(savedBudget);
      final int days = int.parse(savedDays);

      // Переходим на экран отслеживания бюджета с данными из предыдущей сессии
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => ChangeNotifierProvider(
            create: (context) => BudgetModel(budget, days),
            child: const BudgetTracker(),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Budget Setup'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextFormField(
                controller: _budgetController,
                decoration:
                    const InputDecoration(labelText: 'Enter Total Budget'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a budget';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _daysController,
                decoration:
                    const InputDecoration(labelText: 'Enter Number of Days'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter number of days';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid integer';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submitData,
                child: const Text('Start Budget Tracking'),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _loadPreviousSession,
                child: const Text('Continue from Previous Session'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
