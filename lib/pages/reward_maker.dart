import 'package:dompet_q/provider/reward_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RewardMaker extends StatelessWidget {
  static const routeName = '/reward-maker';
  final namaController = TextEditingController();
  final req_poinController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    showSnack(String pesan, Color color) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(pesan),
          backgroundColor: color,
        ),
      );
    }

    final RewardProvider rewardProvider = Provider.of<RewardProvider>(context);
    saveReward() {
      int req_poin = int.parse(req_poinController.text);
      if (namaController.text.isEmpty ||
          req_poinController.text.isEmpty ||
          req_poin <= 0) {
        return;
      }
      rewardProvider.addReward(namaController.text, req_poin);
      namaController.clear();
      req_poinController.clear();
      Navigator.of(context).pop();
      showSnack("Reward Berhasil Disimpan", Colors.green);
    }

    updateReward(int? id) {
      int req_poin = int.parse(req_poinController.text);
      if (namaController.text.isEmpty ||
          req_poinController.text.isEmpty ||
          req_poin <= 0) {
        return;
      }
      rewardProvider.updateReward(id!, namaController.text, req_poin, 0);
      namaController.clear();
      req_poinController.clear();
      Navigator.of(context).pop();
      showSnack("Reward Berhasil Diedit", Colors.blue);
    }

    showAddReward(int? id) {
      return showDialog(
          context: context,
          builder: (ctx) {
            return AlertDialog(
              scrollable: true,
              title: Text('Add Reward'),
              content: Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  TextField(
                    controller: namaController,
                    decoration: InputDecoration(
                      hintText: 'Contoh : Bakso Rudal',
                      labelText: 'Nama Reward',
                    ),
                  ),
                  TextField(
                    controller: req_poinController,
                    decoration: InputDecoration(
                      hintText: 'Contoh : 100',
                      labelText: 'Minimal Poin',
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ],
              ),
              actions: [
                Container(
                  height: 40,
                  width: double.infinity,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.orange,
                    ),
                    onPressed: () {
                      if (id! < 0) {
                        saveReward();
                      } else {
                        updateReward(id);
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

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Row(
          children: [
            SizedBox(
              width: 35,
            ),
            Text(
              'Setting Reward',
              style: TextStyle(
                color: Colors.black,
                fontSize: 28.0,
              ),
            ),
            Spacer(),
            IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Icon(
                Icons.close,
                color: Colors.black,
                size: 30.0,
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showAddReward(-1);
        },
        child: Icon(
          Icons.add,
        ),
      ),
      body: FutureBuilder(
        builder: (ctx, snapshot) {
          return Consumer<RewardProvider>(
            builder: (contex, reward, ch) {
              return reward.reward.length == 0
                  ? SingleChildScrollView(
                      child: Column(
                        children: [
                          Image.asset('assets/noitem.png'),
                          Text(
                            'Ayo Tambahkan Reward\nBiar tambah semangat\nBentuk Habbit',
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
                        return Dismissible(
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
                                      'Hapus reward ${reward.reward[i].nama}'),
                                  content: Text('Apakah anda yakin'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        reward.delete(
                                          reward.reward[i].id,
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
                          child: Card(
                            elevation: 2,
                            child: ListTile(
                              trailing: IconButton(
                                  onPressed: () {
                                    namaController.text =
                                        reward.reward[i].nama.toString();
                                    req_poinController.text =
                                        reward.reward[i].req_poin.toString();
                                    showAddReward(reward.reward[i].id as int);
                                  },
                                  icon: Icon(
                                    Icons.edit,
                                  )),
                              leading: CircleAvatar(
                                radius: 30,
                                backgroundColor: Colors.deepOrange,
                                child: Text(
                                  '${reward.reward[i].req_poin}',
                                  style: TextStyle(
                                      fontSize: 20.0,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              title: Text(
                                '${reward.reward[i].nama}',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                  'Berhasil Diraih : ${reward.reward[i].completed}'),
                            ),
                          ),
                        );
                      },
                      itemCount: reward.reward.length,
                    );
            },
          );
        },
        future: rewardProvider.fetchAndSetReward(),
      ),
    );
  }
}
