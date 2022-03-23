import 'package:dompet_q/pages/add_whistlist.dart';
import 'package:dompet_q/provider/whistlist_provider.dart';
import 'package:dompet_q/widgets/card_item.dart';
import 'package:dompet_q/widgets/complete_card_item.dart';
import 'package:dompet_q/widgets/empty_whistlist.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../widgets/drawer.dart';

class WhistListThing extends StatefulWidget {
  @override
  _WhistListThingState createState() => _WhistListThingState();
}

class _WhistListThingState extends State<WhistListThing>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  final GlobalKey<ScaffoldState> _key = GlobalKey(); // Create a key

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final WhistListProvider whistListProvider =
        Provider.of<WhistListProvider>(context);

    //emptyWhistList

    return SafeArea(
      key: _key,
      child: Scaffold(
        drawerEnableOpenDragGesture: false,
        drawer: MainDrawer(),
        floatingActionButton: _tabController!.index == 1
            ? SizedBox()
            : FloatingActionButton(
                onPressed: () {
                  Navigator.of(context)
                      .pushNamed(AddWhistList.routeName)
                      .then((value) {
                    if (value == 1) {
                      return Scaffold.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: Colors.green,
                          content: Text(
                            'Berhasil Tambah WhistList',
                          ),
                        ),
                      );
                    }
                  });
                },
                child: Icon(
                  Icons.add,
                ),
              ),
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              _key.currentState!.openDrawer();
            },
            icon: Icon(
              Icons.wysiwyg,
              size: 28.0,
            ),
            color: Colors.black,
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          centerTitle: true,
          title: Text(
            'WhistList Qu',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          actions: [
            IconButton(
              color: Colors.grey,
              onPressed: () {},
              icon: Icon(
                Icons.notifications_active_sharp,
                size: 30.0,
              ),
            ),
          ],
        ),
        body: Container(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              // give the tab bar a height [can change hheight to preferred height]
              Container(
                height: 45,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(
                    8.0,
                  ),
                ),
                child: TabBar(
                  controller: _tabController,
                  // give the indicator a decoration (color and border radius)
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      8.0,
                    ),
                    color: Colors.blue,
                  ),
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.black,
                  tabs: [
                    // first tab [you can add an icon using the icon property]
                    Tab(
                      text: 'Rencana',
                      // child: Text('Hallo Dunia'),
                    ),

                    // second tab [you can add an icon using the icon property]
                    Tab(
                      text: 'Selesai',
                    ),
                  ],
                ),
              ),
              // tab bar view here
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 20.0,
                  ),
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      // first tab bar view widget
                      ListViewBuilder2(),
                      CompleteWhistList()
                    ],
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

class ListViewBuilder2 extends StatefulWidget {
  @override
  State<ListViewBuilder2> createState() => _ListViewBuilder2State();
}

class _ListViewBuilder2State extends State<ListViewBuilder2>
    with AutomaticKeepAliveClientMixin<ListViewBuilder2> {
  @override
  bool get wantKeepAlive => false;

  @override
  Widget build(BuildContext context) {
    final WhistListProvider whistListProvider =
        Provider.of<WhistListProvider>(context);
    return FutureBuilder(
        future: whistListProvider.fetchAndSetWhistListUnCheck(),
        builder: (context, snapshot) {
          return Consumer<WhistListProvider>(
              child: EmptyWhistList('empty.jpg'),
              builder: (context, whistList, ch) {
                return whistList.whistList.length == 0
                    ? EmptyWhistList('empty.jpg')
                    : ListView.builder(
                        itemBuilder: (ctx, i) => Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 2,
                          ),
                          child: CardItem(
                            id: whistList.whistList[i].id,
                            nama: whistList.whistList[i].nama,
                            tanggal: whistList.whistList[i].tanggal,
                            total: whistList.whistList[i].total,
                            curentDana: whistList.whistList[i].currentDana,
                          ),
                        ),
                        itemCount: whistList.whistList.length,
                      );
              });
        });
  }
}

class CompleteWhistList extends StatefulWidget {
  @override
  _CompleteWhistListState createState() => _CompleteWhistListState();
}

class _CompleteWhistListState extends State<CompleteWhistList>
    with AutomaticKeepAliveClientMixin<CompleteWhistList> {
  @override
  bool get wantKeepAlive => false;
  @override
  Widget build(BuildContext context) {
    final WhistListProvider whistListProvider =
        Provider.of<WhistListProvider>(context);
    return FutureBuilder(
      future: whistListProvider.fetchAndSetWhistListCheck(),
      builder: (context, snapshot) {
        return Consumer<WhistListProvider>(
          child: EmptyWhistList('noitem.png'),
          builder: (context, whistList, ch) {
            return whistList.whistList.length == 0
                ? EmptyWhistList('noitem.png')
                : ListView.builder(
                    itemBuilder: (ctx, i) => Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 2,
                      ),
                      child: CompleteCardItem(
                        id: whistList.whistList[i].id,
                        nama: whistList.whistList[i].nama,
                        tanggal: whistList.whistList[i].tanggal,
                        total: whistList.whistList[i].total,
                        curentDana: whistList.whistList[i].currentDana,
                      ),
                    ),
                    itemCount: whistList.whistList.length,
                  );
          },
        );
      },
    );
  }
}
