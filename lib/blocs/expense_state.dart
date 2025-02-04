import 'package:flutter_coin/models/expense_model.dart';

abstract class ExpenseState {}

class ExpenseInitial extends ExpenseState {}

class ExpenseLoading extends ExpenseState {}

class ExpenseLoaded extends ExpenseState {
  ExpenseLoaded(this.expenses);
  final List<Expense> expenses;

  double get totalBalance => expenses.fold(
        0,
        (total, expense) => total + expense.amount,
      );

  Map<ExpenseCategory, double> get expensesByCategory {
    final map = <ExpenseCategory, double>{};
    for (final expense in expenses) {
      map[expense.category] = (map[expense.category] ?? 0) + expense.amount;
    }
    return map;
  }

  List<Expense> expensesForPeriod(DateTime start, DateTime end) {
    return expenses
        .where((expense) =>
            expense.date.isAfter(start) && expense.date.isBefore(end))
        .toList();
  }
}

class ExpenseError extends ExpenseState {
  ExpenseError(this.message);
  final String message;
}
