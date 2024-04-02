import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:partrelate_desktop/http/client.dart';
import 'package:partrelate_desktop/model/paginated_respose.dart';
import 'package:partrelate_desktop/model/part.dart';

class PTVPForm extends StatefulWidget {
  const PTVPForm(
      {super.key,
      this.onRefresh,
      this.initPart,
      this.initDescription,
      this.initQuantity,
      required this.handleSubmit});

  final Part? initPart;
  final String? initDescription;
  final String? initQuantity;
  final Function? onRefresh;
  final Function(Part part, String description, String quantity) handleSubmit;

  @override
  State<PTVPForm> createState() => _PTVPFormState();
}

class _PTVPFormState extends State<PTVPForm> {
  final partController = TextEditingController();
  final descriptionController = TextEditingController();
  final quantityController = TextEditingController();
  final GlobalKey _autocompleteKey = GlobalKey();
  late FocusNode partFocusNode;
  late FocusNode descriptionFocusNode;
  late Iterable<Part> _lastOptions = <Part>[];

  Part? selectedPart;
  String? _keyword;

  static String _displayStringForOption(Part option) => option.name;

  Future<List<Part>> fetchPart([String keyword = '', int page = 1]) async {
    var response = await dio
        .get('/parts', queryParameters: {'keyword': keyword, 'page': page});
    var parsed = PaginatedResponse.fromJson(response.data);

    List<Part> data = [];

    for (Map<String, dynamic> json in parsed.data) {
      data.add(Part.fromJsonList(json));
    }

    return data;
  }

  void refreshState() {
    setState(() {
      partController.clear();
      descriptionController.clear();
      quantityController.clear();
      selectedPart = null;
      _keyword = null;
      _lastOptions = <Part>[];
    });
  }

  @override
  void initState() {
    super.initState();
    if (widget.initPart != null) {
      selectedPart = widget.initPart!;
      partController.text = widget.initPart!.name;
    }
    if (widget.initDescription != null && widget.initDescription!.isNotEmpty) {
      descriptionController.text = widget.initDescription!;
    }
    if (widget.initQuantity != null && widget.initQuantity!.isNotEmpty) {
      quantityController.text = widget.initQuantity!;
    }
    partFocusNode = FocusNode();
    descriptionFocusNode = FocusNode();
  }

  @override
  void dispose() {
    partController.dispose();
    descriptionController.dispose();
    quantityController.dispose();
    descriptionFocusNode.dispose();
    partFocusNode.dispose();
    super.dispose();
  }

  onSubmit(String _) {
    widget.handleSubmit(
        selectedPart!, descriptionController.text, quantityController.text);

    refreshState();

    partFocusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    Future<Part?> createPart(String name) async {
      try {
        var response = await dio.post('/parts', data: {'name': name});

        Part part = Part.fromJson(response.data[0]);

        return part;
      } catch (e) {
        if (!mounted) return null;

        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.toString())));
      }

      return null;
    }

    InputDecoration decorationBuilder([String label = '']) {
      return InputDecoration(
          label: Text(label),
          border: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.grey),
            borderRadius: BorderRadius.circular(12),
          ));
    }

    return Row(
      children: [
        Expanded(
          flex: 2,
          child: RawAutocomplete<Part>(
            key: _autocompleteKey,
            focusNode: partFocusNode,
            textEditingController: partController,
            displayStringForOption: _displayStringForOption,
            fieldViewBuilder: (BuildContext context,
                TextEditingController controller,
                FocusNode focusNode,
                VoidCallback onFieldSubmitted) {
              return TextField(
                controller: controller,
                focusNode: focusNode,
                onEditingComplete: onFieldSubmitted,
                decoration: decorationBuilder('Part'),
              );
            },
            optionsBuilder: (TextEditingValue textEditingValue) async {
              _keyword = textEditingValue.text;

              final Iterable<Part> options =
                  await fetchPart(textEditingValue.text);

              List<Part> trimmed = options.toList();
              if (trimmed.length > 3) trimmed.length = 3;
              trimmed.add(Part(
                  id: -1,
                  name: 'Create New',
                  description: textEditingValue.text));
              final Iterable<Part> parsed = trimmed;

              if (_keyword != textEditingValue.text) {
                return _lastOptions;
              }

              _lastOptions = parsed;
              return parsed;
            },
            onSelected: (Part selection) async {
              if (selection.id == -1) {
                Part? part = await createPart(selection.description!);
                setState(() {
                  if (part == null) selectedPart = Part(name: 'Failed');
                  selectedPart = part;
                  partController.text = part!.name;
                });
              } else {
                selectedPart = selection;
              }
              descriptionFocusNode.requestFocus();
            },
            optionsViewBuilder: (context, onSelected, options) {
              return Align(
                  alignment: Alignment.topLeft,
                  child: Material(
                    elevation: 4.0,
                    child: Container(
                      constraints:
                          const BoxConstraints(maxWidth: 360, maxHeight: 300),
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        itemCount: options.length,
                        itemBuilder: (BuildContext context, int index) {
                          final Part option = options.elementAt(index);
                          return InkWell(
                            onTap: () {
                              if (option.id == -1) {
                                final String name = partController.text;
                                onSelected(Part(name: name));
                              }
                              onSelected(option);
                            },
                            child: Builder(builder: (BuildContext context) {
                              final bool highlight =
                                  AutocompleteHighlightedOption.of(context) ==
                                      index;
                              if (highlight) {
                                SchedulerBinding.instance!
                                    .addPostFrameCallback((Duration timeStamp) {
                                  Scrollable.ensureVisible(context,
                                      alignment: 0.5);
                                });
                              }
                              return Container(
                                color: highlight
                                    ? Theme.of(context).focusColor
                                    : null,
                                padding: const EdgeInsets.all(16.0),
                                child: Text(option.name),
                              );
                            }),
                          );
                        },
                      ),
                    ),
                  ));
            },
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          flex: 2,
          child: TextField(
            decoration: decorationBuilder('Description'),
            controller: descriptionController,
            focusNode: descriptionFocusNode,
            onSubmitted: onSubmit,
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          flex: 1,
          child: TextField(
              decoration: decorationBuilder('Quantity'),
              controller: quantityController,
              onSubmitted: onSubmit),
        ),
      ],
    );
  }
}
