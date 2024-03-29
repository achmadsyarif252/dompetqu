import 'package:dompet_q/models/whistlist.dart';
import 'package:dompet_q/provider/whistlist_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:intl/intl.dart';

class AddWhistList extends StatefulWidget {
  static const routeName = '/add-whistList';

  @override
  State<AddWhistList> createState() => _AddWhistListState();
}

class _AddWhistListState extends State<AddWhistList> {
  TextEditingController namaController = TextEditingController();
  TextEditingController totalController = TextEditingController();
  TextEditingController tanggalController = TextEditingController();
  DateTime? selectedDate;

  // WhistList editWhistList = WhistList.withId(
  //   id: 0,
  //   nama: '',
  //   total: 0,
  //   tanggal: '',
  //   isComplete: -1,
  //   currentDana: 0,
  // );

  // var _initialValues = {
  //   'nama': '',
  //   'total': '',
  //   'tanggal': '',
  // };

  // @override
  // void initState() {
  //   final int? id = ModalRoute.of(context)!.settings.arguments as int?;
  //   if (id == null) return;
  //   editWhistList = Provider.of<WhistListProvider>(context,listen: false).findById(id);
  //   _initialValues = {
  //     'nama': editWhistList.nama!,
  //     'total': "Rp." + editWhistList.total.toString(),
  //     'tanggal': editWhistList.tanggal!,
  //   };
  //   tanggalController.text =
  //       DateFormat.yMMMEd().format(DateTime.parse(editWhistList.tanggal!));
  //   tanggal = editWhistList.tanggal;

  //   super.initState();
  // }

  // var _isInit = true;
  // @override
  // void didChangeDependencies() {
  //   if (_isInit) {
  //     final int? id = ModalRoute.of(context)!.settings.arguments as int?;
  //     if (id == null) return;
  //     editWhistList = Provider.of<WhistListProvider>(context).findById(id);
  //     _initialValues = {
  //       'nama': editWhistList.nama!,
  //       'total': editWhistList.total.toString(),
  //       'tanggal': editWhistList.tanggal!,
  //     };
  //     tanggalController.text =
  //         DateTime.parse(editWhistList.tanggal!).toIso8601String();
  //   }
  //   _isInit = false;
  //   super.didChangeDependencies();
  // }

  final formState = GlobalKey<FormState>();

  DateTime? _selectedDateTime = null;

  final _priceFocusNode = FocusNode();
  String? tanggal;
  final _targetNode = FocusNode();

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
      selectedDate = pickedDate;
      tanggalController.text = selectedDate!.toIso8601String();
    });
  }

  @override
  Widget build(BuildContext context) {
    final whistListProvider = Provider.of<WhistListProvider>(context);
    void save() {
      final isvalid = formState.currentState!.validate();
      if (!isvalid) {
        return;
      }
      formState.currentState!.save();

      whistListProvider.addWhistList(
        namaController.text,
        double.parse(
          totalController.text.substring(3).replaceAll(".", ""),
        ),
        tanggal!,
      );
      Navigator.of(context).pop(1);
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
                controller: namaController,
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
                // initialValue: _initialValues['nama'],
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
                controller: totalController,
                // onSaved: (value) {
                //   editWhistList = WhistList.withId(
                //     id: editWhistList.id,
                //     nama: editWhistList.nama,
                //     tanggal: editWhistList.tanggal,
                //     total: double.parse(
                //       value!.substring(3).replaceAll(".", ""),
                //     ),
                //     currentDana: editWhistList.currentDana,
                //     isComplete: editWhistList.isComplete,
                //   );
                // },
                // initialValue: _initialValues['total'],
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
              // if (_initialValues['tanggal'] != null)
              //   Container(
              //     margin: const EdgeInsets.only(
              //       top: 5.0,
              //     ),
              //     child: Text(
              //       'Target Sebelumnya : ${DateFormat.yMEd().format(DateTime.parse(
              //         _initialValues['tanggal'].toString(),
              //       ))}',
              //       style: TextStyle(
              //         fontSize: 12.0,
              //       ),
              //     ),
              //   ),
              // SizedBox(
              //   height: 10.0,
              // ),
              TextFormField(
                // initialValue: _initialValues['tanggal'],
                controller: tanggalController,
                onTap: () {
                  _presentDatePicker();
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
                  save();
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
                    save();
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
