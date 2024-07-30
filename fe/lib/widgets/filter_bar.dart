import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FilterBar extends StatelessWidget {
  final Function(String) onFilterChanged;
  final DateTime currentMonth;
  final Function() onPreviousMonth;
  final Function() onNextMonth;
  final String currentFilter;

  FilterBar({
    required this.onFilterChanged,
    required this.currentMonth,
    required this.onPreviousMonth,
    required this.onNextMonth,
    required this.currentFilter,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 50,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _buildFilterChip('Semua', 'all'),
              _buildFilterChip('Minggu 1', 'week1'),
              _buildFilterChip('Minggu 2', 'week2'),
              _buildFilterChip('Minggu 3', 'week3'),
              _buildFilterChip('Minggu 4', 'week4'),
              _buildFilterChip('Bulan Ini', 'month'),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(Icons.chevron_left),
                onPressed: onPreviousMonth,
              ),
              Text(
                DateFormat('MMMM yyyy').format(currentMonth),
                style: Theme.of(context).textTheme.titleMedium,
              ),
              IconButton(
                icon: Icon(Icons.chevron_right),
                onPressed: onNextMonth,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFilterChip(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: FilterChip(
        label: Text(label),
        selected: currentFilter == value,
        onSelected: (_) => onFilterChanged(value),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';

// class FilterBar extends StatelessWidget {
//   final Function(String) onFilterChanged;
//   final DateTime currentMonth;
//   final Function(DateTime) onMonthChanged;
//   final String currentFilter;

//   FilterBar({
//     required this.onFilterChanged,
//     required this.currentMonth,
//     required this.onMonthChanged,
//     required this.currentFilter,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Container(
//           height: 50,
//           child: ListView(
//             scrollDirection: Axis.horizontal,
//             children: [
//               _buildFilterChip('Semua', 'all'),
//               _buildFilterChip('Minggu 1', 'week1'),
//               _buildFilterChip('Minggu 2', 'week2'),
//               _buildFilterChip('Minggu 3', 'week3'),
//               _buildFilterChip('Minggu 4', 'week4'),
//               _buildFilterChip('Bulan Ini', 'month'),
//             ],
//           ),
//         ),
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
//           child: InkWell(
//             onTap: () => _selectMonth(context),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Icon(Icons.calendar_today, size: 20),
//                 SizedBox(width: 8),
//                 Text(
//                   DateFormat('MMMM yyyy').format(currentMonth),
//                   style: Theme.of(context).textTheme.titleMedium,
//                 ),
//                 Icon(Icons.arrow_drop_down),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildFilterChip(String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 4.0),
//       child: FilterChip(
//         label: Text(label),
//         selected: currentFilter == value,
//         onSelected: (_) => onFilterChanged(value),
//       ),
//     );
//   }

//   void _selectMonth(BuildContext context) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: currentMonth,
//       firstDate: DateTime(2000),
//       lastDate: DateTime(2101),
//       initialDatePickerMode: DatePickerMode.year,
//     );
//     if (picked != null && picked != currentMonth) {
//       onMonthChanged(DateTime(picked.year, picked.month, 1));
//     }
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';

// class FilterBar extends StatelessWidget {
//   final Function(String) onFilterChanged;
//   final DateTime currentMonth;
//   final Function(DateTime) onMonthChanged;
//   final String currentFilter;

//   FilterBar({
//     required this.onFilterChanged,
//     required this.currentMonth,
//     required this.onMonthChanged,
//     required this.currentFilter,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Container(
//           height: 50,
//           child: ListView(
//             scrollDirection: Axis.horizontal,
//             children: [
//               _buildFilterChip('Semua', 'all'),
//               _buildFilterChip('Minggu 1', 'week1'),
//               _buildFilterChip('Minggu 2', 'week2'),
//               _buildFilterChip('Minggu 3', 'week3'),
//               _buildFilterChip('Minggu 4', 'week4'),
//               _buildFilterChip('Bulan Ini', 'month'),
//             ],
//           ),
//         ),
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
//           child: InkWell(
//             onTap: () => _selectMonth(context),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Icon(Icons.calendar_today, size: 20),
//                 SizedBox(width: 8),
//                 Text(
//                   DateFormat('MMMM yyyy').format(currentMonth),
//                   style: Theme.of(context).textTheme.titleMedium,
//                 ),
//                 Icon(Icons.arrow_drop_down),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildFilterChip(String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 4.0),
//       child: FilterChip(
//         label: Text(label),
//         selected: currentFilter == value,
//         onSelected: (_) => onFilterChanged(value),
//       ),
//     );
//   }

//   void _selectMonth(BuildContext context) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: currentMonth,
//       firstDate: DateTime(2000),
//       lastDate: DateTime(2101),
//       initialDatePickerMode: DatePickerMode.year,
//     );
//     if (picked != null && picked != currentMonth) {
//       onMonthChanged(DateTime(picked.year, picked.month, 1));
//     }
//   }
// }
