import 'package:dio/dio.dart';

class FactService {
  final Dio _dio = Dio();

  Future<String> fetchFact({
    required String type,
    String? number,
    bool isRandom = false,
  }) async {
    try {
      final url = isRandom
          ? 'http://numbersapi.com/random/$type'
          : type == 'date' && number != null && number.contains('/')
          ? 'http://numbersapi.com/${number.replaceAll('/', '/')}/date'
          : 'http://numbersapi.com/${number ?? ''}/$type';

      final response = await _dio.get(url);
      return response.data.toString();
    } on DioException catch (_) {
      throw 'Serverga ulanib bo‘lmadi. Iltimos, internet aloqasini tekshiring.';
    } catch (_) {
      throw 'Nomaʼlum xatolik yuz berdi. Keyinroq urinib ko‘ring.';
    }
  }
}
