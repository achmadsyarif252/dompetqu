import 'package:dompet_q/pages/Ide_apps.dart';
import 'package:dompet_q/pages/add_progress.dart';
import 'package:dompet_q/pages/add_whistlist.dart';
import 'package:dompet_q/pages/counter_page.dart';
import 'package:dompet_q/pages/detail_expenditure.dart';
import 'package:dompet_q/pages/edit_whistlist.dart';
import 'package:dompet_q/pages/habit_maker.dart';
import 'package:dompet_q/pages/home_page.dart';
import 'package:dompet_q/pages/kamus.dart';
import 'package:dompet_q/pages/mypoint.dart';
import 'package:dompet_q/pages/reward_maker.dart';
import 'package:dompet_q/pages/whistlist_page.dart';
import 'package:dompet_q/provider/counter_provider.dart';
import 'package:dompet_q/provider/habit_prodivder.dart';
import 'package:dompet_q/provider/ide_apps_provider.dart';
import 'package:dompet_q/provider/kamus_provider.dart';
import 'package:dompet_q/provider/point_provider.dart';
import 'package:dompet_q/provider/reward_provider.dart';
import 'package:dompet_q/provider/transaction_provider.dart';
import 'package:dompet_q/provider/whistlist_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../api/LocalNotifyManager.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:workmanager/workmanager.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ),
  );
  WidgetsFlutterBinding.ensureInitialized();
  Workmanager().initialize(

      // The top level function, aka callbackDispatcher
      callbackDispatcher,

      // If enabled it will post a notification whenever
      // the task is running. Handy for debugging tasks
      isInDebugMode: true);
  // Periodic task registration
  Workmanager().registerPeriodicTask(
    "2",

    //This is the value that will be
    // returned in the callbackDispatcher
    "simplePeriodicTask",

    // When no frequency is provided
    // the default 15 minutes is set.
    // Minimum frequency is 15 min.
    // Android will automatically change
    // your frequency to 15 min
    // if you have configured a lower frequency.
    frequency: Duration(minutes: 185),
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
        ChangeNotifierProvider<KamusProvider>(
          create: (context) => KamusProvider(),
        ),
        ChangeNotifierProvider<PointProvider>(
          create: (context) => PointProvider(),
        ),
        ChangeNotifierProvider<RewardProvider>(
          create: (context) => RewardProvider(),
        ),
        ChangeNotifierProvider<CounterProvider>(
          create: (context) => CounterProvider(),
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
          EditWhistList.routeName: (context) => EditWhistList(),
          KamusScreen.routeName: (context) => KamusScreen(),
          RewardMaker.routeName: (context) => RewardMaker(),
          MyPoin.routeName: (context) => MyPoin(),
          CounterPage.routeName: (context) => CounterPage(),
        },
      ),
    ),
  );
}

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) {
    // initialise the plugin of flutterlocalnotifications.
    FlutterLocalNotificationsPlugin flip =
        new FlutterLocalNotificationsPlugin();

    // app_icon needs to be a added as a drawable
    // resource to the Android head project.
    var android = new AndroidInitializationSettings('@mipmap/ic_launcher');
    var IOS = new IOSInitializationSettings();

    // initialise settings for both Android and iOS device.
    var settings = new InitializationSettings(android: android, iOS: IOS);
    flip.initialize(settings);
    localNotifyManager.showNotification();
    return Future.value(true);
  });
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
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    Provider.of<PointProvider>(context, listen: false).fetchAndSetPoint();
  }

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
