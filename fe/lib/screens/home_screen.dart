// import 'package:flutter/material.dart';
// import '../widgets/expense_list.dart';
// import '../widgets/filter_bar.dart';
// import '../models/expense.dart';
// import '../services/api_service.dart';
// import '../services/notification_service.dart';

// class HomeScreen extends StatefulWidget {
//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   List<Expense> _expenses = [];
//   String _currentFilter = 'all';
//   DateTime _currentMonth = DateTime.now();
//   final NotificationService _notificationService = NotificationService();

//   @override
//   void initState() {
//     super.initState();
//     _loadExpenses();
//   }

//   Future<void> _loadExpenses() async {
//     try {
//       final expenses = await ApiService.getExpenses();
//       setState(() {
//         _expenses = expenses;
//       });
//     } catch (e) {
//       // Handle error
//       print('Failed to load expenses: $e');
//     }
//   }

//   void _onFilterChanged(String filter) {
//     setState(() {
//       _currentFilter = filter;
//       if (filter == 'month') {
//         _currentMonth = DateTime.now();
//       }
//     });
//   }

//   void _onPreviousMonth() {
//     setState(() {
//       _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1, 1);
//     });
//   }

//   void _onNextMonth() {
//     setState(() {
//       _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1, 1);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Expense Tracker'),
//         actions: [
//           PopupMenuButton(
//             itemBuilder: (context) => [
//               PopupMenuItem(
//                 child: Text('Jadwalkan Pengingat'),
//                 value: 'reminder',
//               ),
//               PopupMenuItem(
//                 child: Text('Informasi Pengeluaran'),
//                 value: 'info',
//               ),
//             ],
//             onSelected: (value) {
//               if (value == 'reminder') {
//                 // TODO: Implement reminder scheduling
//               } else if (value == 'info') {
//                 Navigator.pushNamed(context, '/expense_info');
//               }
//             },
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           FilterBar(
//             onFilterChanged: _onFilterChanged,
//             currentMonth: _currentMonth,
//             onPreviousMonth: _onPreviousMonth,
//             onNextMonth: _onNextMonth,
//             currentFilter: _currentFilter,
//           ),
//           Expanded(
//             child: ExpenseList(
//               expenses: _expenses,
//               filter: _currentFilter,
//               currentMonth: _currentMonth,
//             ),
//           ),
//         ],
//       ),
//       floatingActionButton: FloatingActionButton(
//         child: Icon(Icons.add),
//         onPressed: () async {
//           final result = await Navigator.pushNamed(context, '/add_expense');
//           if (result == true) {
//             _loadExpenses();
//           }
//         },
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import '../widgets/expense_list.dart';
import '../widgets/filter_bar.dart';
import '../models/expense.dart';
import '../services/api_service.dart';
import '../services/notification_service.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Expense> _expenses = [];
  String _currentFilter = 'all';
  DateTime _currentMonth = DateTime.now();
  final NotificationService _notificationService = NotificationService();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadExpenses();
  }

  Future<void> _loadExpenses() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final expenses = await ApiService.getExpenses();
      setState(() {
        _expenses = expenses;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load expenses. Please try again.';
        _isLoading = false;
      });
    }
  }

  void _onFilterChanged(String filter) {
    setState(() {
      _currentFilter = filter;
      if (filter == 'month') {
        _currentMonth = DateTime.now();
      }
    });
  }

  void _onPreviousMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1, 1);
    });
  }

  void _onNextMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1, 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Expense Tracker'),
        actions: [
          IconButton(
            icon: Icon(Icons.info_outline),
            onPressed: () => Navigator.pushNamed(context, '/expense_info'),
          ),
          IconButton(
            icon: Icon(Icons.notifications_outlined),
            onPressed: () {
              // TODO: Implement reminder scheduling
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadExpenses,
        child: Column(
          children: [
            FilterBar(
              onFilterChanged: _onFilterChanged,
              currentMonth: _currentMonth,
              onPreviousMonth: _onPreviousMonth,
              onNextMonth: _onNextMonth,
              currentFilter: _currentFilter,
            ),
            Expanded(
              child: _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : _errorMessage != null
                      ? Center(child: Text(_errorMessage!))
                      : ExpenseList(
                          expenses: _expenses,
                          filter: _currentFilter,
                          currentMonth: _currentMonth,
                        ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          final result = await Navigator.pushNamed(context, '/add_expense');
          if (result == true) {
            _loadExpenses();
          }
        },
      ),
    );
  }
}
