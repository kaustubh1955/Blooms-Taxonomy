import 'dart:async';

import 'package:bloom/screens/result_screen.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';


class ViewPdfScreen extends StatefulWidget {
  PlatformFile file;
  ViewPdfScreen(this.file);
  @override
  _ViewPdfScreenState createState() => _ViewPdfScreenState();
}

Future<dynamic> getResults(PlatformFile pdfFile) async{

  Dio dio = new Dio();
  MultipartFile multipat = await MultipartFile.fromFile(pdfFile.path, filename: pdfFile.name);

  FormData formData = new FormData.fromMap({"myfile": multipat,});

  Response response = await dio.post("http://10.0.2.2:8000/uploadFile",data: formData);
  if(response.statusCode == 200){
    return response.data;
  }
  else{
    return null;
  }
}

class _ViewPdfScreenState extends State<ViewPdfScreen> {
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
                      child: Text("Home",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                              color: Color(0xff352661), fontSize: 25)),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 50, horizontal: 40),
                padding: EdgeInsets.symmetric(horizontal: 20),
                height: 180,
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Color(0xff352661))),
                child: Center(
                  child: Text(
                    widget.file.name,
                    style: GoogleFonts.poppins(
                        color: Color(0xff352661), fontSize: 18),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                child: Text(
                  "Get the complete statistics of questions based on different cognitive levels.",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                      color: Color(0xff352661), fontSize: 18),
                ),
              ),
              GestureDetector(
                onTap: () async {
                  final dynamic results = await getResults(widget.file);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ResultScreen(results),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(50, 30, 50, 20),
                  child: Container(
                    padding: EdgeInsets.fromLTRB(40, 15, 40, 15),
                    decoration: BoxDecoration(
                        color: Color(0xff6256FF),
                        borderRadius: BorderRadius.circular(10)),
                    child: Text(
                      "See Analysis",
                      style: GoogleFonts.poppins(
                          color: Colors.white, fontSize: 15),
                    ),
                  ),
                ),
              ),
              GestureDetector(
              onTap: () {
              Navigator.pop(context);
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
}
