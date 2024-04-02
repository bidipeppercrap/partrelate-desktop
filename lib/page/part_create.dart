import 'dart:async';

import 'package:flutter/material.dart';
import 'package:partrelate_desktop/http/client.dart';
import 'package:partrelate_desktop/model/paginated_respose.dart';
import 'package:partrelate_desktop/model/part.dart';
import 'package:partrelate_desktop/widget/part_list.dart';
import 'package:partrelate_desktop/widget/vehicle_form.dart';

class PartCreatePage extends StatefulWidget {
  const PartCreatePage({super.key});

  @override
  State<PartCreatePage> createState() => _PartCreatePageState();
}

class _PartCreatePageState extends State<PartCreatePage> {
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final noteController = TextEditingController();
  Timer? _debounce;
  final Duration _debounceDuration = const Duration(milliseconds: 300);

  late Future<PaginatedResponse> partFuture;

  Future<PaginatedResponse> fetchPart(
      [String keyword = '', int page = 1]) async {
    var response = await dio
        .get('/parts', queryParameters: {'page': page, 'keyword': keyword});

    return PaginatedResponse.fromJson(response.data);
  }

  _onSearchChanged() async {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(_debounceDuration, () {
      refreshPart();
    });
  }

  void refreshPart() {
    setState(() {
      partFuture = fetchPart(nameController.text);
    });
  }

  @override
  void initState() {
    super.initState();
    nameController.addListener(_onSearchChanged);
    partFuture = fetchPart(nameController.text);
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    noteController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Future<void> createPartOrFailed() async {
      try {
        await dio.post('/parts', data: {
          'name': nameController.text,
          'description': descriptionController.text,
          'note': noteController.text
        });

        if (!mounted) return;

        return Navigator.pop(context, true);
      } catch (e) {
        if (!mounted) return;

        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }

    return Center(
        child: Padding(
            padding: const EdgeInsets.all(150),
            child: SizedBox(
                width: 800,
                child: Column(
                  children: [
                    Card(
                      child: Padding(
                          padding: const EdgeInsets.all(30),
                          child: Column(
                            children: [
                              const Text('Create Part'),
                              const SizedBox(
                                height: 15,
                              ),
                              VehicleForm(
                                nameController: nameController,
                                descriptionController: descriptionController,
                                noteController: noteController,
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              ElevatedButton(
                                  onPressed: createPartOrFailed,
                                  child: const Text('Submit')),
                              const SizedBox(
                                height: 15,
                              ),
                              ElevatedButton(
                                  onPressed: () {
                                    return Navigator.pop(context, false);
                                  },
                                  child: const Text('Cancel'))
                            ],
                          )),
                    ),
                    FutureBuilder<PaginatedResponse>(
                        future: partFuture,
                        builder: (BuildContext context,
                            AsyncSnapshot<PaginatedResponse> snapshot) {
                          if (snapshot.hasData) {
                            List<Part> parts = [];
                            for (var vehicle in snapshot.data!.data) {
                              parts.add(Part.fromJsonList(vehicle));
                            }

                            return Column(children: [
                              const SizedBox(
                                height: 15,
                              ),
                              PartList(
                                freeze: true,
                                parts: parts,
                              ),
                              const SizedBox(
                                height: 15,
                              )
                            ]);
                          }

                          if (snapshot.hasError) {
                            return Center(
                                child: ElevatedButton(
                                    onPressed: refreshPart,
                                    child: const Icon(Icons.refresh)));
                          }

                          return const Center(
                              child: CircularProgressIndicator());
                        }),
                  ],
                ))));
  }
}
