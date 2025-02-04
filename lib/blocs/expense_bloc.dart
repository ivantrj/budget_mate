import 'package:bloc/bloc.dart';
import 'package:flutter_coin/blocs/expense_event.dart';
import 'package:flutter_coin/blocs/expense_state.dart';
import 'package:flutter_coin/models/expense_model.dart';

class ExpenseBloc extends Bloc<ExpenseEvent, ExpenseState> {
  ExpenseBloc() : super(ExpenseInitial()) {
    on<LoadExpenses>(_onLoadExpenses);
    on<AddExpense>(_onAddExpense);
    // on<ClearExpenses>(_onClearExpenses);
    on<DeleteExpense>(_onDeleteExpense);
  }

  final List<Expense> _expenses = [];

  void _onLoadExpenses(LoadExpenses event, Emitter<ExpenseState> emit) {
    emit(ExpenseLoading());
    try {
      emit(ExpenseLoaded(_expenses));
    } catch (e) {
      emit(ExpenseError(e.toString()));
    }
  }

  void _onAddExpense(AddExpense event, Emitter<ExpenseState> emit) {
    emit(ExpenseLoading());
    try {
      _expenses.add(event.expense);
      emit(ExpenseLoaded(_expenses));
    } catch (e) {
      emit(ExpenseError(e.toString()));
    }
  }

  void _onDeleteExpense(DeleteExpense event, Emitter<ExpenseState> emit) {
    emit(ExpenseLoading());
    try {
      _expenses.removeWhere((expense) => expense.id == event.expenseId);
      emit(ExpenseLoaded(_expenses));
    } catch (e) {
      emit(ExpenseError(e.toString()));
    }
  }
}
