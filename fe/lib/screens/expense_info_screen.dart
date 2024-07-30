import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'package:intl/intl.dart';

class ExpenseInfoScreen extends StatefulWidget {
  @override
  _ExpenseInfoScreenState createState() => _ExpenseInfoScreenState();
}

class _ExpenseInfoScreenState extends State<ExpenseInfoScreen> {
  late Future<Map<String, dynamic>> _expenseInfoFuture;
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _loadExpenseInfo();
  }

  void _loadExpenseInfo() {
    _expenseInfoFuture = ApiService.getExpenseInfo(
      year: _selectedDate.year,
      month: _selectedDate.month,
    );
  }

  String formatDate(String dateString) {
    final date = DateTime.parse(dateString);
    return DateFormat('dd-MM-yyyy').format(date);
  }

  void _onDateChanged(DateTime? newDate) {
    if (newDate != null) {
      setState(() {
        _selectedDate = newDate;
        _loadExpenseInfo();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Informasi Pengeluaran')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: InputDecorator(
                    decoration: InputDecoration(
                      labelText: 'Bulan dan Tahun',
                      border: OutlineInputBorder(),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(DateFormat('MMMM yyyy').format(_selectedDate)),
                        IconButton(
                          icon: Icon(Icons.calendar_today),
                          onPressed: () async {
                            final pickedDate = await showDatePicker(
                              context: context,
                              initialDate: _selectedDate,
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2101),
                            );
                            _onDateChanged(pickedDate);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<Map<String, dynamic>>(
              future: _expenseInfoFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data == null) {
                  return Center(child: Text('Tidak ada data tersedia'));
                } else {
                  final data = snapshot.data!;
                  return ListView(
                    children: [
                      _buildMonthSummaryCard(data),
                      _buildHighestSingleExpenseCard(
                          data['highestSingleExpense']),
                      _buildHighestExpenseDateCard(data['highestExpenseDate']),
                    ],
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthSummaryCard(Map<String, dynamic> data) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Ringkasan Bulan',
                style: Theme.of(context).textTheme.headline6),
            SizedBox(height: 8),
            Text('Periode: ${data['monthYear'] ?? 'Tidak tersedia'}'),
            Text('Total Pengeluaran: ${_formatAmount(data['totalExpenses'])}'),
          ],
        ),
      ),
    );
  }

  Widget _buildHighestSingleExpenseCard(Map<String, dynamic>? highestExpense) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Pengeluaran Tertinggi',
                style: Theme.of(context).textTheme.headline6),
            SizedBox(height: 8),
            if (highestExpense != null) ...[
              Text('Nama: ${highestExpense['name'] ?? 'Tidak tersedia'}'),
              Text('Jumlah: ${_formatAmount(highestExpense['amount'])}'),
              Text('Tanggal: ${formatDate(highestExpense['date'])}'),
            ] else
              Text('Tidak ada data pengeluaran tertinggi'),
          ],
        ),
      ),
    );
  }

  Widget _buildHighestExpenseDateCard(
      Map<String, dynamic>? highestExpenseDate) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Tanggal Pengeluaran Terbanyak',
                style: Theme.of(context).textTheme.headline6),
            SizedBox(height: 8),
            if (highestExpenseDate != null) ...[
              Text('Tanggal: ${formatDate(highestExpenseDate['date'])}'),
              Text('Total: ${_formatAmount(highestExpenseDate['amount'])}'),
              SizedBox(height: 8),
              ExpansionTile(
                title: Text('Lihat Detail'),
                children: [
                  if (highestExpenseDate['details'] != null &&
                      (highestExpenseDate['details'] as List).isNotEmpty)
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: highestExpenseDate['details'].length,
                      itemBuilder: (context, index) {
                        final detail = highestExpenseDate['details'][index];
                        return ListTile(
                          title: Text(detail['name'] ?? 'Nama tidak tersedia'),
                          subtitle: Text(_formatAmount(detail['amount'])),
                          trailing: Text(formatDate(detail['date'])),
                        );
                      },
                    )
                  else
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Tidak ada detail tersedia'),
                    ),
                ],
              ),
            ] else
              Text('Tidak ada data tanggal pengeluaran terbanyak'),
          ],
        ),
      ),
    );
  }

  String _formatAmount(dynamic amount) {
    if (amount == null) return 'Rp -';
    try {
      return NumberFormat.currency(
        locale: 'id_ID',
        symbol: 'Rp ',
        decimalDigits: 0,
      ).format(amount);
    } catch (e) {
      return 'Rp -';
    }
  }
}
