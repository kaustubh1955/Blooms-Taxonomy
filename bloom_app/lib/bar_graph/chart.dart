import 'package:fl_chart/fl_chart.dart' as chart;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SubscriberChart extends StatelessWidget {
  final List<dynamic> data;
  final int selected;
  SubscriberChart({@required this.data, this.selected});

  @override
  Widget build(BuildContext context) {

    return Container(
      height: 400,
      padding: EdgeInsets.all(20),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(bottom: 30),
              child: Text(
                "Distribution of Q${selected.toString()} in different levels",
                textAlign: TextAlign.center,
                style:
                    GoogleFonts.poppins(fontSize: 18),
              ),
            ),
            Expanded(
              child: chart.BarChart(
                chart.BarChartData(alignment: chart.BarChartAlignment.spaceAround,
                  maxY: 100,
                  barTouchData: chart.BarTouchData(
                    enabled: false,
                  ),
                  titlesData: chart.FlTitlesData(
                    show: true,
                    bottomTitles: chart.SideTitles(
                      showTitles: true,
                      margin: 30,
                      rotateAngle: 30,
                      getTitles: (double value) {
                        switch (value.toInt()) {
                          case 0:
                            return 'Analysis';
                          case 1:
                            return 'Application';
                          case 2:
                            return 'Comprehension';
                          case 3:
                            return 'Evaluation';
                          case 4:
                            return 'Knowledge';
                          case 5:
                            return 'Synthesis';
                          default:
                            return '';
                        }
                      },
                    ),
                    leftTitles: chart.SideTitles(showTitles: false),
                  ),
                  borderData: chart.FlBorderData(show:false),
                  barGroups: [
                    chart.BarChartGroupData(
                      x: 0,
                      barRods: [
                        chart.BarChartRodData(y: data[0], colors: [Colors.lightBlueAccent, Colors.greenAccent])
                      ],
                      showingTooltipIndicators: [data[0] == 0 ? 1: 0],
                    ),
                    chart.BarChartGroupData(
                      x: 1,
                      barRods: [
                        chart.BarChartRodData(y: data[1], colors: [Colors.lightBlueAccent, Colors.greenAccent])
                      ],
                      showingTooltipIndicators: [data[1] == 0 ? 1: 0],
                    ),
                    chart.BarChartGroupData(
                      x: 2,
                      barRods: [
                        chart.BarChartRodData(y: data[2], colors: [Colors.lightBlueAccent, Colors.greenAccent])
                      ],
                      showingTooltipIndicators: [data[2] == 0 ? 1: 0],
                    ),
                    chart.BarChartGroupData(
                      x: 3,
                      barRods: [
                        chart.BarChartRodData(y: data[3], colors: [Colors.lightBlueAccent, Colors.greenAccent])
                      ],
                      showingTooltipIndicators: [data[3] == 0 ? 1: 0],
                    ),
                    chart.BarChartGroupData(
                      x: 4,
                      barRods: [
                        chart.BarChartRodData(y: data[4], colors: [Colors.lightBlueAccent, Colors.greenAccent])
                      ],
                      showingTooltipIndicators: [data[4] == 0 ? 1: 0],
                    ),
                    chart.BarChartGroupData(
                      x: 5,
                      barRods: [
                        chart.BarChartRodData(y: data[5], colors: [Colors.lightBlueAccent, Colors.greenAccent])
                      ],
                      showingTooltipIndicators: [data[5] == 0 ? 1: 0],
                    ),
                  ],
                )
              ),
            )
          ],
        ),
      ),
    );
  }
}
