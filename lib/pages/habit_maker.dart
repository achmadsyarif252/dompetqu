import 'dart:math';
import 'dart:ui';

import 'package:dompet_q/pages/add_progress.dart';
import 'package:dompet_q/provider/habit_prodivder.dart';
import 'package:flutter/material.dart';
import '../provider/habit_prodivder.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

enum Action { Edit }

class HabitMaker extends StatelessWidget {
  final namaHabitController = TextEditingController();

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

  @override
  Widget build(BuildContext context) {
    final HabbitProvider habbitProvider = Provider.of<HabbitProvider>(context);
    saveHabit() {
      if (namaHabitController.text.isEmpty) {
        return;
      }
      habbitProvider.addHabbit(
        namaHabitController.text,
        DateTime.now().toString(),
      );
      namaHabitController.text = "";
      Navigator.of(context).pop();
    }

    updateHabit(int? id, String? nama) {
      if (namaHabitController.text.isEmpty) {
        return;
      }
      habbitProvider.updateHabbit(id!, nama!, 0);
      namaHabitController.text = "";
      Navigator.of(context).pop();
    }

    showDialogHabit(int? id) {
      return showDialog(
          context: context,
          builder: (ctx) {
            return AlertDialog(
              scrollable: true,
              title: Text('Add Habbit'),
              content: TextField(
                controller: namaHabitController,
                decoration: InputDecoration(hintText: 'Bangun Jam 04.00 Pagi'),
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
                        saveHabit();
                      } else {
                        updateHabit(id, namaHabitController.text);
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
          'Build Habit',
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
          showDialogHabit(-1);
        },
        child: Icon(
          Icons.add,
        ),
      ),
      body: FutureBuilder(
        builder: (ctx, snapshot) {
          return Consumer<HabbitProvider>(
            child: Center(
              child: Image.asset('assets/noitem.png'),
            ),
            builder: (ctx, habbit, ch) {
              return habbit.habbit.length == 0
                  ? SingleChildScrollView(
                      child: Column(
                        children: [
                          Image.asset('assets/noitem.png'),
                          Text(
                            'Ayo Bentuk Habbit',
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
                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context).pushNamed(
                              AddProgress.routeName,
                              arguments: habbit.habbit[i].id!,
                            );
                          },
                          child: Dismissible(
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
                                        'Hapus Habit ${habbit.habbit[i].nama}'),
                                    content: Text('Apakah anda yakin'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          habbitProvider.delete(
                                            habbit.habbit[i].id,
                                          );
                                          Navigator.of(context).pop();
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
                            key: ValueKey(i),
                            child: Card(
                              elevation: 1,
                              child: ListTile(
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
                                  habbit.habbit[i].nama,
                                ),
                                subtitle: Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                          text:
                                              '${DateFormat.yMMMEd().format(DateTime.parse(habbit.habbit[i].tanggal))} -'),
                                      TextSpan(
                                          text:
                                              ' ${habbit.habbit[i].repetisi.toString()} Repetisi',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          )),
                                    ],
                                  ),
                                ),
                                trailing: PopupMenuButton<Action>(
                                  onSelected: (Action action) {
                                    if (action == Action.Edit) {
                                      namaHabitController.text =
                                          habbit.habbit[i].nama;
                                      showDialogHabit(habbit.habbit[i].id);
                                    }
                                  },
                                  itemBuilder: (_) {
                                    return [
                                      PopupMenuItem(
                                        child: Text('Edit'),
                                        value: Action.Edit,
                                      ),
                                    ];
                                  },
                                  icon: Icon(
                                    Icons.more_vert,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                      itemCount: habbit.habbit.length,
                    );
            },
          );
        },
        future: habbitProvider.fetchAndSetHabbit(),
      ),
    );
  }
}
