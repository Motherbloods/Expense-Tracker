import 'package:flutter/material.dart';
import '../models/expense.dart';
import 'package:intl/intl.dart';

class ExpenseList extends StatelessWidget {
  final List<Expense> expenses;
  final String filter;
  final DateTime currentMonth;

  ExpenseList(
      {required this.expenses,
      required this.filter,
      required this.currentMonth});

  List<Expense> get filteredExpenses {
    final firstDayOfMonth = DateTime(currentMonth.year, currentMonth.month, 1);
    final lastDayOfMonth =
        DateTime(currentMonth.year, currentMonth.month + 1, 0);
    List<Expense> monthlyExpenses = expenses
        .where((e) =>
            e.date.isAfter(firstDayOfMonth.subtract(Duration(days: 1))) &&
            e.date.isBefore(lastDayOfMonth.add(Duration(days: 1))))
        .toList();

    switch (filter) {
      case 'week1':
        final endOfWeek1 = firstDayOfMonth.add(Duration(days: 7));
        return monthlyExpenses
            .where((e) => e.date.isBefore(endOfWeek1))
            .toList();
      case 'week2':
        final startOfWeek2 = firstDayOfMonth.add(Duration(days: 7));
        final endOfWeek2 = firstDayOfMonth.add(Duration(days: 14));
        return monthlyExpenses
            .where((e) =>
                e.date.isAfter(startOfWeek2.subtract(Duration(days: 1))) &&
                e.date.isBefore(endOfWeek2))
            .toList();
      case 'week3':
        final startOfWeek3 = firstDayOfMonth.add(Duration(days: 14));
        final endOfWeek3 = firstDayOfMonth.add(Duration(days: 21));
        return monthlyExpenses
            .where((e) =>
                e.date.isAfter(startOfWeek3.subtract(Duration(days: 1))) &&
                e.date.isBefore(endOfWeek3))
            .toList();
      case 'week4':
        final startOfWeek4 = firstDayOfMonth.add(Duration(days: 21));
        return monthlyExpenses
            .where(
                (e) => e.date.isAfter(startOfWeek4.subtract(Duration(days: 1))))
            .toList();
      case 'month':
      default:
        return monthlyExpenses;
    }
  }

  double get totalExpenses {
    return filteredExpenses.fold(0, (sum, expense) => sum + expense.amount);
  }

  @override
  Widget build(BuildContext context) {
    final displayedExpenses = filteredExpenses;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total Expenses:',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  Text(
                    'Rp ${totalExpenses.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.headline6?.copyWith(
                          color: Theme.of(context).primaryColor,
                        ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: displayedExpenses.length,
            itemBuilder: (context, index) {
              final expense = displayedExpenses[index];
              return Dismissible(
                key: Key(expense.id.toString()),
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.only(right: 20),
                  child: Icon(Icons.delete, color: Colors.white),
                ),
                direction: DismissDirection.endToStart,
                onDismissed: (direction) {
                  // TODO: Implement delete functionality
                },
                child: Card(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    title: Text(expense.name),
                    subtitle:
                        Text(DateFormat('dd-MM-yyyy').format(expense.date)),
                    trailing: Text(
                      'Rp ${expense.amount.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    onTap: () {
                      // TODO: Implement expense detail view
                    },
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
