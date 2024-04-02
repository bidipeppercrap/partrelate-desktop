import 'package:flutter/material.dart';
import 'package:partrelate_desktop/widget/rounded_container.dart';

class PTVPDetail extends StatelessWidget {
  const PTVPDetail(
      {super.key, required this.name, this.description, this.quantity});

  final String name;
  final String? description;
  final String? quantity;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      titleAlignment: ListTileTitleAlignment.top,
      title: Column(
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
            name,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          ),
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
      ),
      // trailing: MenuAnchor(
      //   builder:
      //       (BuildContext context, MenuController controller, Widget? child) {
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
    );
  }
}
