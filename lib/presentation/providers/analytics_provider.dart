import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'salary_provider.dart';

final analyticsProvider = Provider<AnalyticsState>((ref) {
  final salaryState = ref.watch(salaryProvider);

  final Map<String, double> grouped = {};

  for (var expense in salaryState.expenses) {
    final label = expense["label"] as String;
    final amount = expense["amount"] as double;

    grouped[label] = (grouped[label] ?? 0) + amount;
  }

  final total = salaryState.totalExpenses;

  return AnalyticsState(
    groupedExpenses: grouped,
    totalExpenses: total,
  );
});

class AnalyticsState {
  final Map<String, double> groupedExpenses;
  final double totalExpenses;

  AnalyticsState({
    required this.groupedExpenses,
    required this.totalExpenses,
  });
}
