import 'dart:async';

import 'package:flutter/material.dart';
import 'package:partrelate_desktop/http/client.dart';
import 'package:partrelate_desktop/model/paginated_respose.dart';
import 'package:partrelate_desktop/model/vehicle.dart';
import 'package:partrelate_desktop/widget/vehicle_form.dart';
import 'package:partrelate_desktop/widget/vehicle_list.dart';

class VehicleCreatePage extends StatefulWidget {
  const VehicleCreatePage({super.key});

  @override
  State<VehicleCreatePage> createState() => _VehicleCreatePageState();
}

class _VehicleCreatePageState extends State<VehicleCreatePage> {
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final noteController = TextEditingController();
  Timer? _debounce;
  final Duration _debounceDuration = const Duration(milliseconds: 300);

  late Future<PaginatedResponse> vehicleFuture;

  Future<PaginatedResponse> fetchVehicle(
      [String keyword = '', int page = 1]) async {
    var response = await dio
        .get('/vehicles', queryParameters: {'page': page, 'keyword': keyword});

    return PaginatedResponse.fromJson(response.data);
  }

  _onSearchChanged() async {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(_debounceDuration, () {
      refreshVehicle();
    });
  }

  void refreshVehicle() {
    setState(() {
      vehicleFuture = fetchVehicle(nameController.text);
    });
  }

  @override
  void initState() {
    super.initState();
    nameController.addListener(_onSearchChanged);
    vehicleFuture = fetchVehicle(nameController.text);
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
    Future<void> updateVehicleOrFailed() async {
      try {
        await dio.post('/vehicles', data: {
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
          child: Column(children: [
            Card(
              child: Padding(
                  padding: const EdgeInsets.all(30),
                  child: Column(
                    children: [
                      const Text('Create Vehicle'),
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
                          onPressed: updateVehicleOrFailed,
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
                future: vehicleFuture,
                builder: (BuildContext context,
                    AsyncSnapshot<PaginatedResponse> snapshot) {
                  if (snapshot.hasData) {
                    List<Vehicle> vehicles = [];
                    for (var vehicle in snapshot.data!.data) {
                      vehicles.add(Vehicle.fromJsonList(vehicle));
                    }

                    return Column(children: [
                      const SizedBox(
                        height: 15,
                      ),
                      VehicleList(
                        freeze: true,
                        vehicles: vehicles,
                      ),
                      const SizedBox(
                        height: 15,
                      )
                    ]);
                  }

                  if (snapshot.hasError) {
                    return Center(
                        child: ElevatedButton(
                            onPressed: refreshVehicle,
                            child: const Icon(Icons.refresh)));
                  }

                  return const Center(child: CircularProgressIndicator());
                }),
          ])),
    ));
  }
}
