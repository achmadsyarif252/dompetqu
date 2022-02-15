import 'package:dompet_q/models/chart_data.dart';
import 'package:dompet_q/models/transaction.dart';
import 'package:dompet_q/pages/detail_expenditure.dart';
import 'package:dompet_q/pages/new_income.dart';
import 'package:dompet_q/provider/transaction_provider.dart';
import 'package:dompet_q/widgets/list_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<ChartData> chartData = [];

  @override
  void initState() {
    chartData.add(
      ChartData(
        tipe: "Pemasukan",
        total: 150000,
      ),
    );
    chartData.add(
      ChartData(
        tipe: "Pengeluaran",
        total: 50000,
      ),
    );
    super.initState();
  }

  DateTime? _selectedDate = null;
  @override
  Widget build(BuildContext context) {
    final transactionProvider = Provider.of<TransactionProvider>(context);

    // final userTransaksi = transactionProvider.userTransaksi;
    cardBox({
      String? title,
      double? total,
      IconData? icon,
      Color? warnaIcon,
      String? jenis,
    }) {
      return Container(
        width: MediaQuery.of(context).size.width * 0.4,
        padding: const EdgeInsets.all(10.0),
        height: 100,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(
              10.0,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: (ctx) {
                    return NewTransaction(
                      transactionProvider.addTransaction,
                      jenis!,
                    );
                  },
                );
              },
              child: Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(
                      8.0,
                    ),
                  ),
                  color: Colors.grey.shade300,
                ),
                child: Icon(
                  icon,
                  color: warnaIcon,
                ),
              ),
            ),
            Flexible(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    title!,
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Text(
                    'Rp.${total!.toStringAsFixed(2)}K',
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    header() {
      return Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 20.0, top: 30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              'Rp.${transactionProvider.total.toStringAsFixed(2)}K',
              style: TextStyle(
                fontSize: 32.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            // SizedBox(
            //   height: 10.0,
            // ),
            Text(
              'You spent ${transactionProvider.persentase.toStringAsFixed(2)}% Income',
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
            SizedBox(
              height: 30.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                cardBox(
                  title: 'Pemasukan',
                  icon: Icons.arrow_downward,
                  warnaIcon: Colors.green,
                  total: transactionProvider.income / 1000,
                  jenis: "1",
                ),
                cardBox(
                  title: 'Pengeluaran',
                  icon: Icons.arrow_upward,
                  warnaIcon: Colors.red,
                  total: transactionProvider.outcome / 1000,
                  jenis: "2",
                ),
              ],
            ),
          ],
        ),
      );
    }

    chart() {
      return Container(
        margin: const EdgeInsets.only(
          bottom: 15.0,
        ),
        width: double.infinity,
        color: Colors.white38,
        child: transactionProvider.userTransaksi.length == 0
            ? Center(
                child: Column(
                  children: [
                    Container(
                      width: 250,
                      height: 250,
                      child: Image.asset(
                        'assets/noitem.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                    Text(
                      'Transaksi Kosong,Chart Tidak Tersedia',
                    ),
                  ],
                ),
              )
            : SfCircularChart(
                legend: Legend(
                  isVisible: true,
                  overflowMode: LegendItemOverflowMode.wrap,
                ),
                title: ChartTitle(text: 'Chart Riwayat Transaksi Terakhir'),
                series: <CircularSeries>[
                  PieSeries<Transaction, String>(
                      dataSource: transactionProvider.userTransaksiChart,
                      xValueMapper: (Transaction data, _) =>
                          data.name.toString(),
                      yValueMapper: (Transaction data, _) => data.total,
                      dataLabelSettings: DataLabelSettings(
                        isVisible: true,
                      ),
                      enableTooltip: true),
                ],
              ),
      );
    }

    expenditure() {
      return Container(
        height: MediaQuery.of(context).size.height * 0.3,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Expenditure',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Spacer(),
                  Text('Total : ${transactionProvider.totalData}'),
                  SizedBox(
                    width: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushNamed(
                        DetailExpenditure.routeName,
                      );
                    },
                    child: Text(
                      'View All',
                      style: TextStyle(
                        color: Colors.red,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Expanded(
              child: FutureBuilder(
                future: Provider.of<TransactionProvider>(context)
                    .fetchAndSetTransaksi(),
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
                                  total:
                                      (transaksi.userTransaksi[i].total) / 1000,
                                  jenis: transaksi.userTransaksi[i].jenis,
                                  handler: transaksi.deleteData,
                                ),
                              );
                            },
                          );
                  },
                ),
              ),
            ),
          ],
        ),
      );
    }

    content() {
      return ListView(
        children: [
          header(),
          chart(),
          expenditure(),
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {},
          icon: Icon(
            Icons.clear_all,
            size: 30.0,
          ),
          color: Colors.black,
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text(
          'Dompet Qu',
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
      body: content(),
    );
  }
}
