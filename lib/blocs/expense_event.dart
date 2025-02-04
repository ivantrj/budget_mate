import 'package:flutter_coin/models/expense_model.dart';

abstract class ExpenseEvent {}

class ClearExpenses extends ExpenseEvent {}

class AddExpense extends ExpenseEvent {
  AddExpense(this.expense);
  final Expense expense;
}

class DeleteExpense extends ExpenseEvent {
  DeleteExpense(this.expenseId);
  final String expenseId;
}

class LoadExpenses extends ExpenseEvent {}
