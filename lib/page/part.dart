import 'package:flutter/material.dart';
import 'package:partrelate_desktop/http/client.dart';
import 'package:partrelate_desktop/model/paginated_respose.dart';
import 'package:partrelate_desktop/model/part.dart';
import 'package:partrelate_desktop/page/part_create.dart';
import 'package:partrelate_desktop/widget/pagination.dart';
import 'package:partrelate_desktop/widget/part_list.dart';
import 'package:partrelate_desktop/widget/searchbar_debounced.dart';

class PartPage extends StatefulWidget {
  const PartPage({super.key});

  @override
  State<PartPage> createState() => _PartPageState();
}

class _PartPageState extends State<PartPage> {
  String searchText = '';
  int currentPage = 1;
  late Future<PaginatedResponse> partFuture;

  Future<PaginatedResponse> fetchPart(
      [String keyword = '', int page = 1]) async {
    var response = await dio
        .get('/parts', queryParameters: {'page': page, 'keyword': keyword});

    return PaginatedResponse.fromJson(response.data);
  }

  void onSearch(String text) {
    setState(() {
      currentPage = 1;
      partFuture = fetchPart(text);
    });
  }

  void refreshPage() {
    setState(() {
      partFuture = fetchPart(searchText, currentPage);
    });
  }

  @override
  void initState() {
    super.initState();
    partFuture = fetchPart(searchText);
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
                                builder: (context) => const PartCreatePage()));

                        if (success) refreshPage();
                      },
                      child: const Icon(Icons.add))
                ],
              ),
              FutureBuilder<PaginatedResponse>(
                  future: partFuture,
                  builder: (BuildContext context,
                      AsyncSnapshot<PaginatedResponse> snapshot) {
                    if (snapshot.hasData) {
                      List<Part> parts = [];
                      final totalPages = snapshot.data!.totalPages;

                      for (var part in snapshot.data!.data) {
                        parts.add(Part.fromJsonList(part));
                      }

                      return Column(children: [
                        const SizedBox(
                          height: 15,
                        ),
                        PartList(
                          parts: parts,
                          onRefresh: refreshPage,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Pagination(
                          onMovePage: (step) {
                            setState(() {
                              currentPage = currentPage + step;
                              partFuture = fetchPart(searchText, currentPage);
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
                              onPressed: refreshPage,
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
