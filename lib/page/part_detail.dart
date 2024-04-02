import 'package:flutter/material.dart';
import 'package:partrelate_desktop/http/client.dart';
import 'package:partrelate_desktop/model/part.dart';
import 'package:partrelate_desktop/widget/part_detail_card.dart';

class PartDetailPage extends StatefulWidget {
  const PartDetailPage({super.key, required this.id});

  final int id;

  @override
  State<PartDetailPage> createState() => _PartDetailPageState();
}

class _PartDetailPageState extends State<PartDetailPage> {
  late Future<Part> _partDetail;

  Future<Part> fetchPartDetail(int id) async {
    var response = await dio.get('/parts/$id');
    var part = Part.fromJson(response.data);

    return part;
  }

  void refreshPage() {
    setState(() {
      _partDetail = fetchPartDetail(widget.id);
    });
  }

  @override
  void initState() {
    _partDetail = fetchPartDetail(widget.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Part>(
        future: _partDetail,
        builder: (BuildContext context, AsyncSnapshot<Part> snapshot) {
          if (snapshot.hasData) {
            Part part = snapshot.data!;

            return Center(
                child: Padding(
              padding: const EdgeInsets.only(
                  top: 150, left: 27, right: 27, bottom: 150),
              child: SizedBox(
                width: 800,
                child: PartDetailCard(
                  id: widget.id,
                  name: part.name,
                  description: part.description,
                  note: part.note,
                  onRefresh: refreshPage,
                ),
              ),
            ));
          }

          if (snapshot.hasError) {
            return Center(
              child: ElevatedButton(
                  onPressed: refreshPage, child: const Icon(Icons.refresh)),
            );
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}
