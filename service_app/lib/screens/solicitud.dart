import 'package:flutter/material.dart';

import '../core/auth_services.dart';

//import 'package:intl/intl.dart';

class SolicitudScreen extends StatefulWidget {
  const SolicitudScreen({Key? key}) : super(key: key);

  @override
  _SolicitudScreenState createState() => _SolicitudScreenState();
}

class _SolicitudScreenState extends State<SolicitudScreen> {
  final _formKey = GlobalKey<FormState>();
  final _tituloController = TextEditingController();
  final _tipoServicioController = TextEditingController();
  final _descripcionController = TextEditingController();
  final _direccionController = TextEditingController();
  final AuthService _authService = AuthService();
  List<String> _categorias = [];
  bool _isSendingEnabled = false;

  List<String> _servicios = [
    'Plomería',
    'Técnico',
  ];

  @override
  void initState() {
    super.initState();
    _getCategorias();
  }

  Future<void> _getCategorias() async {
    try {
      List<String> categorias = await AuthService().getCategorias();
      setState(() {
        _categorias = categorias;
        if (_categorias.isNotEmpty) {
          _tipoServicioController.text = _categorias[0];
        }
      });
    } catch (e) {
      print('Error fetching categories: $e');
    }
  }

  void _onTipoServicioChanged(String? value) {
    setState(() {
      _tipoServicioController.text = value!;
      _isSendingEnabled = _tituloController.text.isNotEmpty &&
          _descripcionController.text.isNotEmpty;
    });
  }

  void _onTituloChanged(String value) {
    _tituloController.text = value; // Actualiza el controlador
    setState(() {
      _isSendingEnabled = _tituloController.text.isNotEmpty &&
          _descripcionController.text.isNotEmpty;
    });
  }

  void _onDireccionChanged(String value) {
    setState(() {
      _isSendingEnabled = _tituloController.text.isNotEmpty &&
          _descripcionController.text.isNotEmpty &&
          _direccionController
              .text.isNotEmpty; // Actualiza la variable `_isSendingEnabled`
    });
  }

  void _onDescripcionChanged(String value) {
    setState(() {
      _isSendingEnabled = _tituloController.text.isNotEmpty && value.isNotEmpty;
    });
  }

  void _enviarSolicitud() async {
    if (_formKey.currentState!.validate()) {
      //Print

      print('Datos de la solicitud:');
      print('Título: ${_tituloController.text}');
      print('Tipo de servicio: ${_tipoServicioController.text}');
      print('Descripción: ${_descripcionController.text}');
      print('Dirección: ${_direccionController.text}');

      final Map<String, dynamic> data = {
        'titulo': _tituloController.text,
        'categoria': _tipoServicioController.text,
        'descripcion': _descripcionController.text,
        'direccion': _direccionController.text,
      };
      try {
        final response = await _authService.enviarSolicitud(data);
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Solicitud enviada con éxito'),
              actions: <Widget>[
                TextButton(
                  child: Text('Aceptar'),
                  style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all<Color>(
                        Color.fromRGBO(61, 38, 12, 1)),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      } catch (e) {
        print(e);
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error al enviar la solicitud'),
              content: Text('Por favor intenta de nuevo más tarde'),
              actions: <Widget>[
                TextButton(
                  child: Text('Aceptar'),
                  style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all<Color>(
                        Color.fromRGBO(61, 38, 12, 1)),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Nuevo color de fondo
      appBar: AppBar(
        title: Text('Nueva Solicitud'),
        backgroundColor: Color.fromRGBO(61, 38, 12, 1),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _tituloController,
                textAlignVertical: TextAlignVertical.center,
                decoration: InputDecoration(
                  labelText: 'Titulo de la solicitud',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa un titulo';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _tipoServicioController.text,
                decoration: InputDecoration(
                  labelText: 'Tipo de Servicio',
                ),
                items: _categorias.map((categoria) {
                  return DropdownMenuItem<String>(
                    value: categoria,
                    child: Text(categoria),
                  );
                }).toList(),
                onChanged: _onTipoServicioChanged,
                // Agregamos esta propiedad para asegurarnos de que el menú
                // siempre se abra hacia abajo
                dropdownColor: Colors.white,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _descripcionController,
                decoration: InputDecoration(
                  labelText: 'Descripción del servicio',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa una descripción';
                  }
                  return null;
                },
                onChanged: _onDescripcionChanged,
                maxLines: 4,
              ),
              SizedBox(height: 24),
              TextFormField(
                controller: _direccionController,
                decoration: InputDecoration(
                  labelText: 'Dirección',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa una dirección';
                  }
                  return null;
                },
              ),
              // Botón para enviar la solicitud
              ElevatedButton(
                onPressed: _isSendingEnabled ? _enviarSolicitud : null,
                child: Text('Enviar solicitud'),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                    Color.fromRGBO(61, 38, 12, 1),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
