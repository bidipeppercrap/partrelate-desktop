import 'package:dio/dio.dart';

final dio = Dio();

void configureDio() {
  dio.options.baseUrl = 'https://api.partrelate.bidipeppercrap.com';
}

void authorizeDio(String token) {
  dio.options.headers = {'Authorization': 'Bearer $token'};
}
