import 'package:dompet_q/models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';

class NewTransaction extends StatefulWidget {
  final Function handler;
  final String jenisInput;
  NewTransaction(this.handler, this.jenisInput);

  @override
  _NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  DateTime? _selectedDate;
  TextEditingController nameController = TextEditingController();
  TextEditingController nominalController = TextEditingController();

  _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    ).then((value) {
      if (value == null) {
        return;
      }
      setState(() {
        _selectedDate = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height * 0.9,
        child: Card(
          elevation: 5,
          child: Container(
            margin: const EdgeInsets.only(bottom: 20.0),
            padding: EdgeInsets.only(
                top: 10,
                left: 10,
                right: 10,
                bottom: MediaQuery.of(context).viewInsets.bottom + 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Center(
                  child: Text(
                    widget.jenisInput == "1"
                        ? 'Catat Pemasukan'
                        : "Catat Pengeluaran",
                    style: TextStyle(
                      fontSize: 18.0,
                    ),
                  ),
                ),
                SizedBox(
                  height: 50.0,
                ),
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: widget.jenisInput == "1"
                        ? 'Nama Pemasukan'
                        : "Nama Pengeluaran",
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                TextField(
                  inputFormatters: <TextInputFormatter>[
                    CurrencyTextInputFormatter(
                      locale: 'id_ID',
                      decimalDigits: 0,
                      symbol: 'Rp.',
                    ),
                  ],
                  controller: nominalController,
                  decoration: InputDecoration(
                    labelText: 'Nominal',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
                Container(
                  height: 70,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          _selectedDate == null
                              ? 'Pilih Tanggal!'
                              : 'Tanggal : ${DateFormat.yMd().format(_selectedDate!)}',
                        ),
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.blue,
                        ),
                        onPressed: () {
                          _presentDatePicker();
                        },
                        child: Text(
                          '---',
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 30.0,
                ),
                Container(
                  height: 50,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor:
                          widget.jenisInput == "1" ? Colors.green : Colors.red,
                    ),
                    onPressed: () {
                      widget.handler(
                        nameController.text,
                        double.parse(
                          nominalController.text
                              .substring(3)
                              .replaceAll(".", ""),
                        ),
                        _selectedDate,
                        widget.jenisInput,
                      );
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'Simpan',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
