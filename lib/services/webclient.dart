import 'package:http_interceptor/http/intercepted_client.dart';
import 'http_interceptors.dart';
import 'package:http/http.dart' as http;

class WebClient {
  static const String url = 'http://192.168.0.97:3000/';

  http.Client client = InterceptedClient.build(
    interceptors: [HttpInterceptor()],
    requestTimeout: const Duration(
      seconds: 5,
    ),
  );
}
