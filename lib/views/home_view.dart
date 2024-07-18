import 'package:aqua_terra_manager/locator.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';

//---------------------------------------------------------
// Overview with three tiles: Students, animals, vivaria
//--------------------------------------------------------
class HomeView extends StatelessWidget {
  final _prefs = locator<SharedPreferences>();

  HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(SizeConstants.s500),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              _prefs.setInt('initialListsPageIndex', 0);
              Navigator.pushNamed(context, '/lists');
            },
            child: SizedBox(
              width: double.infinity,
              child: Card(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: SizeConstants.s500),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.groups_rounded,
                        size: SizeConstants.s700,
                      ),
                      Text('Mitglieder',
                          style: Theme.of(context).textTheme.headlineSmall),
                    ],
                  ),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              _prefs.setInt('initialListsPageIndex', 1);
              Navigator.pushNamed(context, '/lists');
            },
            child: SizedBox(
              width: double.infinity,
              child: Card(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: SizeConstants.s500),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.pets_rounded,
                        size: SizeConstants.s700,
                      ),
                      Text('Tiere',
                          style: Theme.of(context).textTheme.headlineSmall),
                    ],
                  ),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              _prefs.setInt('initialListsPageIndex', 2);
              Navigator.pushNamed(context, '/lists');
            },
            child: SizedBox(
              width: double.infinity,
              child: Card(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: SizeConstants.s500),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.water_rounded,
                        size: SizeConstants.s700,
                      ),
                      Text('Vivaria',
                          style: Theme.of(context).textTheme.headlineSmall),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
