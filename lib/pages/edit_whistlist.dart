import 'package:dompet_q/models/whistlist.dart';
import 'package:dompet_q/provider/whistlist_provider.dart';
import 'package:flutter/material.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class EditWhistList extends StatefulWidget {
  static const routeName = '/edit-whistlist';

  @override
  State<EditWhistList> createState() => _EditWhistListState();
}

class _EditWhistListState extends State<EditWhistList> {
  TextEditingController namaController = TextEditingController();

  TextEditingController totalController = TextEditingController();

  TextEditingController tanggalController = TextEditingController();

  String? nama, tanggal;

  String? total;

  DateTime? selectedDate;

  final _priceFocusNode = FocusNode();

  final _targetNode = FocusNode();

  final formState = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    //get id from navigator
    final int id = ModalRoute.of(context)!.settings.arguments as int;
    final WhistListProvider whistListProvider =
        Provider.of<WhistListProvider>(context);
    WhistList whistList = whistListProvider.findById(id);
    // tanggalController.text = whistList.tanggal.toString();
    namaController.text = whistList.nama!;
    totalController.text = "Rp.${whistList.total.toString()}";
    var _initialValues = {
      'nama': whistList.nama,
      'tanggal': whistList.tanggal,
      'total': whistList.total,
    };
    _presentDatePicker() {
      showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1900),
        lastDate: DateTime(2100),
      ).then((pickedDate) {
        if (pickedDate == null) {
          return;
        }
        // date2 = pickedDate.toIso8601String();
        tanggal = pickedDate.toIso8601String();
        setState(() {
          _initialValues['tanggal'] = pickedDate.toIso8601String();
        });
        print(_initialValues['tanggal']);
        selectedDate = pickedDate;
        tanggalController.text = selectedDate!.toIso8601String();
      });
    }

    void update() {
      final isvalid = formState.currentState!.validate();
      if (!isvalid) {
        return;
      }

      formState.currentState!.save();
      Provider.of<WhistListProvider>(context, listen: false).update(
        id,
        nama!,
        double.parse(
          total.toString().substring(3).replaceAll(".", ""),
        ),
        tanggal!,
        whistList.isComplete!,
        whistList.currentDana!,
      );
      Navigator.of(context).pop();
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Row(
          children: [
            Text(
              'WhistList Baru',
              style: TextStyle(
                color: Colors.black,
                fontSize: 28.0,
              ),
            ),
            Spacer(),
            IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Icon(
                Icons.close,
                color: Colors.black,
                size: 30.0,
              ),
            )
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Form(
          key: formState,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Nama Barang',
                style: TextStyle(
                  fontSize: 18.0,
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              TextFormField(
                // controller: namaController,
                // onSaved: (value) {
                //   editWhistList = WhistList.withId(
                //     id: editWhistList.id,
                //     nama: value,
                //     tanggal: editWhistList.tanggal,
                //     total: editWhistList.total,
                //     currentDana: editWhistList.currentDana,
                //     isComplete: editWhistList.isComplete,
                //   );
                // },
                initialValue: _initialValues['nama'].toString(),
                onSaved: (value) {
                  nama = value;
                },
                validator: (e) {
                  if (e!.isEmpty) {
                    return "Nama Barang harus diisi yaa..";
                  }
                  return null;
                },
                decoration: InputDecoration(
                  hintText: 'Sepeda Gunung',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                ),
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_priceFocusNode);
                },
              ),
              SizedBox(
                height: 20.0,
              ),
              Text(
                'Harga',
                style: TextStyle(
                  fontSize: 18.0,
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              TextFormField(
                initialValue:
                    "Rp.${_initialValues['total'].toString().substring(0, _initialValues['total'].toString().indexOf('.'))}",
                onSaved: (value) {
                  total = value;
                },
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  CurrencyTextInputFormatter(
                    locale: 'id_ID',
                    decimalDigits: 0,
                    symbol: 'Rp.',
                  ),
                ],
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_targetNode);
                },
                validator: (e) {
                  if (e!.isEmpty) {
                    return "Harga harus diisi yaa..";
                  }
                  return null;
                },
                focusNode: _priceFocusNode,
                decoration: InputDecoration(
                  hintText: 'Rp.2000.000',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Text(
                'Target Beli',
                style: TextStyle(
                  fontSize: 18.0,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(
                  top: 5.0,
                ),
                child: Text(
                  'Target Sebelumnya : ${DateFormat.yMEd().format(DateTime.parse(
                    _initialValues['tanggal'].toString(),
                  ))}',
                  style: TextStyle(
                    fontSize: 14.0,
                  ),
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              TextFormField(
                // initialValue: _initialValues['tanggal'].toString(),
                controller: tanggalController,
                onTap: () {
                  _presentDatePicker();
                },
                onSaved: (value) {
                  tanggal = value;
                },
                // onSaved: (value) {
                //   editWhistList = WhistList.withId(
                //     id: editWhistList.id,
                //     nama: editWhistList.nama,
                //     tanggal: tanggalController.text,
                //     total: editWhistList.total,
                //     currentDana: editWhistList.currentDana,
                //     isComplete: editWhistList.isComplete,
                //   );
                // },
                readOnly: false,
                focusNode: _targetNode,
                onFieldSubmitted: (_) {
                  update();
                },
                validator: (e) {
                  if (e!.isEmpty) {
                    return "Target dibeli harus diisi yaa..";
                  }
                  return null;
                },
                decoration: InputDecoration(
                  hintText: '20 Februari 2023',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  suffixIcon: IconButton(
                    onPressed: () {
                      _presentDatePicker();
                    },
                    icon: Icon(
                      Icons.date_range,
                    ),
                  ),
                ),
              ),
              Spacer(),
              Container(
                margin: const EdgeInsets.only(bottom: 50.0),
                width: double.infinity,
                height: 50,
                child: TextButton(
                  style: TextButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      )),
                  onPressed: () {
                    update();
                  },
                  child: Text(
                    'SIMPAN',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
