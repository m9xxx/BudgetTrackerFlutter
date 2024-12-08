import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './state.dart';
import './component.dart';

class PageDefault extends StatelessWidget {
  const PageDefault({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<BudgetModel>(
      create: (_) => BudgetModel(0, 0), // Пример бюджета и дней
      child: const BudgetTracker(),
    );
  }
}

// class PageDefault extends StatelessWidget {
//   const PageDefault({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider<CounterModel>(
//         create: (_) => CounterModel(10), child: const Counter());
//   }
// }
