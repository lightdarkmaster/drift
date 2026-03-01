import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/database/database_helper.dart';

final salaryProvider =
    StateNotifierProvider<SalaryNotifier, SalaryState>((ref) {
  return SalaryNotifier();
});

class SalaryState {
  final double salary;
  final double totalExpenses;
  final List<Map<String, dynamic>> expenses;

  double get remaining => salary - totalExpenses;

  SalaryState({
    required this.salary,
    required this.totalExpenses,
    required this.expenses,
  });
}

class SalaryNotifier extends StateNotifier<SalaryState> {
  SalaryNotifier()
      : super(SalaryState(salary: 0, totalExpenses: 0, expenses: [])) {
    loadData();
  }

  Future<void> loadData() async {
    final db = await DatabaseHelper.instance.database;

    final salaryData = await db.query("salary");
    final expensesData = await db.query("expenses");

    double salaryAmount =
        salaryData.isNotEmpty ? salaryData.first["amount"] as double : 0;

    double total =
        expensesData.fold(0, (sum, e) => sum + (e["amount"] as double));

    state = SalaryState(
        salary: salaryAmount, totalExpenses: total, expenses: expensesData);
  }

  Future<void> addExpense(String label, double amount) async {
    final db = await DatabaseHelper.instance.database;

    await db.insert("expenses", {
      "label": label,
      "amount": amount,
      "created_at": DateTime.now().toIso8601String()
    });

    loadData();
  }

  Future<void> deleteExpense(int id) async {
    final db = await DatabaseHelper.instance.database;

    await db.delete(
      "expenses",
      where: "id = ?",
      whereArgs: [id],
    );

    await loadData();
  }
}
