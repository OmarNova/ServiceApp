import 'package:flutter/material.dart';
//import 'package:intl/intl.dart';

class SolicitudScreen extends StatefulWidget {
  const SolicitudScreen({Key? key}) : super(key: key);

  @override
  _SolicitudScreenState createState() => _SolicitudScreenState();
}

class _SolicitudScreenState extends State<SolicitudScreen> {
  final _formKey = GlobalKey<FormState>();
  final _tipoServicioController = TextEditingController();
  final _descripcionController = TextEditingController();
  final _dateController = TextEditingController();
  DateTime? _fechaSeleccionada;

  bool _isSendingEnabled = false;

  List<String> _servicios = [
    'Trabajador',
    'Plomero',
    'Empleada',
    'Técnico',
  ];

  @override
  void initState() {
    super.initState();
    _tipoServicioController.text = _servicios.first;
  }

  void _onTipoServicioChanged(String? value) {
    setState(() {
      _tipoServicioController.text = value!;
    });
  }

  void _onDescripcionChanged(String value) {
    setState(() {
      _isSendingEnabled = value.isNotEmpty && _fechaSeleccionada != null;
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    FocusScope.of(context).requestFocus(FocusNode()); // Agregar esta línea
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _fechaSeleccionada = picked;
        _isSendingEnabled = _descripcionController.text.isNotEmpty;
      });
    }
  }

  void _enviarSolicitud() {
    if (_formKey.currentState!.validate()) {
      // Aquí podrías enviar la solicitud al servidor
      // y mostrar un mensaje de éxito al usuario
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Solicitud enviada con éxito')),
      );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nueva Solicitud'),
        backgroundColor: Color.fromRGBO(255, 153, 0, 1),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DropdownButtonFormField<String>(
                value: _tipoServicioController.text,
                decoration: InputDecoration(
                  labelText: 'Tipo de Servicio',
                ),
                items: _servicios.map((servicio) {
                  return DropdownMenuItem<String>(
                    value: servicio,
                    child: Text(servicio),
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
                  hintText: 'Descripción del Servicio',
                ),
                onChanged: _onDescripcionChanged,
                maxLines: 4,
              ),
              SizedBox(height: 16),
              InkWell(
                onTap: () {
                  _selectDate(context);
                },
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: 'Fecha de la Solicitud',
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _fechaSeleccionada != null
                            ? '${_fechaSeleccionada!.day}/${_fechaSeleccionada!.month}/${_fechaSeleccionada!.year}'
                            : 'Seleccionar Fecha',
                      ),
                      Icon(Icons.calendar_today),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 24),

              // Botón para enviar la solicitud
              ElevatedButton(
                onPressed: _isSendingEnabled ? _enviarSolicitud : null,
                child: const Text('Enviar solicitud'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
