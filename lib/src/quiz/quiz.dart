library quiz;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:provider/provider.dart';
import 'package:quiver/async.dart';
import 'package:charts_flutter/flutter.dart' as charts;

part 'quiz.model.dart';
part 'quiz.g.dart';
part 'quiz.controller.dart';
part 'take_quiz.page.dart';
part 'quiz_result.page.dart';