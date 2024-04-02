import 'package:flutter/material.dart';
import 'package:partrelate_desktop/http/client.dart';
import 'package:partrelate_desktop/model/part.dart';
import 'package:partrelate_desktop/page/ptvp_update.dart';
import 'package:partrelate_desktop/widget/rounded_container.dart';

class PTVPDetail extends StatelessWidget {
  const PTVPDetail(
      {super.key,
      required this.id,
      required this.part,
      required this.vehiclePartId,
      this.description,
      this.quantity,
      this.onRefresh});

  final int id;
  final Part part;
  final int vehiclePartId;
  final String? description;
  final String? quantity;
  final Function? onRefresh;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top: 9, bottom: 9, left: 15, right: 15),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (description != null && description!.isNotEmpty) ...[
                RoundedContainer(
                    padding: 6,
                    radius: 6,
                    borderWidth: 1,
                    borderColor: Colors.black38,
                    backgroundColor: Colors.black12,
                    child: Text(
                      description!,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black54,
                          fontSize: 9),
                    )),
                const SizedBox(
                  height: 6,
                ),
              ],
              Text(
                part.name,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
              ),
              if (part.note != null && part.note!.isNotEmpty) ...[
                const SizedBox(
                  height: 9,
                ),
                RoundedContainer(
                    padding: 6,
                    radius: 6,
                    borderWidth: 1,
                    borderColor: Colors.black38,
                    backgroundColor: Colors.yellow.shade200,
                    child: Text(
                      part.note!,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black54,
                          fontSize: 9),
                    ))
              ],
              if (quantity != null && quantity!.isNotEmpty) ...[
                const SizedBox(
                  height: 9,
                ),
                RoundedContainer(
                    padding: 5,
                    radius: 9,
                    borderWidth: 1,
                    borderColor: Colors.black38,
                    backgroundColor: Colors.lightBlue.shade200,
                    child: Text(
                      quantity!,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black54,
                          fontSize: 11),
                    ))
              ],
            ],
          )),
          Column(
            children: [
              if (part.description != null && part.description!.isNotEmpty)
                TextButton(
                  onPressed: () => showDialog(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                            title: Text(part.name),
                            content: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(part.description!),
                                const SizedBox(
                                  height: 9,
                                ),
                                RoundedContainer(
                                    padding: 6,
                                    radius: 6,
                                    borderWidth: 1,
                                    borderColor: Colors.black38,
                                    backgroundColor: Colors.yellow.shade200,
                                    child: Text(
                                      part.note!,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black54,
                                          fontSize: 9),
                                    ))
                              ],
                            ),
                          )),
                  child: const Icon(
                    Icons.description,
                    color: Colors.grey,
                  ),
                ),
              TextButton(
                onPressed: () async {
                  final bool updated = await Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (BuildContext context) => PTVPUpdatePage(
                              id: id,
                              part: part,
                              description: description ?? '',
                              quantity: quantity ?? '',
                              vehiclePartId: vehiclePartId)));

                  if (updated && onRefresh != null) onRefresh!();
                },
                child: const Icon(
                  Icons.edit,
                ),
              ),
              TextButton(
                onPressed: () async {
                  try {
                    final bool confirmed = await deleteConfirmDialog(
                        context: context,
                        title: 'Deleting ${part.name}',
                        description:
                            'Are you sure you want to delete ${part.name} of $description?');

                    if (!confirmed) return;

                    await dio.delete('/parts_to_vehicle_parts/$id');

                    if (onRefresh != null) onRefresh!();
                  } catch (e) {
                    if (!context.mounted) return;

                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text(e.toString())));
                  }
                },
                child: const Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
              ),
            ],
          )
          // MenuAnchor(
          //   builder: (BuildContext context, MenuController controller,
          //       Widget? child) {
          //     return IconButton(
          //         onPressed: () {
          //           if (controller.isOpen) {
          //             controller.close();
          //           } else {
          //             controller.open();
          //           }
          //         },
          //         icon: const Icon(Icons.more_horiz));
          //   },
          //   menuChildren: <MenuItemButton>[
          //     MenuItemButton(onPressed: () {}, child: const Icon(Icons.edit)),
          //     MenuItemButton(onPressed: () {}, child: const Icon(Icons.delete)),
          //   ],
          // )
        ]));
    // return ListTile(
    //   titleAlignment: ListTileTitleAlignment.top,
    //   title: Column(
    //     crossAxisAlignment: CrossAxisAlignment.start,
    //     children: [
    //       if (description != null && description!.isNotEmpty) ...[
    //         RoundedContainer(
    //             padding: 6,
    //             radius: 6,
    //             borderWidth: 1,
    //             borderColor: Colors.black38,
    //             backgroundColor: Colors.black12,
    //             child: Text(
    //               description!,
    //               style: const TextStyle(
    //                   fontWeight: FontWeight.bold,
    //                   color: Colors.black54,
    //                   fontSize: 9),
    //             )),
    //         const SizedBox(
    //           height: 6,
    //         ),
    //       ],
    //       Text(
    //         name,
    //         style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
    //       ),
    //       if (quantity != null && quantity!.isNotEmpty) ...[
    //         const SizedBox(
    //           height: 9,
    //         ),
    //         RoundedContainer(
    //             padding: 5,
    //             radius: 9,
    //             borderWidth: 1,
    //             borderColor: Colors.black38,
    //             backgroundColor: Colors.lightBlue.shade200,
    //             child: Text(
    //               quantity!,
    //               style: const TextStyle(
    //                   fontWeight: FontWeight.bold,
    //                   color: Colors.black54,
    //                   fontSize: 11),
    //             ))
    //       ],
    //     ],
    //   ),
    //   trailing: Column(
    //     children: [
    //       ElevatedButton(onPressed: null, child: Icon(Icons.description)),
    //       ElevatedButton(onPressed: null, child: Icon(Icons.edit)),
    //       ElevatedButton(onPressed: null, child: Icon(Icons.delete)),
    //     ],
    //   ),
    //   trailing: MenuAnchor(
    //     builder:
    //         (BuildContext context, MenuController controller, Widget? child) {
    //       return IconButton(
    //           onPressed: () {
    //             if (controller.isOpen) {
    //               controller.close();
    //             } else {
    //               controller.open();
    //             }
    //           },
    //           icon: const Icon(Icons.more_horiz));
    //     },
    //     menuChildren: <MenuItemButton>[
    //       MenuItemButton(onPressed: () {}, child: const Icon(Icons.edit)),
    //       MenuItemButton(onPressed: () {}, child: const Icon(Icons.delete)),
    //     ],
    //   )
    // );
  }
}

Future<bool> deleteConfirmDialog(
    {required BuildContext context,
    required String title,
    required String description}) async {
  return await showDialog(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      title: Text(title),
      content: Text(description),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Yes')),
        TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('No'))
      ],
    ),
  );
}
