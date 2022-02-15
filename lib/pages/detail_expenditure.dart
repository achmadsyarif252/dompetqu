import 'package:dompet_q/provider/transaction_provider.dart';
import 'package:dompet_q/widgets/list_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DetailExpenditure extends StatelessWidget {
  static const routeName = '/detail';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Detail Transaksi Masuk/Keluar"),
          centerTitle: true,
          elevation: 0,
        ),
        body: FutureBuilder(
          future:
              Provider.of<TransactionProvider>(context).fetchAndSetTransaksi(),
          builder: (ctx, snapshot) => Consumer<TransactionProvider>(
            child: Center(
              child: Text(
                'Riwayat Kosong',
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
            ),
            builder: (ctx, transaksi, ch) {
              return transaksi.userTransaksi.length == 0
                  ? ch!
                  : ListView.builder(
                      itemCount: transaksi.userTransaksi.length,
                      itemBuilder: (context, i) {
                        int id = transaksi.userTransaksi[i].id;
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTIles(
                            id: id,
                            nama: transaksi.userTransaksi[i].name,
                            tanggal: transaksi.userTransaksi[i].tanggal,
                            total: (transaksi.userTransaksi[i].total) / 1000,
                            jenis: transaksi.userTransaksi[i].jenis,
                            handler: transaksi.deleteData,
                          ),
                        );
                      },
                    );
            },
          ),
        ));
  }
}
