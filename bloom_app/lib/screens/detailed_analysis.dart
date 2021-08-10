import 'package:bloom/bar_graph/chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class DetailedAnalysisScreen extends StatefulWidget {
  dynamic results;
  DetailedAnalysisScreen(this.results);
  @override
  _DetailedAnalysisScreenState createState() => _DetailedAnalysisScreenState();
}

dynamic countQues(dynamic results){
  dynamic file = results["file"];
  return file.length;
}

List<dynamic> getData (dynamic results, int selected) {
  dynamic list = results['file'];
  selected--;
  print("List for selected: $selected : ");
  print(list[selected]);
  List<dynamic> data = [
    list[selected][0].roundToDouble(),
    list[selected][1].roundToDouble(),
    list[selected][2].roundToDouble(),
    list[selected][3].roundToDouble(),
    list[selected][4].roundToDouble(),
    list[selected][5].roundToDouble()
  ];
  print(data);
  return data;
}

class _DetailedAnalysisScreenState extends State<DetailedAnalysisScreen> {
  int selected = 1;
  dynamic totQues;
  @override
  void initState() {
    super.initState();
    totQues = countQues(widget.results);
  }
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              margin: EdgeInsets.only(top: 50),
              child: ListView(
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
                          child: Text("Detailed Analysis",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                  color: Color(0xff352661), fontSize: 25)),
                        ),
                      ],
                      
                    ),
                  ),
                  SizedBox(height: 50),
                  Container(
                    height: 250,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: GridView.count(
                      scrollDirection: Axis.horizontal,
                      crossAxisCount: 4,
                      children: List.generate(totQues, (index) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selected = index + 1;
                            });
                          },
                          child: Container(
                              padding: EdgeInsets.all(10),
                              margin: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  color: selected == (index + 1)
                                      ? Color(0xff352661)
                                      : Colors.transparent,
                                  border: Border.all(color: Color(0xff352661)),
                                  borderRadius: BorderRadius.circular(5)),
                              child: Center(
                                  child: Text(
                                (index + 1).toString(),
                                style: GoogleFonts.poppins(
                                    color: selected == (index + 1)
                                        ? Colors.white
                                        : Color(0xff352661)),
                              ))),
                        );
                      }),
                    ),
                  ),
                  SizedBox(height: 30),
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(
                  //       horizontal: 50, vertical: 20),
                  //   child:
                  // ),
                  Container(
                    child: SubscriberChart(
                      data: getData(widget.results, selected),
                      selected: selected,
                    )
                  ),
                  SizedBox(height: 90)
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  width: double.infinity,
                  height: 90,
                  margin: EdgeInsets.only(top: 30),
                  child: SvgPicture.asset(
                    'assets/bottom_image.svg',
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
