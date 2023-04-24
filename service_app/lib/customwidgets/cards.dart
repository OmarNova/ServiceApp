import 'package:flutter/material.dart';
import 'package:service_app/core/auth_services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class WorkerCard extends StatelessWidget {
  //final String imageUrl;
  final String nombres;
  final String description;
  final String trabajo;
  final String categoria;

  const WorkerCard({
    // required this.imageUrl,
    required this.nombres,
    required this.description,
    required this.trabajo,
    required this.categoria,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
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
            //   child: Image.network(
            //     imageUrl,
            //     width: 80,
            //     height: 80,
            //     fit: BoxFit.cover,
            //  ),
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
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
              ],
            ),
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
//                imageUrl: worker['imageUrl'] != null
//                    ? worker['imageUrl'] as String
//                    : '',
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
                    : '',
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
