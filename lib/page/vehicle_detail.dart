import 'package:flutter/material.dart';
import 'package:partrelate_desktop/http/client.dart';
import 'package:partrelate_desktop/model/vehicle_detail.dart';
import 'package:partrelate_desktop/model/vehicle_part_detail.dart';
import 'package:partrelate_desktop/page/vehicle_part_create_.dart';
import 'package:partrelate_desktop/widget/vehicle_detail_card.dart';
import 'package:partrelate_desktop/widget/vehicle_part_list.dart';

class VehicleDetailPage extends StatefulWidget {
  const VehicleDetailPage({super.key, required this.vehicleId});

  final int vehicleId;

  @override
  State<VehicleDetailPage> createState() => _VehicleDetailPageState();
}

class _VehicleDetailPageState extends State<VehicleDetailPage> {
  final vehiclePartsSearchController = TextEditingController();
  late Future<VehicleDetail> _vehicleDetail;
  List<VehiclePartDetail> filteredVehicleParts = [];

  Future<VehicleDetail> fetchVehicleDetail(int id) async {
    var response = await dio.get('/vehicles/${widget.vehicleId}');
    var vehicle = VehicleDetail.fromJson(response.data);

    return vehicle;
  }

  void refreshVehicle() {
    setState(() {
      _vehicleDetail = fetchVehicleDetail(widget.vehicleId);
    });
  }

  @override
  void initState() {
    _vehicleDetail = fetchVehicleDetail(widget.vehicleId);
    super.initState();
  }

  @override
  void dispose() {
    vehiclePartsSearchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<VehicleDetail>(
        future: _vehicleDetail,
        builder: (BuildContext context, AsyncSnapshot<VehicleDetail> snapshot) {
          if (snapshot.hasData) {
            VehicleDetail vehicle = snapshot.data!;

            return Center(
                child: Padding(
                    padding: const EdgeInsets.only(
                        top: 150, left: 27, right: 27, bottom: 150),
                    child: SizedBox(
                      width: 800,
                      child: Column(
                        children: [
                          VehicleDetailCard(
                              name: vehicle.name,
                              description: vehicle.description,
                              note: vehicle.note),
                          const SizedBox(
                            height: 15,
                          ),
                          Center(
                              child: SizedBox(
                                  width: 500,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Card(
                                          child: Padding(
                                            padding: const EdgeInsets.all(15),
                                            child: TextField(
                                              decoration: const InputDecoration(
                                                  hintText: 'Search...'),
                                              controller:
                                                  vehiclePartsSearchController,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 15,
                                      ),
                                      ElevatedButton(
                                          onPressed: () async {
                                            bool created = await Navigator.of(
                                                    context)
                                                .push(MaterialPageRoute(
                                                    builder: (context) =>
                                                        VehiclePartCreatePage(
                                                            vehicleId: widget
                                                                .vehicleId,
                                                            vehicleParts: vehicle
                                                                .vehicleParts)));

                                            if (created) {
                                              setState(() {
                                                _vehicleDetail =
                                                    fetchVehicleDetail(
                                                        widget.vehicleId);
                                              });
                                            }
                                          },
                                          child: const Icon(Icons.add))
                                    ],
                                  ))),
                          VehiclePartList(
                            vehicleParts: vehicle.vehicleParts,
                            onRefresh: refreshVehicle,
                          ),
                        ],
                      ),
                    )));
          }

          if (snapshot.hasError) {
            return Center(
              child: ElevatedButton(
                  onPressed: refreshVehicle, child: const Icon(Icons.refresh)),
            );
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}
