import 'package:flutter/material.dart';
import 'package:service_app/core/auth_services.dart';

class SolicitudesScreen extends StatefulWidget {
  @override
  _SolicitudesScreenState createState() => _SolicitudesScreenState();
}

class _SolicitudesScreenState extends State<SolicitudesScreen> {
  AuthService _authService = AuthService();
  List<Map<String, dynamic>> _solicitudes = [];

  @override
  void initState() {
    super.initState();
    _fetchSolicitudes().then((value) {});
  }

  Future<void> _fetchSolicitudes() async {
    try {
      final solicitudes = await _authService.getSolicitudes();
      print(solicitudes); // Agrega esta línea para verificar los datos
      setState(() {
        _solicitudes = solicitudes;
      });
    } catch (e) {
      print('Error fetching solicitudes: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Solicitudes'),
      ),
      body: ListView.builder(
        itemCount: _solicitudes.length,
        itemBuilder: (context, index) {
          final solicitud = _solicitudes[index];
          return Card(
            child: ListTile(
              title: Text(solicitud['titulo']),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Descripción: ${solicitud['descripcion']}'),
                  Text('Dirección: ${solicitud['direccion']}'),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
