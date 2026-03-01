import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/analytics_provider.dart';

class AnalyticsScreen extends ConsumerWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analytics = ref.watch(analyticsProvider);

    final grouped = analytics.groupedExpenses;
    final total = analytics.totalExpenses;

    if (grouped.isEmpty) {
      return const Scaffold(
        body: Center(
          child: Text("No expense data available"),
        ),
      );
    }

    final entries = grouped.entries.toList();

    return Scaffold(
      appBar: AppBar(title: const Text("Analytics")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            const SizedBox(height: 20),

            /// PIE CHART
            SizedBox(
              height: 250,
              child: PieChart(
                PieChartData(
                  sections: List.generate(
                    entries.length,
                    (index) {
                      final value = entries[index].value;
                      final percentage = (value / total) * 100;

                      return PieChartSectionData(
                        value: value,
                        title: "${percentage.toStringAsFixed(1)}%",
                        radius: 90,
                        titleStyle: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            /// BAR CHART
            SizedBox(
              height: 250,
              child: BarChart(
                BarChartData(
                  barGroups: List.generate(
                    entries.length,
                    (index) {
                      return BarChartGroupData(
                        x: index,
                        barRods: [
                          BarChartRodData(
                            toY: entries[index].value,
                            width: 20,
                            borderRadius: BorderRadius.circular(6),
                          )
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            /// CATEGORY LIST
            ...entries.map((e) {
              final percent = (e.value / total) * 100;

              return ListTile(
                title: Text(e.key),
                trailing: Text(
                  "${percent.toStringAsFixed(1)}%",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
