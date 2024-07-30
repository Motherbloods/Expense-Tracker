class Expense {
  String? id;
  String name;
  double amount;
  DateTime date;

  Expense({
    this.id,
    required this.name,
    required this.amount,
    required this.date,
  });

  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
        id: json["_id"],
        name: json["name"],
        amount: json["amount"],
        date: DateTime.parse(json["date"]));
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      "name": name,
      "amount": amount,
      "date": date.toIso8601String()
    };
  }
}
