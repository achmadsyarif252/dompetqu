import 'package:dompet_q/provider/habit_prodivder.dart';
import 'package:dompet_q/provider/point_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:vibration/vibration.dart';
import 'package:audioplayers/audioplayers.dart';

class AddProgress extends StatefulWidget {
  static const routeName = '/habitcounter';

  @override
  State<AddProgress> createState() => _AddProgressState();
}

class _AddProgressState extends State<AddProgress> {
  late final AudioCache _audioCache;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _audioCache = AudioCache(
      prefix: 'audio/',
      fixedPlayer: AudioPlayer()..setReleaseMode(ReleaseMode.STOP),
    );
  }

  final player = AudioCache();

  @override
  Widget build(BuildContext context) {
    final HabbitProvider habbitProvider = Provider.of<HabbitProvider>(context);
    final PointProvider pointProvider = Provider.of<PointProvider>(context);
    int? id = ModalRoute.of(context)!.settings.arguments as int;
    final selectedHabit = habbitProvider.findById(id);
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromRGBO(0, 163, 255, 1),
            Color.fromRGBO(10, 196, 255, 1),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          leading: Icon(
            Icons.clear_all,
            size: 25.0,
          ),
          centerTitle: true,
          title: Text(
            '${selectedHabit.nama}',
            style: TextStyle(),
          ),
          actions: [
            Container(
              margin: const EdgeInsets.only(
                right: 30.0,
              ),
              child: Icon(
                Icons.notifications_active,
                color: Colors.white,
                size: 25.0,
              ),
            ),
          ],
        ),
        floatingActionButton: Container(
          margin: const EdgeInsets.only(
            top: 50.0,
          ),
          child: FloatingActionButton(
            backgroundColor: Colors.white,
            onPressed: () {
              Vibration.vibrate(duration: 200);
              player.play('audio/keep_going.mp3');
              habbitProvider.updateHabbit(
                  id, selectedHabit.nama!, 1, selectedHabit.poinGain!);
              pointProvider.updatePoin(selectedHabit.poinGain!, 0);
            },
            child: Icon(
              Icons.add,
              color: Colors.blue,
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/noitem.png'),
            Text(
              'Total Reptisi : ${selectedHabit.repetisi}',
              style: TextStyle(
                fontSize: 28,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 50.0,
            ),
            Text(
              'Semangat Bentuk Kebiasaan Baru',
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.white,
              ),
            ),
            Text(
              'Semoga Berhasil Yaa..',
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
