import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/salary_provider.dart';
import '../widgets/summary_card.dart';
import '../widgets/expense_tile.dart';
import '../widgets/add_expense_dialog.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(salaryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Monthly Tracker"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // open add expense dialog
        },
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            SummaryCard(
              title: "Salary",
              amount: state.salary,
              color: Colors.blue,
            ),
            SummaryCard(
              title: "Total Expenses",
              amount: state.totalExpenses,
              color: Colors.orange,
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              child: SummaryCard(
                title: "Remaining",
                amount: state.remaining,
                color: state.remaining > 0 ? Colors.green : Colors.red,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: state.expenses.isEmpty
                  ? const Center(child: Text("No expenses yet"))
                  : ListView.builder(
                      itemCount: state.expenses.length,
                      itemBuilder: (context, index) {
                        return ExpenseTile(expense: state.expenses[index]);
                      },
                    ),
            )
          ],
        ),
      ),
    );
  }
}
