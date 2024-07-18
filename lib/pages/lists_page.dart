import 'package:aqua_terra_manager/locator.dart';
import 'package:aqua_terra_manager/services/lists_navigator_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../views/animal_detail_view.dart';
import '../views/animal_list_view.dart';
import '../views/student_detail_view.dart';
import '../views/student_list_view.dart';
import '../views/vivarium_detail_view.dart';
import '../views/vivarium_list_view.dart';
import 'main_page.dart';

class ListsPage extends StatefulWidget {
  const ListsPage({super.key});

  @override
  State<ListsPage> createState() => _ListsPageState();
}

class _ListsPageState extends State<ListsPage> {
  final _prefs = locator<SharedPreferences>();
  final _listsNavigatorService = locator<ListsNavigatorService>();

  late int _selectedIndex;
  late String _appBarTitle;

  @override
  void initState() {
    super.initState();
    _selectedIndex = _prefs.getInt('initialListsPageIndex') ?? 0;
    _listsNavigatorService.pageController =
        PageController(initialPage: _selectedIndex);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_prefs.getBool('scanResult') == true) {
        _prefs.setBool('scanResult', false);
        _listsNavigatorService.studentNavigatorKey.currentState
            ?.pushNamed('/details'); // go to detail view of scanned student
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _setAppBarTitle(_selectedIndex);

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        switch (_selectedIndex) {
          case 0:
            if (_listsNavigatorService.studentNavigatorKey.currentState
                    ?.canPop() ??
                false) {
              _listsNavigatorService.studentNavigatorKey.currentState?.pop();
            } else {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const MainPage(),
                ),
              );
            }
            break;
          case 1:
            if (_listsNavigatorService.animalNavigatorKey.currentState
                    ?.canPop() ??
                false) {
              _listsNavigatorService.animalNavigatorKey.currentState?.pop();
            } else {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const MainPage(),
                ),
              );
            }
            break;
          case 2:
            if (_listsNavigatorService.vivariumNavigatorKey.currentState
                    ?.canPop() ??
                false) {
              _listsNavigatorService.vivariumNavigatorKey.currentState?.pop();
            } else {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const MainPage(),
                ),
              );
            }
            break;
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(_appBarTitle),
        ),
        body: PageView(
          controller: _listsNavigatorService.pageController,
          physics: const NeverScrollableScrollPhysics(),
          onPageChanged: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          children: [
            Navigator(
              key: _listsNavigatorService.studentNavigatorKey,
              initialRoute: '/',
              onGenerateRoute: (settings) {
                WidgetBuilder builder;
                switch (settings.name) {
                  case '/':
                    builder = (context) => StudentListView();
                    break;
                  case '/details':
                    builder = (context) => const StudentDetailView();
                    break;
                  default:
                    throw ErrorWidget(Exception('Invalid route'));
                }
                return MaterialPageRoute(builder: builder, settings: settings);
              },
            ),
            Navigator(
              key: _listsNavigatorService.animalNavigatorKey,
              initialRoute: '/',
              onGenerateRoute: (settings) {
                WidgetBuilder builder;
                switch (settings.name) {
                  case '/':
                    builder = (context) => AnimalListView();
                    break;
                  case '/details':
                    builder = (context) => AnimalDetailView();
                    break;
                  default:
                    throw ErrorWidget(Exception('Invalid route'));
                }
                return MaterialPageRoute(builder: builder, settings: settings);
              },
            ),
            Navigator(
              key: _listsNavigatorService.vivariumNavigatorKey,
              initialRoute: '/',
              onGenerateRoute: (settings) {
                WidgetBuilder builder;
                switch (settings.name) {
                  case '/':
                    builder = (context) => VivariumListView();
                    break;
                  case '/details':
                    builder = (context) => VivariumDetailView();
                    break;
                  default:
                    throw ErrorWidget(Exception('Invalid route'));
                }
                return MaterialPageRoute(builder: builder, settings: settings);
              },
            ),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
            _listsNavigatorService.pageController.jumpToPage(index);
          },
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.groups_rounded),
              label: 'Mitglieder',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.pets_rounded),
              label: 'Tiere',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.water_rounded),
              label: 'Vivaria',
            ),
          ],
        ),
      ),
    );
  }

  void _setAppBarTitle(int index) {
    switch (index) {
      case 0:
        _appBarTitle = 'Mitglieder';
        break;
      case 1:
        _appBarTitle = 'Tiere';
        break;
      case 2:
        _appBarTitle = 'Vivaria';
        break;
      default:
        _appBarTitle = '';
        break;
    }
  }
}
