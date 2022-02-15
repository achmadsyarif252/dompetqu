import 'package:flutter/material.dart';

class EmptyWhistList extends StatelessWidget {
  final String? imagePath;
  EmptyWhistList(this.imagePath);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Image.asset(
            'assets/$imagePath',
            fit: BoxFit.cover,
          ),
          Text(
            'Barang Impian Anda Kosong',
            style: TextStyle(
              fontSize: 28.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          Text(
            'Tekan tombol + untuk menambahkan barang impian',
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
