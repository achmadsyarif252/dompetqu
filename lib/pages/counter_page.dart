import 'package:dompet_q/provider/counter_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CounterPage extends StatelessWidget {
  static const routeName = '/counter';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Provider.of<CounterProvider>(context,listen: false).addCounter("Alhamdulillah");
        },
        child: Icon(
          Icons.add,
        ),
      ),
      body: FutureBuilder(
        builder: (ctx, snapshot) {
          return Consumer(
            builder: (ctx, counter, ch) {
              return ListView.builder(
                itemBuilder: (ctx, i) {
                  return Provider.of<CounterProvider>(context).counter.length ==
                          0
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : ListTile(
                          title: Text(
                            Provider.of<CounterProvider>(context)
                                .counter[i]
                                .nama,
                          ),
                        );
                },
                itemCount: Provider.of<CounterProvider>(context).counter.length,
              );
            },
          );
        },
        future: Provider.of<CounterProvider>(context).fetchAndSetCounter(),
      ),
    );
  }
}
