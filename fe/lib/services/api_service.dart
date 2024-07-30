import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/expense.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiService {
  static final String baseUrl = dotenv.env['URL'] ?? '';

  static Future<List<Expense>> getExpenses() async {
    final response = await http.get(Uri.parse('$baseUrl'));
    print(response.statusCode);
    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      return body.map((dynamic item) => Expense.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load expenses');
    }
  }

  static Future<void> addExpense(Expense expense) async {
    final response = await http.post(
      Uri.parse('$baseUrl'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(expense.toJson()),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to add expense');
    }
  }

  static Future<Map<String, dynamic>> getExpenseInfo({
    int? year,
    int? month,
  }) async {
    var uri;
    if (year != null && month != null) {
      uri = Uri.parse('${baseUrl}info?year=$year&month=$month');
    } else {
      uri = Uri.parse('${baseUrl}info');
    }

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load expense info');
    }
  }
}
