import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_coin/blocs/expense_bloc.dart';
import 'package:flutter_coin/blocs/expense_event.dart';
import 'package:flutter_coin/blocs/expense_state.dart';
import 'package:flutter_coin/models/expense_model.dart';
import 'package:flutter_coin/widgets/expense_input_sheet.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _commentController = TextEditingController();
  int _selectedNavIndex = 0;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _showAddExpenseSheet(BuildContext context) {
    final expenseBloc = context.read<ExpenseBloc>();
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => BlocProvider<ExpenseBloc>.value(
        value: expenseBloc,
        child: const ExpenseInputSheet(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.grid_view_outlined),
            selectedIcon: Icon(Icons.grid_view),
            label: 'Categories',
          ),
          NavigationDestination(
            icon: Icon(Icons.bar_chart_outlined),
            selectedIcon: Icon(Icons.bar_chart),
            label: 'Stats',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        selectedIndex: _selectedNavIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedNavIndex = index;
          });
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddExpenseSheet(context),
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: BlocBuilder<ExpenseBloc, ExpenseState>(
            builder: (context, state) {
              if (state is ExpenseLoaded) {
                return Column(
                  children: [
                    _buildHeader(state),
                    const SizedBox(height: 20),
                    _buildChart(state),
                    const SizedBox(height: 20),
                    _buildExpenseList(state),
                  ],
                );
              }
              return const Center(child: CircularProgressIndicator());
            },
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(ExpenseLoaded state) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Total Balance',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            Text(
              '\$${state.totalBalance.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        IconButton(
          icon: const Icon(Icons.notifications_none),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildChart(ExpenseLoaded state) {
    final expenses = state.expenses;
    if (expenses.isEmpty) return const SizedBox.shrink();

    // Group expenses by day
    final Map<int, double> dailyExpenses = {};
    for (final expense in expenses) {
      final day = expense.date.day;
      dailyExpenses[day] = (dailyExpenses[day] ?? 0) + expense.amount;
    }

    return SizedBox(
      height: 200,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: dailyExpenses.values
                  .fold<double>(0, (max, value) => value > max ? value : max) *
              1.2,
          barTouchData: BarTouchData(enabled: false),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  return Text(value.toInt().toString());
                },
              ),
            ),
            leftTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),
          barGroups: dailyExpenses.entries.map((entry) {
            return BarChartGroupData(
              x: entry.key,
              barRods: [
                BarChartRodData(
                  toY: entry.value,
                  color: Colors.green,
                  width: 16,
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildExpenseList(ExpenseLoaded state) {
    return Expanded(
      child: ListView.builder(
        itemCount: state.expenses.length,
        itemBuilder: (context, index) {
          final expense = state.expenses[index];
          return ListTile(
            leading: _getCategoryIcon(expense.category),
            title: Text(expense.category.toString().split('.').last),
            subtitle: Text(expense.date.toString().split(' ')[0]),
            trailing: Text(
              '\$${expense.amount.toStringAsFixed(2)}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _getCategoryIcon(ExpenseCategory category) {
    IconData iconData;
    Color backgroundColor;

    switch (category) {
      case ExpenseCategory.shopping:
        iconData = Icons.shopping_bag;
        backgroundColor = Colors.blue.shade100;
      case ExpenseCategory.gifts:
        iconData = Icons.card_giftcard;
        backgroundColor = Colors.purple.shade100;
      case ExpenseCategory.food:
        iconData = Icons.fastfood;
        backgroundColor = Colors.orange.shade100;
      case ExpenseCategory.other:
        iconData = Icons.more_horiz;
        backgroundColor = Colors.grey.shade100;
    }

    return CircleAvatar(
      backgroundColor: backgroundColor,
      child: Icon(iconData, color: Colors.black),
    );
  }
}
