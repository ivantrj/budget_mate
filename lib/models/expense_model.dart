import 'package:flutter/material.dart';

enum ExpenseCategory {
  shopping,
  gifts,
  food,
  other,
}

class Expense {
  Expense({
    required this.id,
    required this.amount,
    required this.category,
    required this.date,
    this.comment,
    required String description,
  });

  final String id;
  final double amount;
  final ExpenseCategory category;
  final DateTime date;
  final String? comment;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'amount': amount,
      'category': category.toString(),
      'date': date.toIso8601String(),
      'comment': comment,
    };
  }

  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      id: json['id'] as String,
      amount: json['amount'] as double,
      category: ExpenseCategory.values.firstWhere(
        (e) => e.toString() == json['category'],
      ),
      date: DateTime.parse(json['date'] as String),
      comment: json['comment'] as String?,
      description: '',
    );
  }

  Expense copyWith({
    String? id,
    double? amount,
    ExpenseCategory? category,
    DateTime? date,
    String? comment,
  }) {
    return Expense(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      date: date ?? this.date,
      comment: comment ?? this.comment,
      description: '',
    );
  }
}
