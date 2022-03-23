import 'package:dompet_q/models/reward_model.dart';
import 'package:dompet_q/provider/point_provider.dart';
import 'package:dompet_q/provider/reward_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyPoin extends StatefulWidget {
  static const routeName = '/my-poin';

  @override
  State<MyPoin> createState() => _MyPoinState();
}

class _MyPoinState extends State<MyPoin> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Provider.of<PointProvider>(context, listen: false).fetchAndSetPoint();
  }

  Widget build(BuildContext context) {
    final PointProvider pointProvider = Provider.of<PointProvider>(context);
    final RewardProvider rewardProvider = Provider.of<RewardProvider>(context);

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
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(
              Icons.arrow_back_ios,
            ),
          ),
          title: Text(
            'Tukar Poin',
            style: TextStyle(fontSize: 22.0),
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 10.0,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Poin Saya : ',
                      style: TextStyle(
                        fontSize: 30.0,
                        color: Colors.white,
                      ),
                    ),
                    Spacer(),
                    Text(
                      '${pointProvider.mypoint}',
                      style: TextStyle(
                        fontSize: 30.0,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      'Total Klaim : ',
                      style: TextStyle(
                        fontSize: 30.0,
                        color: Colors.white,
                      ),
                    ),
                    Spacer(),
                    Text(
                      '${pointProvider.mytotal}',
                      style: TextStyle(
                        fontSize: 30.0,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20.0,
                ),
                Text(
                  'Reward Yang Tersedia',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 10.0, bottom: 20.0),
                  height: MediaQuery.of(context).size.height * 0.7,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey, width: 2),
                      borderRadius: BorderRadius.circular(25.0)),
                  child: FutureBuilder(
                      future: rewardProvider.fetchAndSetReward(),
                      builder: (context, snapshot) {
                        return Consumer<RewardProvider>(
                          child: Text('No Reward Available'),
                          builder: (ctx, reward, ch) {
                            return ListView.builder(
                              itemBuilder: (ctx, i) {
                                return reward.reward[i].req_poin >
                                        pointProvider.mypoint
                                    ? SizedBox()
                                    : Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20.0),
                                        child: Column(
                                          children: [
                                            ListTile(
                                              onTap: () {
                                                showDialog(
                                                    context: context,
                                                    builder: (ctx) {
                                                      return AlertDialog(
                                                        content: Text(
                                                            'Tukar ${reward.reward[i].req_poin} poin dengan ${reward.reward[i].nama}?'),
                                                        actions: [
                                                          TextButton(
                                                            onPressed: () {
                                                              rewardProvider
                                                                  .getRewardUpdate(
                                                                      reward
                                                                          .reward[
                                                                              i]
                                                                          .id!);
                                                              pointProvider
                                                                  .updatePoin(
                                                                      -reward
                                                                          .reward[
                                                                              i]
                                                                          .req_poin!,
                                                                      1);

                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                              showDialog(
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (ctx) {
                                                                    return AlertDialog(
                                                                      content:
                                                                          Container(
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          borderRadius:
                                                                              BorderRadius.circular(
                                                                            20.0,
                                                                          ),
                                                                        ),
                                                                        width: MediaQuery.of(context).size.width *
                                                                            0.6,
                                                                        height: MediaQuery.of(context).size.width *
                                                                            0.6,
                                                                        child:
                                                                            Column(
                                                                          children: [
                                                                            CircleAvatar(
                                                                              radius: 100,
                                                                              backgroundColor: Colors.blue,
                                                                              child: Icon(
                                                                                Icons.check,
                                                                                color: Colors.white,
                                                                                size: 80.0,
                                                                              ),
                                                                            ),
                                                                            SizedBox(
                                                                              height: 10,
                                                                            ),
                                                                            Text(
                                                                              'Reward Berhasil Didapat,Silakan Lakukan/Beli Reward Tersebut',
                                                                              textAlign: TextAlign.center,
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      actions: [
                                                                        Container(
                                                                          width:
                                                                              double.infinity,
                                                                          child:
                                                                              TextButton(
                                                                            style:
                                                                                TextButton.styleFrom(backgroundColor: Colors.blue),
                                                                            onPressed:
                                                                                () {
                                                                              Navigator.of(context).pop();
                                                                            },
                                                                            child:
                                                                                Text(
                                                                              'CLOSE',
                                                                              style: TextStyle(
                                                                                color: Colors.white,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    );
                                                                  });
                                                            },
                                                            child: Text('Ya'),
                                                          ),
                                                          TextButton(
                                                            onPressed: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                            child:
                                                                Text('Batal'),
                                                          ),
                                                        ],
                                                      );
                                                    });
                                              },
                                              leading: Icon(
                                                Icons.card_giftcard_rounded,
                                              ),
                                              title: Text(
                                                '${reward.reward[i].nama}',
                                                style: TextStyle(
                                                  color: Colors.black,
                                                ),
                                              ),
                                              trailing: Text(
                                                  '${reward.reward[i].req_poin}'),
                                            ),
                                            Divider()
                                          ],
                                        ),
                                      );
                              },
                              itemCount: reward.reward.length,
                            );
                          },
                        );
                      }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
