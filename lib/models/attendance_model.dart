// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class Attend {
  String docId;
  String teamId;
  bool status;
  List<dynamic> presentId;

  Attend({
    required this.docId,
    required this.teamId,
    required this.status,
    required this.presentId,
  });

  Attend copyWith({
    String? docId,
    String? teamId,
    bool? status,
    List<String>? presentId,
  }) {
    return Attend(
      docId: docId ?? this.docId,
      teamId: teamId ?? this.teamId,
      status: status ?? this.status,
      presentId: presentId ?? this.presentId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docId': docId,
      'teamId': teamId,
      'status': status,
      'presentId': presentId,
    };
  }

  factory Attend.fromMap(Map<String, dynamic> map) {
    return Attend(
        docId: map['docId'] as String,
        teamId: map['teamId'] as String,
        status: map['status'] as bool,
        presentId: List<String>.from((map['presentId'] as List<String>)));
  }

  String toJson() => json.encode(toMap());

  factory Attend.fromJson(String source) =>
      Attend.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Attendance(docId: $docId, teamId: $teamId, status: $status, presentId: $presentId)';
  }

  @override
  bool operator ==(covariant Attend other) {
    if (identical(this, other)) return true;

    return other.docId == docId &&
        other.teamId == teamId &&
        other.status == status &&
        listEquals(other.presentId, presentId);
  }

  @override
  int get hashCode {
    return docId.hashCode ^
        teamId.hashCode ^
        status.hashCode ^
        presentId.hashCode;
  }
}
