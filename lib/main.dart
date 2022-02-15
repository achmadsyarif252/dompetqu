import 'package:dompet_q/pages/Ide_apps.dart';
import 'package:dompet_q/pages/add_progress.dart';
import 'package:dompet_q/pages/add_whistlist.dart';
import 'package:dompet_q/pages/detail_expenditure.dart';
import 'package:dompet_q/pages/habit_maker.dart';
import 'package:dompet_q/pages/home_page.dart';
import 'package:dompet_q/pages/whistlist_page.dart';
import 'package:dompet_q/provider/habit_prodivder.dart';
import 'package:dompet_q/provider/ide_apps_provider.dart';
import 'package:dompet_q/provider/transaction_provider.dart';
import 'package:dompet_q/provider/whistlist_provider.dart';
import 'package:dompet_q/widgets/detail_apps.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ),
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<TransactionProvider>(
          create: (context) => TransactionProvider(),
        ),
        ChangeNotifierProvider<WhistListProvider>(
          create: (context) => WhistListProvider(),
        ),
        ChangeNotifierProvider<HabbitProvider>(
          create: (context) => HabbitProvider(),
        ),
        ChangeNotifierProvider<IdeAppsProvider>(
          create: (context) => IdeAppsProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Dompet Qu',
        home: MainPage(),
        routes: {
          DetailExpenditure.routeName: (context) => DetailExpenditure(),
          AddWhistList.routeName: (context) => AddWhistList(),
          AddProgress.routeName: (context) => AddProgress(),
        },
      ),
    ),
  );
}

class MainPage extends StatefulWidget {
  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List<Widget> _pages = [
    HomePage(),
    WhistListThing(),
    HabitMaker(),
    IdeApps(),
  ];
  int _selectedPageIndex = 0;

  void selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  bottomNav() {
    return BottomNavigationBar(
      currentIndex: _selectedPageIndex,
      onTap: selectPage,
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.black,
      items: [
        BottomNavigationBarItem(
          icon: Icon(
            Icons.home,
          ),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.document_scanner_outlined,
          ),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.grading_outlined,
          ),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.android_rounded,
          ),
          label: '',
        ),

        // BottomNavigationBarItem(
        //   icon: Icon(
        //     Icons.android_rounded,
        //   ),
        //   label: '',
        // ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedPageIndex],
      bottomNavigationBar: bottomNav(),
    );
  }
}
