import 'package:fe/screens/add_expense_screen.dart';
import 'package:fe/screens/expense_info_screen.dart';
import 'package:fe/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load(fileName: 'assets/.env');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expense Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
        '/add_expense': (context) => AddExpenseScreen(),
        '/expense_info': (context) => ExpenseInfoScreen(),
      },
    );
  }
}
