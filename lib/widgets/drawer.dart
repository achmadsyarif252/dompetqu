import 'package:dompet_q/pages/counter_page.dart';
import 'package:flutter/material.dart';

import '../models/counter.dart';
import '../pages/kamus.dart';

class MainDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      width: MediaQuery.of(context).size.width * 0.9,
      child: Drawer(
        child: Column(
          children: [
            Container(
              height: 200,
              child: FlutterLogo(
                size: 150,
              ),
            ),
            Text('DompetQ 1.0'),
            SizedBox(
              height: 20,
            ),
            Divider(),
            ListTile(
              onTap: () {
                Navigator.of(context).pushNamed(KamusScreen.routeName);
              },
              leading: Icon(
                Icons.book,
                size: 30.0,
              ),
              title: Text(
                'KamusQu',
                style: TextStyle(
                  fontSize: 19.0,
                ),
              ),
            ),
            // Divider(),
            // ListTile(
            //   onTap: () {
            //     Navigator.of(context).pushNamed(CounterPage.routeName);
            //   },
            //   leading: Icon(
            //     Icons.mosque,
            //     size: 30.0,
            //   ),
            //   title: Text(
            //     'Tasbih',
            //     style: TextStyle(
            //       fontSize: 19.0,
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
