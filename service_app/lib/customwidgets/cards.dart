import 'package:flutter/material.dart';
import 'package:service_app/core/auth_services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class WorkerCard extends StatelessWidget {
  final String nombres;
  final String description;
  final String trabajo;
  final String categoria;
  final VoidCallback onAccept;
  final VoidCallback onReject;

  const WorkerCard({
    required this.nombres,
    required this.description,
    required this.trabajo,
    required this.categoria,
    required this.onAccept,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: Container(
              width: 80,
              height: 80,
              color:  Color.fromRGBO(63, 156, 255, 1),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  nombres,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  trabajo,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color.fromRGBO(61, 38, 12, 1),
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  categoria,
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Column(
            children: [
              ElevatedButton(
                onPressed: onAccept,
                child: Text('Aceptar'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.green, // Color verde
                ), 
              ),
              ElevatedButton(
                onPressed: onReject,
                child: Text('Rechazar'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.red, // Color verde
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class WorkerCardList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: AuthService().infoTrabajador(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final workers = snapshot.data!;
          return ListView.builder(
            itemCount: workers.length,
            itemBuilder: (context, index) {
              final worker = workers[index];
              return WorkerCard(
                nombres: worker['nombres'] != null
                    ? worker['nombres'] as String
                    : '',
                description: worker['descripcion'] != null
                    ? worker['descripcion'] as String
                    : '',
                trabajo: worker['trabajo'] != null
                    ? worker['trabajo'] as String
                    : '',
                categoria: worker['categoria'] != null
                    ? worker['categoria'] as String
                    : '', onAccept: () {  }, onReject: () {  },
              );
            },
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
