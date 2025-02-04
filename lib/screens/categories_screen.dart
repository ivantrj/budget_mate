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

          final totalExpenses =
              categoryTotals.values.fold(0.0, (sum, amount) => sum + amount);

          return SafeArea(
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Total Spending',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'USD ${totalExpenses.toStringAsFixed(2)}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                    child: ListView.builder(
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
                ))
              ],
            ),
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
