import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ListTIles extends StatelessWidget {
  final int? id;
  final String? nama;
  final String? tanggal;
  final double? total;
  final String? jenis;
  final Function? handler;

  ListTIles(
      {this.id, this.nama, this.tanggal, this.total, this.jenis, this.handler});
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 50.0,
        height: 50.0,
        decoration: BoxDecoration(
          color: jenis == "1" ? Colors.green : Colors.red,
          borderRadius: BorderRadius.circular(
            10.0,
          ),
        ),
        child: Icon(
          Icons.ac_unit,
          color: Colors.white,
          size: 30.0,
        ),
      ),
      title: Text(
        "${nama!.toUpperCase()} - Rp.${total}K",
        style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w400),
      ),
      subtitle: Text(
        DateFormat.yMMMd().format(DateTime.parse(tanggal!)).toString(),
      ),
      trailing: IconButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text('Delete'),
                  content: Text('Delete this item ?'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('No'),
                    ),
                    TextButton(
                      onPressed: () {
                        handler!(id);
                        Navigator.of(context).pop(true);
                      },
                      child: Text('Yes'),
                    ),
                  ],
                );
              });
        },
        icon: Icon(
          Icons.delete,
          color: Colors.red,
        ),
      ),
    );
  }
}
