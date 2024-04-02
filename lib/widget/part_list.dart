import 'package:flutter/material.dart';
import 'package:partrelate_desktop/model/part.dart';
import 'package:partrelate_desktop/page/part_detail.dart';

class PartList extends StatelessWidget {
  const PartList(
      {super.key, required this.parts, this.onRefresh, this.freeze = false});

  final List<Part> parts;
  final Function? onRefresh;
  final bool freeze;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: parts.length,
      itemBuilder: (context, index) {
        return ListTile(
          onTap: freeze
              ? null
              : () async {
                  final bool needRefresh = await Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) =>
                              PartDetailPage(id: parts[index].id!)));

                  if (needRefresh && onRefresh != null) onRefresh!();
                },
          title: Text(parts[index].name),
        );
      },
    );
  }
}
