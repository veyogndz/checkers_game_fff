// To parse this JSON data, do
//
//     final lobbiesModel = lobbiesModelFromJson(jsonString);

import 'dart:convert';

LobbiesModel lobbiesModelFromJson(String str) =>
    LobbiesModel.fromJson(json.decode(str));

String lobbiesModelToJson(LobbiesModel data) => json.encode(data.toJson());

class LobbiesModel {
  LobbiesModel({
    required this.create,
    required this.participant,
    required this.founder,
    required this.board,
    required this.founderColor,
    required this.participantColor,
    required this.currentPlayer,
    required this.scoreWhite,
    required this.scoreBlue,
  });

  String create;
  String participant;
  String founder;
  Map<String,String>? board;
  String founderColor;
  String participantColor;
  String currentPlayer;
  int scoreWhite;
  int scoreBlue;

  factory LobbiesModel.fromJson(Map<String, dynamic> json) => LobbiesModel(
        create: json["create"],
        participant: json["participant"],
        founder: json["founder"],
        board: json["board"], // == null ? null : Board.fromJson(json["board"]),
        founderColor: json["founderColor"],
        participantColor: json["participantColor"],
        currentPlayer:json["currentPlayer"],
        scoreBlue: json["scoreBlue"],
        scoreWhite: json["scoreWhite"],
      );

  Map<String, dynamic> toJson() => {
        'create': create,
        'participant':participant ,
        'founder': founder,
        'board': board,
        'founderColor':founderColor,
        'participantColor':participantColor,
        'currentPlayer':currentPlayer,
        'scoreBlue':scoreBlue,
        'scoreWhite':scoreWhite,
    };
  }

