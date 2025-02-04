import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_coin/blocs/expense_bloc.dart';
import 'package:flutter_coin/blocs/expense_event.dart';
import 'package:flutter_coin/models/expense_model.dart';

class ExpenseInputSheet extends StatefulWidget {
  const ExpenseInputSheet({super.key});

  @override
  State<ExpenseInputSheet> createState() => _ExpenseInputSheetState();
}

class _ExpenseInputSheetState extends State<ExpenseInputSheet> {
  ExpenseCategory _selectedCategory = ExpenseCategory.shopping;
  final _commentController = TextEditingController();
  String _amount = '';

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.grey[800],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.attach_money,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: _showCategoryPicker,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: _getCategoryColor(_selectedCategory).withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Icon(_getCategoryIcon(_selectedCategory)),
                                const Icon(Icons.keyboard_arrow_down),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit_note, color: Colors.white),
                      onPressed: () {},
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Text(
                      r'$',
                      style: TextStyle(color: Colors.white, fontSize: 24),
                    ),
                    Text(
                      _amount.isEmpty ? '0' : _amount,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                TextField(
                  controller: _commentController,
                  decoration: const InputDecoration(
                    hintText: 'Add comment...',
                    hintStyle: TextStyle(color: Colors.grey),
                    border: InputBorder.none,
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
          GridView.count(
            shrinkWrap: true,
            crossAxisCount: 3,
            childAspectRatio: 1.5,
            children: [
              '1',
              '2',
              '3',
              '4',
              '5',
              '6',
              '7',
              '8',
              '9',
              r'$',
              '0',
              ',',
            ]
                .map(
                  (key) => TextButton(
                    onPressed: () {
                      setState(() {
                        if (key == r'$' || key == ',') return;
                        _amount += key;
                      });
                    },
                    child: Text(
                      key,
                      style: const TextStyle(fontSize: 24),
                    ),
                  ),
                )
                .toList(),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            child: FilledButton(
              onPressed: () {
                if (_amount.isNotEmpty) {
                  context.read<ExpenseBloc>().add(
                        AddExpense(
                          Expense(
                            amount: double.parse(_amount),
                            description: _commentController.text,
                            category: _selectedCategory,
                            date: DateTime.now(),
                            id: '',
                          ),
                        ),
                      );
                  Navigator.pop(context);
                }
              },
              style: FilledButton.styleFrom(
                backgroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Continue'),
            ),
          ),
        ],
      ),
    );
  }

  void _showCategoryPicker() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select Category',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...ExpenseCategory.values.map((category) => ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _getCategoryColor(category).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(_getCategoryIcon(category), color: _getCategoryColor(category)),
              ),
              title: Text(category.toString().split('.').last),
              onTap: () {
                setState(() {
                  _selectedCategory = category;
                });
                Navigator.pop(context);
              },
            )),
          ],
        ),
      ),
    );
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

  Color _getCategoryColor(ExpenseCategory category) {
    switch (category) {
      case ExpenseCategory.shopping:
        return Colors.blue;
      case ExpenseCategory.gifts:
        return Colors.purple;
      case ExpenseCategory.food:
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}
