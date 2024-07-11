import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:reciperescue_client/colors/colors.dart';
import 'package:reciperescue_client/controllers/analytics_controller.dart';

class _BarChart extends StatelessWidget {
  final List<double> data;
  final FilterDate dataType;
  const _BarChart(this.data, this.dataType);

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        barTouchData: barTouchData,
        titlesData: titlesData,
        borderData: borderData,
        barGroups: data.asMap().entries.map((entry) {
          int index = entry.key;
          double value = entry.value;

          return BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                toY: value,
                gradient: LinearGradient(
                  colors: [primary[400]!, primary[200]!],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
            ],
            showingTooltipIndicators: [0],
          );
        }).toList(),
        gridData: const FlGridData(show: false),
        alignment: BarChartAlignment.spaceAround,
        maxY: (data.reduce((a, b) => a > b ? a : b) * 1.2).toDouble(),
      ),
    );
  }

  BarTouchData get barTouchData => BarTouchData(
        enabled: true,
        touchTooltipData: BarTouchTooltipData(
          getTooltipColor: (group) => Colors.transparent,
          tooltipPadding: EdgeInsets.zero,
          tooltipMargin: 8,
          getTooltipItem: (
            BarChartGroupData group,
            int groupIndex,
            BarChartRodData rod,
            int rodIndex,
          ) {
            return BarTooltipItem(
              rod.toY.round().toString(),
              TextStyle(
                color: primary[100],
                fontWeight: FontWeight.bold,
              ),
            );
          },
        ),
      );

  Widget getTitles(double value, TitleMeta meta) {
    final style = TextStyle(
      color: primary[500],
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    String text = '';
    final DateTime today = DateTime.now();
    if (dataType == FilterDate.lastWeek) {
      DateTime labelDate = today.subtract(Duration(days: 6 - value.toInt()));
      final List<String> dayNames = [
        'Sun',
        'Mon',
        'Tue',
        'Wed',
        'Thu',
        'Fri',
        'Sat'
      ];
      text = dayNames[labelDate.weekday % 7];
      // switch (value.toInt()) {
      //   case 0:
      //     text = 'Mn';
      //     break;
      //   case 1:
      //     text = 'Te';
      //     break;
      //   case 2:
      //     text = 'Wd';
      //     break;
      //   case 3:
      //     text = 'Tu';
      //     break;
      //   case 4:
      //     text = 'Fr';
      //     break;
      //   case 5:
      //     text = 'St';
      //     break;
      //   case 6:
      //     text = 'Sn';
      //     break;
      //   default:
      //     text = '';
      //     break;
      // }
    } else if (dataType == FilterDate.lastSixMonths) {
      final List<String> monthNames = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec'
      ];
      switch (value.toInt()) {
        case 0:
          text = monthNames[(today.month - 6) % 12];
          break;
        case 1:
          text = monthNames[(today.month - 5) % 12];
          break;
        case 2:
          text = monthNames[(today.month - 4) % 12];
          break;
        case 3:
          text = monthNames[(today.month - 3) % 12];
          break;
        case 4:
          text = monthNames[(today.month - 2) % 12];
          break;
        case 5:
          text = monthNames[today.month - 1 % 12];
          break;
        default:
          text = '';
          break;
      }
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 4,
      child: Text(text, style: style),
    );
  }

  FlTitlesData get titlesData => FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            getTitlesWidget: getTitles,
          ),
        ),
        leftTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      );

  FlBorderData get borderData => FlBorderData(
        show: false,
      );

  LinearGradient get _barsGradient => LinearGradient(
        colors: [
          primary[900]!,
          primary[100]!,
        ],
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
      );
}

class MyBarChart extends StatefulWidget {
  final List<double> data;
  final FilterDate dataType;
  const MyBarChart(this.data, this.dataType, {super.key});

  @override
  State<StatefulWidget> createState() => MyBarChartState();
}

class MyBarChartState extends State<MyBarChart> {
  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.6,
      child: _BarChart(widget.data, widget.dataType),
    );
  }
}
