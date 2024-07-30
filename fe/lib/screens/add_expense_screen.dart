import 'package:flutter/material.dart';
import '../models/expense.dart';
import '../services/api_service.dart';
import 'package:intl/intl.dart';

class AddExpenseScreen extends StatefulWidget {
  @override
  _AddExpenseScreenState createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Expense')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: [
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Expense Name',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.shopping_cart),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter an expense name';
                }
                return null;
              },
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _amountController,
              decoration: InputDecoration(
                labelText: 'Amount',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.attach_money),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter an amount';
                }
                if (double.tryParse(value) == null) {
                  return 'Please enter a valid number';
                }
                return null;
              },
            ),
            SizedBox(height: 16),
            InkWell(
              onTap: () async {
                final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: _selectedDate,
                  firstDate: DateTime(2000),
                  lastDate: DateTime.now(),
                );
                if (picked != null && picked != _selectedDate) {
                  setState(() {
                    _selectedDate = picked;
                  });
                }
              },
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: 'Date',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.calendar_today),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(DateFormat('dd-MM-yyyy').format(_selectedDate)),
                    Icon(Icons.arrow_drop_down),
                  ],
                ),
              ),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              child: Text('Save Expense'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16),
              ),
              onPressed: _submitForm,
            ),
          ],
        ),
      ),
    );
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final newExpense = Expense(
        name: _nameController.text,
        amount: double.parse(_amountController.text),
        date: _selectedDate,
      );

      try {
        await ApiService.addExpense(newExpense);
        Navigator.pop(context, true);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save expense')),
        );
      }
    }
  }
}
