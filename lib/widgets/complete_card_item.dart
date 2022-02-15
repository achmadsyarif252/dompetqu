import 'package:dompet_q/provider/whistlist_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class CompleteCardItem extends StatelessWidget {
  final int? id;
  final String? nama;
  final double? total;
  final String? tanggal;
  final double? curentDana;

  const CompleteCardItem({
    Key? key,
    this.id,
    this.nama,
    this.total,
    this.tanggal,
    this.curentDana,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final WhistListProvider whistListProvider =
        Provider.of<WhistListProvider>(context);
    return Card(
      elevation: 1,
      child: Container(
        padding: const EdgeInsets.all(10.0),
        height: 200,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(
            5.0,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              margin: const EdgeInsets.only(),
              width: 100,
              height: double.infinity,
              decoration: BoxDecoration(
                color: Colors.green,
                image: DecorationImage(
                    image: AssetImage(
                      'assets/realme.jpg',
                    ),
                    fit: BoxFit.fill),
              ),
            ),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 10.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$nama',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w600,
                      ),
                      softWrap: true,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      DateFormat.yMMMEd().format(
                        DateTime.parse(tanggal!),
                      ),
                    ),
                    Spacer(),
                    Text(
                      'Rp.${total! / 1000}K',
                      softWrap: true,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              width: 100,
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.blue,
                ),
                onPressed: () {
                  whistListProvider.update(
                    id!,
                    nama!,
                    total!,
                    tanggal!,
                    1,
                    curentDana!,
                  );
                },
                child: Text(
                  'Tercapai',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
