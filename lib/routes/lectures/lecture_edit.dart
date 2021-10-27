import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:ordnerd/models/helpers/linktype.dart';
import 'package:ordnerd/models/lecture.dart';
import 'package:ordnerd/models/link.dart';
import 'package:ordnerd/routes/other/qr_scanner.dart';
import 'package:ordnerd/utils/bloc/lecture/lecture_bloc.dart';
import 'package:ordnerd/utils/bloc/lecture/lecture_events.dart';
import 'package:ordnerd/widgets/link/link_edit.dart';

class LectureEditPage extends StatefulWidget {
  Lecture? lecture;
  late final bool _isNew;

  LectureEditPage({Key? key, this.lecture}) : super(key: key) {
    _isNew = lecture?.dbId == null;

    /// Only instantiate new if not in database, do not instantiate new if its freshly imported:
    lecture ??= Lecture();
  }

  static Route route({Lecture? lecture}) {
    return MaterialPageRoute(builder: (context) {
      return LectureEditPage(lecture: lecture);
    });
  }

  @override
  _LectureEditPageState createState() => _LectureEditPageState();
}

class _LectureEditPageState extends State<LectureEditPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            widget._isNew ? "New lecture" : "Edit " + widget.lecture!.name),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.qr_code_scanner),
            onPressed: () {
              Navigator.of(context).pushReplacement(QRScannerPage.route());
            },
          ),
          IconButton(
              icon: const Icon(Icons.save),
              onPressed: () {
                BlocProvider.of<LectureBloc>(context).add(widget._isNew
                    ? LectureAdded(widget.lecture!)
                    : LectureUpdated(widget.lecture!));
                Navigator.of(context).pop(widget.lecture);
              }),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: ListView(
          children: <Widget>[
            TextFormField(
              initialValue: widget.lecture!.name,
              decoration: const InputDecoration(hintText: "Name"),
              onChanged: (text) => widget.lecture!.name = text,
            ),
            TextFormField(
              autocorrect: false,
              initialValue: widget.lecture!.address,
              decoration: const InputDecoration(hintText: "Address"),
              onChanged: (text) => widget.lecture!.address = text,
            ),
            TextFormField(
              autocorrect: false,
              initialValue: widget.lecture!.tutoriumAddress,
              decoration: const InputDecoration(hintText: "Tutorium address"),
              onChanged: (text) => widget.lecture!.tutoriumAddress = text,
            ),
            for (String key in linkType)
              LinkEditorWidget(link: widget.lecture!.links[key]!),
            TextFormField(
              initialValue: widget.lecture!.customNotes,
              decoration: const InputDecoration(hintText: "Custom notes"),
              onChanged: (text) => widget.lecture!.customNotes = text,
              maxLines: null,
            ),
          ],
        ),
      ),
    );
  }
}
