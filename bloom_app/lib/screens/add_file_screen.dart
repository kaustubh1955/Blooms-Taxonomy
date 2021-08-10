import 'package:bloom/screens/pdf_view_screen.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class AddFileScreen extends StatefulWidget {
  @override
  _AddFileScreenState createState() => _AddFileScreenState();
}

class _AddFileScreenState extends State<AddFileScreen> {
  bool isLoading = false;
  PlatformFile file;

  Future<void> pickFile() async {
    setState(() {
      isLoading = true;
    });
    FilePickerResult result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    setState(() {
      isLoading = false;
    });
    if (result != null) {
      file = result.files.first;
    } else {
      print("User cancelled the req");
      file = null;
      // User canceled the picker
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.only(top: 50),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: Text("Set a balanced Question Paper",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                        color: Color(0xff352661), fontSize: 25)),
              ),
              Container(
                margin: EdgeInsets.only(top: 30, bottom: 30),
                child: SvgPicture.asset(
                  'assets/first_screen_img.svg',
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 30),
                child: Text(
                  "Get the complete statistics of questions based on different cognitive levels.",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                      color: Color(0xff352661), fontSize: 18),
                ),
              ),
              isLoading
                  ? Center(child: CircularProgressIndicator())
                  : GestureDetector(
                      onTap: () async {
                        await pickFile();
                        if (file != null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ViewPdfScreen(file)),
                          );
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(50, 30, 50, 20),
                        child: Container(
                          padding: EdgeInsets.fromLTRB(40, 15, 40, 15),
                          decoration: BoxDecoration(
                              color: Color(0xff6256FF),
                              borderRadius: BorderRadius.circular(10)),
                          child: Text(
                            "Upload PDF",
                            style: GoogleFonts.poppins(
                                color: Colors.white, fontSize: 15),
                          ),
                        ),
                      ),
                    ),
              // Text("Select from Drive",
              //     textAlign: TextAlign.center,
              //     style: GoogleFonts.poppins(
              //         color: Color(0xff352661), fontSize: 15)),
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
