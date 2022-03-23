import 'package:dompet_q/provider/kamus_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/point_provider.dart';

class KamusScreen extends StatelessWidget {
  static const routeName = '/kamus-screen';
  final kataController = TextEditingController();
  final artiController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final KamusProvider kamusProvider = Provider.of<KamusProvider>(context);
    final PointProvider pointProvider = Provider.of<PointProvider>(context);
    showSnack(String pesan, Color color) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(pesan),
          backgroundColor: color,
        ),
      );
    }

    saveVocab() {
      if (kataController.text.isEmpty || artiController.text.isEmpty) {
        return;
      }
      kamusProvider.addKata(kataController.text, artiController.text);
      pointProvider.updatePoin(1, 0);
      kataController.clear();
      artiController.clear();
      showSnack("Vocab Berhasil Ditambahkan", Colors.green);
      Navigator.of(context).pop();
    }

    updateVocab(int id) {
      if (kataController.text.isEmpty || artiController.text.isEmpty) {
        return;
      }
      kamusProvider.updateKata(id, kataController.text, artiController.text);
      kataController.clear();
      artiController.clear();
      Navigator.of(context).pop();
      showSnack("Vocab Berhasil Diedit", Colors.blue);
    }

    showAddKata(int? id) {
      return showDialog(
          context: context,
          builder: (ctx) {
            return AlertDialog(
              scrollable: true,
              title: Row(
                children: [
                  Text('Add Vocab'),
                  Spacer(),
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
              content: Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  TextField(
                    controller: kataController,
                    decoration: InputDecoration(
                      hintText: 'Cat',
                      labelText: 'Kosakata',
                    ),
                  ),
                  TextField(
                    controller: artiController,
                    decoration: InputDecoration(
                      hintText: 'Kucing',
                      labelText: 'Arti',
                    ),
                  ),
                ],
              ),
              actions: [
                Container(
                  height: 40,
                  width: double.infinity,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                    onPressed: () {
                      if (id! < 0) {
                        saveVocab();
                      } else {
                        updateVocab(id);
                      }
                    },
                    child: Text(
                      'Simpan',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                )
              ],
            );
          });
    }

    //screen
    return Scaffold(
      appBar: AppBar(
        title: Text('Kamus Pribadi'),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showAddKata(-1);
        },
        child: Icon(
          Icons.add,
        ),
      ),
      body: FutureBuilder(
        future: kamusProvider.fetchAndSetKamus(),
        builder: (context, snapshot) {
          return Consumer<KamusProvider>(
            child: Center(
              child: Image.asset('assets/noitem.png'),
            ),
            builder: (context, kamus, ch) {
              return kamus.kamus.length == 0
                  ? SingleChildScrollView(
                      child: Column(
                        children: [
                          Image.asset('assets/noitem.png'),
                          Text(
                            'Ayo Tambahkan Kosakatamu',
                            style: TextStyle(
                              fontSize: 20.0,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemBuilder: (ctx, i) {
                        return Column(
                          children: [
                            Dismissible(
                              key: ValueKey(i),
                              direction: DismissDirection.endToStart,
                              background: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10.0,
                                ),
                                color: Colors.red,
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Icon(
                                    Icons.delete,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              confirmDismiss: (DismissDirection direction) {
                                return showDialog(
                                  context: context,
                                  builder: (ctx) {
                                    return AlertDialog(
                                      title: Text(
                                          'Hapus kata ${kamus.kamus[i].kata}'),
                                      content: Text('Apakah anda yakin'),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            kamusProvider.delete(
                                              kamus.kamus[i].id,
                                            );
                                            Navigator.of(context).pop();
                                            showSnack(
                                                "Berhasil Dihapus", Colors.red);
                                          },
                                          child: Text('Ya'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text(
                                            'Batal',
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              child: ListTile(
                                leading: Text(
                                  "${i + 1}.",
                                  style: TextStyle(
                                    fontSize: 18.0,
                                  ),
                                ),
                                title: Text(
                                  kamus.kamus[i].kata,
                                ),
                                subtitle: Text(kamus.kamus[i].arti),
                                trailing: IconButton(
                                  onPressed: () {
                                    kataController.text = kamus.kamus[i].kata;
                                    artiController.text = kamus.kamus[i].arti;
                                    showAddKata(kamus.kamus[i].id);
                                  },
                                  icon: Icon(
                                    Icons.edit,
                                  ),
                                ),
                              ),
                            ),
                            Divider(),
                          ],
                        );
                      },
                      itemCount: kamus.kamus.length,
                    );
            },
          );
        },
      ),
    );
  }
}
