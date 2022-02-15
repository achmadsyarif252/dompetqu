import 'package:dompet_q/pages/add_progress.dart';
import 'package:dompet_q/provider/ide_apps_provider.dart';
import 'package:dompet_q/widgets/detail_apps.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class IdeApps extends StatelessWidget {
  List<Color> _availableColor = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.indigo,
    Colors.pink,
    Colors.amber,
    Colors.orange,
  ];

  List<IconData> _availableIcon = [
    Icons.ac_unit,
    Icons.add_moderator,
    Icons.clean_hands,
    Icons.yard,
    Icons.waves,
    Icons.safety_divider,
    Icons.face,
    Icons.read_more,
    Icons.opacity,
    Icons.holiday_village,
    Icons.e_mobiledata,
    Icons.celebration,
    Icons.leak_remove,
    Icons.ac_unit_outlined,
  ];

  final TextEditingController namaController = TextEditingController();
  final TextEditingController detailController = TextEditingController();
  final GlobalKey<FormState> state = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final IdeAppsProvider ideAppsProvider =
        Provider.of<IdeAppsProvider>(context);
    saveIde() {
      final isValidate = state.currentState!.validate();
      if (!isValidate) {
        return;
      }
      ideAppsProvider.addIde(namaController.text, detailController.text);
      namaController.text = "";
      detailController.text = "";
      Navigator.of(context).pop();
    }

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: Icon(
          Icons.clear_all,
          color: Colors.black,
          size: 25.0,
        ),
        centerTitle: true,
        title: Text(
          'Ide Aplikasi',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(
              right: 15.0,
            ),
            child: Icon(
              Icons.notifications_active,
              color: Colors.black,
              size: 25.0,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  content: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 230,
                    color: Colors.white,
                    child: Form(
                      key: state,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextFormField(
                            validator: (e) {
                              if (e!.isEmpty) {
                                return "isi nama aplikasinya..";
                              }
                              return null;
                            },
                            controller: namaController,
                            decoration: InputDecoration(
                              hintText: 'Nama Aplikasi',
                            ),
                            maxLines: null,
                          ),
                          TextFormField(
                            validator: (e) {
                              if (e!.isEmpty) {
                                return "isi detail aplikasinya..";
                              }
                              return null;
                            },
                            controller: detailController,
                            keyboardType: TextInputType.multiline,
                            minLines: 6,
                            decoration: InputDecoration(
                              hintText: 'Detail Aplikasinya gimana nih...',
                            ),
                            maxLines: null,
                          ),
                        ],
                      ),
                    ),
                  ),
                  actions: [
                    Row(
                      children: [
                        Container(
                          width: 120,
                          child: TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('batal'),
                            style: TextButton.styleFrom(
                              primary: Colors.grey[600],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            child: ElevatedButton(
                              onPressed: () {
                                saveIde();
                              },
                              child: Text('simpan ide'),
                              style: ElevatedButton.styleFrom(
                                primary: Colors.blue,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                );
              });
        },
        child: Icon(
          Icons.add,
        ),
      ),
      body: FutureBuilder(
        builder: (ctx, snapshot) {
          return Consumer<IdeAppsProvider>(
            child: Center(
              child: Image.asset('assets/noitem.png'),
            ),
            builder: (ctx, habbit, ch) {
              return ideAppsProvider.ideApps.length == 0
                  ? SingleChildScrollView(
                      child: Column(
                        children: [
                          Image.asset('assets/noitem.png'),
                          Text(
                            'Ayo Buat Ide Ide Cemerlang',
                            style: TextStyle(
                              fontSize: 20.0,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20.0,
                      ),
                      itemBuilder: (ctx, i) {
                        int idI = ideAppsProvider.ideApps[i].isDone;
                        return Dismissible(
                          direction: DismissDirection.endToStart,
                          background: Container(
                            padding: const EdgeInsets.only(right: 10.0),
                            color: Colors.red,
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Icon(
                                Icons.delete,
                                size: 25.0,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          key: ValueKey(i),
                          confirmDismiss: (DismissDirection direction) {
                            return showDialog(
                                context: context,
                                builder: (_) {
                                  return AlertDialog(
                                    title: Text(
                                        'Hapus ${ideAppsProvider.ideApps[i].nama}'),
                                    content: Text('Anda Yakin?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text('Batal'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          ideAppsProvider.delete(
                                              ideAppsProvider.ideApps[i].id);
                                          Navigator.of(context).pop();
                                        },
                                        child: Text('Ya'),
                                      ),
                                    ],
                                  );
                                });
                          },
                          child: Card(
                            color: idI == 1
                                ? Colors.white.withOpacity(0.8)
                                : Colors.white,
                            elevation: idI == 1 ? 0 : 10,
                            child: ListTile(
                              onTap: () {
                                int id = ideAppsProvider.ideApps[i].id;
                                showModalBottomSheet(
                                  context: context,
                                  backgroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(20),
                                    ),
                                  ),
                                  isScrollControlled: true,
                                  builder: (context) {
                                    return DetailApps(id);
                                  },
                                );
                              },
                              leading: Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: _availableColor[i % 7],
                                ),
                                child: Icon(
                                  _availableIcon[i % _availableIcon.length],
                                  color: Colors.white,
                                ),
                              ),
                              title: Text(
                                ideAppsProvider.ideApps[i].nama,
                                style: TextStyle(
                                  decoration:
                                      ideAppsProvider.ideApps[i].isDone == 1
                                          ? TextDecoration.lineThrough
                                          : TextDecoration.none,
                                ),
                              ),
                              subtitle: Text(
                                'Detail : ${ideAppsProvider.ideApps[i].detail}',
                                overflow: TextOverflow.ellipsis,
                                softWrap: true,
                                maxLines: 1,
                                style: TextStyle(
                                  decoration:
                                      ideAppsProvider.ideApps[i].isDone == 1
                                          ? TextDecoration.lineThrough
                                          : TextDecoration.none,
                                ),
                              ),
                              trailing: Checkbox(
                                value: ideAppsProvider.ideApps[i].isDone == 0
                                    ? false
                                    : true,
                                onChanged: (value) {
                                  ideAppsProvider.updateIde(
                                    ideAppsProvider.ideApps[i].id,
                                  );
                                },
                              ),
                            ),
                          ),
                        );
                      },
                      itemCount: ideAppsProvider.ideApps.length,
                    );
            },
          );
        },
        future: ideAppsProvider.fetchAndSetIdeApps(),
      ),
    );
  }
}
