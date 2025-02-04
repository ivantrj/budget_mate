import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_coin/blocs/expense_bloc.dart';
import 'package:flutter_coin/blocs/expense_state.dart';
import 'package:flutter_coin/models/expense_model.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExpenseBloc, ExpenseState>(
      builder: (context, state) {
        if (state is ExpenseLoaded) {
          final categoryTotals = _calculateCategoryTotals(state.expenses);

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: ExpenseCategory.values.length,
            itemBuilder: (context, index) {
              final category = ExpenseCategory.values[index];
              final total = categoryTotals[category] ?? 0.0;

              return Card(
                child: ListTile(
                  leading: Icon(_getCategoryIcon(category)),
                  title: Text(category.toString().split('.').last),
                  trailing: Text(
                    '\$${total.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              );
            },
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Map<ExpenseCategory, double> _calculateCategoryTotals(
    List<Expense> expenses,
  ) {
    final totals = <ExpenseCategory, double>{};
    for (final expense in expenses) {
      totals[expense.category] =
          (totals[expense.category] ?? 0.0) + expense.amount;
    }
    return totals;
  }

  IconData _getCategoryIcon(ExpenseCategory category) {
    switch (category) {
      case ExpenseCategory.shopping:
        return Icons.shopping_bag;
      case ExpenseCategory.gifts:
        return Icons.card_giftcard;
      case ExpenseCategory.food:
        return Icons.restaurant;
      default:
        return Icons.attach_money;
    }
  }
}
