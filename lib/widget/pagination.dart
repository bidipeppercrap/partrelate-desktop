import 'package:flutter/material.dart';

class Pagination extends StatelessWidget {
  const Pagination(
      {super.key,
      this.onMovePage,
      this.disableBack = false,
      this.disableNext = false});

  final void Function(int step)? onMovePage;
  final bool disableBack;
  final bool disableNext;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Row(children: <Widget>[
          Expanded(
              child: ElevatedButton(
                  onPressed: onMovePage != null && !disableBack
                      ? () => onMovePage!(-1)
                      : null,
                  child: const Icon(Icons.arrow_left))),
          const SizedBox(
            width: 15,
          ),
          Expanded(
              child: ElevatedButton(
                  onPressed: onMovePage != null && !disableNext
                      ? () => onMovePage!(1)
                      : null,
                  child: const Icon(Icons.arrow_right))),
        ]),
      ),
    );
  }
}
