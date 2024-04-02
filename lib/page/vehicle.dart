import 'package:flutter/material.dart';
import 'package:partrelate_desktop/http/client.dart';
import 'package:partrelate_desktop/model/paginated_respose.dart';
import 'package:partrelate_desktop/model/vehicle.dart';
import 'package:partrelate_desktop/page/vehicle_create.dart';
import 'package:partrelate_desktop/widget/pagination.dart';
import 'package:partrelate_desktop/widget/searchbar_debounced.dart';
import 'package:partrelate_desktop/widget/vehicle_list.dart';

class VehiclePage extends StatefulWidget {
  const VehiclePage({super.key});

  @override
  State<VehiclePage> createState() => _VehiclePageState();
}

class _VehiclePageState extends State<VehiclePage> {
  String searchText = '';
  int currentPage = 1;
  late Future<PaginatedResponse> vehicleFuture;

  Future<PaginatedResponse> fetchVehicle(
      [String keyword = '', int page = 1]) async {
    var response = await dio
        .get('/vehicles', queryParameters: {'page': page, 'keyword': keyword});

    return PaginatedResponse.fromJson(response.data);
  }

  void onSearch(String text) {
    setState(() {
      vehicleFuture = fetchVehicle(text);
      currentPage = 1;
    });
  }

  void refreshVehicle() {
    setState(() {
      vehicleFuture = fetchVehicle(searchText, currentPage);
    });
  }

  @override
  void initState() {
    super.initState();
    vehicleFuture = fetchVehicle(searchText);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 81,
        ),
        SizedBox(
          width: 800,
          child: Column(
            children: <Widget>[
              Row(
                children: [
                  Expanded(
                    child: SearchBarDebounced(
                      onSearch: onSearch,
                      onChanged: (text) => searchText = text,
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        final bool success = await Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) =>
                                    const VehicleCreatePage()));

                        if (success) refreshVehicle();
                      },
                      child: const Icon(Icons.add))
                ],
              ),
              FutureBuilder<PaginatedResponse>(
                  future: vehicleFuture,
                  builder: (BuildContext context,
                      AsyncSnapshot<PaginatedResponse> snapshot) {
                    if (snapshot.hasData) {
                      List<Vehicle> vehicles = [];
                      final totalPages = snapshot.data!.totalPages;

                      if (currentPage > totalPages) {
                        setState(() {
                          currentPage--;
                        });
                      }

                      for (var vehicle in snapshot.data!.data) {
                        vehicles.add(Vehicle.fromJsonList(vehicle));
                      }

                      return Column(children: [
                        const SizedBox(
                          height: 15,
                        ),
                        VehicleList(
                          vehicles: vehicles,
                          onRefresh: refreshVehicle,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Pagination(
                          onMovePage: (step) {
                            setState(() {
                              currentPage = currentPage + step;
                              vehicleFuture =
                                  fetchVehicle(searchText, currentPage);
                            });
                          },
                          disableNext: currentPage >= totalPages,
                          disableBack: currentPage <= 1,
                        ),
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
            ],
          ),
        ),
        const SizedBox(
          height: 81,
        ),
      ],
    );
  }
}
