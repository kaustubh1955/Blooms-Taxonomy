import 'package:bloom/screens/detailed_analysis.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import 'indicator.dart';


class ResultScreen extends StatefulWidget {
  dynamic results;
  ResultScreen(this.results);
  @override
  _ResultScreenState createState() => _ResultScreenState();
}

dynamic performCalculations(dynamic results) {
  dynamic file = results["file"];
  dynamic pieData = List.filled(7, 0);
  int len = file.length;
  for(int i=0;i<len;i++){
    var maxx = 0.0;
    var pos = -1;
    for(int j=0;j<6;j++){
      if(file[i][j] > maxx){maxx=file[i][j];pos=j;}
    }
    if(maxx>=50){pieData[pos]++;}
    else pieData[6]++;
  }
  print("The lenght of the array is $len");
  print(pieData);
  return pieData;
}

int countQues(dynamic results){
  dynamic file = results["file"];
  return file.length;
}

class _ResultScreenState extends State<ResultScreen> {
  dynamic pieData = new List(7);
  int totQuestions;
  @override
  void initState() {
    super.initState();
    pieData = performCalculations(widget.results);
    totQuestions = countQues(widget.results);
  }
  int touchedIndex;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.only(top: 50),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(
                          Icons.arrow_left,
                          size: 30,
                        )),
                    Expanded(
                      child: Text("Result",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                              color: Color(0xff352661), fontSize: 25)),
                    ),
                  ],
                ),
              ),
              // SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: PieChart(
                        PieChartData(
                            pieTouchData:
                                PieTouchData(touchCallback: (pieTouchResponse) {
                              setState(() {
                                final desiredTouch = pieTouchResponse.touchInput
                                        is! PointerExitEvent &&
                                    pieTouchResponse.touchInput is! PointerUpEvent;
                                if (desiredTouch &&
                                    pieTouchResponse.touchedSection != null) {
                                  touchedIndex = pieTouchResponse
                                      .touchedSection.touchedSectionIndex;
                                } else {
                                  touchedIndex = -1;
                                }
                              });
                            }),
                            borderData: FlBorderData(
                              show: false,
                            ),
                            sectionsSpace: 0,
                            centerSpaceRadius: 40,
                            sections: showingSections(pieData, totQuestions)),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(right: 30),
                    child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const <Widget>[
                Indicator(
                    color: Color(0xffeb3434),
                    text: 'Knowledge',
                    isSquare: true,
                ),
                SizedBox(
                    height: 4,
                ),
                Indicator(
                    color: Color(0xff0293ee),
                    text: 'Analysis',
                    isSquare: true,
                ),
                SizedBox(
                    height: 4,
                ),
                Indicator(
                    color: Color(0xff845bef),
                    text: 'Comprehension',
                    isSquare: true,
                ),
                SizedBox(
                    height: 4,
                ),
                Indicator(
                    color: Color(0xffb75cbd),
                    text: 'Synthesis',
                    isSquare: true,
                ),
                SizedBox(
                    height: 4,
                ),
                Indicator(
                    color: Color(0xff13d38e),
                    text: 'Evaluation',
                    isSquare: true,
                ),
                SizedBox(
                    height: 4,
                ),
                Indicator(
                    color: Color(0xfff8b250),
                    text: 'Application',
                    isSquare: true,
                ),
                SizedBox(
                    height: 4,
                ),
                Indicator(
                    color: Color(0xffdfeb34),
                    text: 'Unknown',
                    isSquare: true,
                ),
                SizedBox(
                    height: 18,
                ),
              ],
            ),
                  ),
                ],
              ),
              SizedBox(height: 30),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                child: Text(
                  "(Distribution of paper in different levels)",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                      color: Color(0xff352661), fontSize: 12),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                child: Text(
                  "• Total number of questions: $totQuestions",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                      color: Color(0xff352661), fontSize: 18),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailedAnalysisScreen(widget.results),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 30, 0, 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "See Question wise Statistics",
                        style: GoogleFonts.poppins(
                            color: Color(0xff352661), fontSize: 18),
                      ),
                      Icon(Icons.arrow_right)
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.popUntil(context, (route) => route.isFirst);
                  // Navigator.pushAndRemoveUntil(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (BuildContext context) => AddFileScreen()),
                  //     );
                },
                child: Text("Upload another PDF",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                        color: Color(0xff352661), fontSize: 15)),
              ),
              Spacer(),
              Container(
                width: double.infinity,
                margin: EdgeInsets.only(top: 30),
                child: SvgPicture.asset(
                  'assets/bottom_image.svg',
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<PieChartSectionData> showingSections(dynamic pieData, dynamic total) {
    return List.generate(7, (i) {
      final isTouched = i == touchedIndex;
      final double fontSize = isTouched ? 25 : 13;
      final double radius = isTouched ? 60 : 50;
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: const Color(0xff0293ee),
            value: pieData[0]/total*100 != 0.0 ? pieData[0]/total*100: 0.1,
            title: pieData[0]/total*100 != 0.0 ? ((pieData[0]/total*100).round().toString() + "%"): (""),
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
        case 1:
          return PieChartSectionData(
            color: const Color(0xfff8b250),
            value: pieData[1]/total*100 != 0.0 ? pieData[1]/total*100: 0.1,
            title: pieData[1]/total*100 != 0.0 ? ((pieData[1]/total*100).round().toString() + "%"): (""),
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
        case 2:
          return PieChartSectionData(
            color: const Color(0xff845bef),
            value: pieData[2]/total*100 != 0.0 ? pieData[2]/total*100: 0.1,
            title: pieData[2]/total*100 != 0.0 ? ((pieData[2]/total*100).round().toString() + "%"): (""),
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
        case 3:
          return PieChartSectionData(
            color: const Color(0xff13d38e),
            value: pieData[3]/total*100 != 0.0 ? pieData[3]/total*100: 0.1,
            title: pieData[3]/total*100 != 0.0 ? ((pieData[3]/total*100).round().toString() + "%"): (""),
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
          case 4:
          return PieChartSectionData(
            color: const Color(0xffeb3434),
            value: pieData[4]/total*100 != 0.0 ? pieData[4]/total*100: 0.1,
            title: pieData[4]/total*100 != 0.0 ? ((pieData[4]/total*100).round().toString() + "%"): (""),
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
          case 5:
          return PieChartSectionData(
            color: const Color(0xffb75cbd),
            value: pieData[5]/total*100 != 0.0 ? pieData[5]/total*100: 0.1,
            title: pieData[5]/total*100 != 0.0 ? ((pieData[5]/total*100).round().toString() + "%"): (""),
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
          case 6:
          return PieChartSectionData(
            color: const Color(0xffdfeb34),
            value: pieData[6]/total*100 != 0.0 ? pieData[6]/total*100: 0.1,
            title: pieData[6]/total*100 != 0.0 ? ((pieData[6]/total*100).round().toString() + "%"): (""),
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
        default:
          return null;
      }
    });
  }
}
