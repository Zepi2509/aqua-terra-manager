import 'package:aqua_terra_manager/views/vivarium_edit_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../locator.dart';
import '../models/vivarium.dart';
import '../services/database/vivarium_service.dart';

//------------------------
// List with all vivaria
//------------------------
class VivariumListView extends StatelessWidget {
  VivariumListView({super.key});

  final _prefs = locator<SharedPreferences>();
  final _vivariumService = locator<VivariumService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
          stream: _vivariumService.vivariaQuery.snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            List<Vivarium> vivaria = snapshot.data!.docs
                .map((doc) => Vivarium.fromJson(
                    (doc.data() as Map<String, dynamic>)..['id'] = doc.id))
                .toList();
            return ListView(children: _listTiles(context, vivaria));
          }),
      floatingActionButton: FloatingActionButton.large(
          onPressed: () {
            _prefs.setString('vivariumToEdit', '');
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const VivariumEditView(),
              ),
            );
          },
          child: const Icon(Icons.add_rounded)),
    );
  }

  _listTiles(BuildContext context, List<Vivarium> vivaria) {
    return vivaria
        .map((v) => ListTile(
            title: Text(
              v.name,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 20,
              ),
            ),
            subtitle: (v.height != null && v.width != null && v.depth != null)
                ? Text("${v.height} x ${v.width} x ${v.depth}")
                : const Text(""),
            trailing: (v.tempMin != null && v.tempMax != null)
                ? Text("${v.tempMin}-${v.tempMax}°C")
                : const Text(""),
            leading: const Icon(Icons.waves_rounded)
            //v.type == "Aquarium" ? Icons.waves_rounded : Icons.sunny)), // TODO more meaningful icon?
            ,
            onTap: () {
              _prefs.setString('vivariumId', v.name);
              Navigator.pushNamed(context, '/details');
            }))
        .toList();
  }
}
