// To parse this JSON data, do
//
//     final filedataModel = filedataModelFromJson(jsonString);

import 'dart:convert';

FiledataModel filedataModelFromJson(String str) => FiledataModel.fromJson(json.decode(str));

String filedataModelToJson(FiledataModel data) => json.encode(data.toJson());

class FiledataModel {
    FiledataModel({
        this.file,
    });

    List<List<double>> file;

    factory FiledataModel.fromJson(Map<String, dynamic> json) => FiledataModel(
        file: List<List<double>>.from(json["file"].map((x) => List<double>.from(x.map((x) => x.toDouble())))),
    );

    Map<String, dynamic> toJson() => {
        "file": List<dynamic>.from(file.map((x) => List<dynamic>.from(x.map((x) => x)))),
    };
}
