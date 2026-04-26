import '../../core/network/api_client.dart';
import '../../core/constants/api_constants.dart';
import '../models/discoteca_model.dart';

class DiscotecaRepository {
  final ApiClient apiClient;

  DiscotecaRepository({required this.apiClient});

  Future<List<Discoteca>> obtenerDiscotecasActivas() async {
    try {
      final respuesta = await apiClient.dio.get(
        '${ApiConstants.discotecasPath}/activas',
      );

      if (respuesta.statusCode == 200) {
        final List<dynamic> listaJson = respuesta.data['data'];

        return listaJson.map((item) => Discoteca.desdeJson(item)).toList();
      } else {
        throw Exception('Error al obtener discotecas del servidor');
      }
    } catch (e) {
      throw Exception('Error de conexión al listar discotecas: $e');
    }
  }
}
