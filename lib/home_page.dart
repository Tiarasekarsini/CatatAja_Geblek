import 'dart:math';

import 'package:calendar_appbar/calendar_appbar.dart';
import 'package:catataja_geblek/controller/pemasukan_controller.dart';
import 'package:catataja_geblek/view/add_pemasukan.dart';
import 'package:catataja_geblek/view/edit_pemasukan.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart'; // Import DateFormat

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var pm = PemasukanController();
  DateTime selectedDate = DateTime.now();
  DateTime filterDate = DateTime.now();
  Random random = Random();
  double totalPendapatan = 0;

  @override
  void initState() {
    super.initState();
    setState(() {
      selectedDate = filterDate;
      pm.getPemasukan(selectedDate).then((_) {
        _hitungTotalPemasukan();
        pm.initPemasukanListener();
      });
    });
  }

  @override
  void dispose() {
    pm.cancelPemasukanListener();
    super.dispose();
  }

  void _hitungTotalPemasukan() {
    pm.getTotalPemasukan().then((value) {
      setState(() {
        totalPendapatan = double.parse(value);
      });
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2010),
      lastDate: DateTime(2100),
    );

    if (picked != null && picked != selectedDate) {
      print('Selected Date: $picked');

      // Perform the asynchronous work outside setState
      await pm.getPemasukan(picked);

      // Update the widget state synchronously
      setState(() {
        selectedDate = picked;
        filterDate = picked;
      });
    }
  }

  void filterByDate(DateTime date) {
    /// Metode untuk memfilter laporan berdasarkan tanggal
    setState(() {
      filterDate = date;

      /// Memperbarui tanggal filter laporan
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CalendarAppBar(
        fullCalendar: true,
        backButton: false,
        accent: Color.fromARGB(255, 123, 17, 10),
        locale: 'id',
        onDateChanged: (value) => _selectDate(context),
        lastDate: DateTime.now(),
        events: List.generate(
          100,
          (index) => DateTime.now()
              .subtract(Duration(days: index * random.nextInt(5))),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(left: 25, right: 25, top: 10),
              child: Card(
                elevation: 10,
                child: ListTile(
                  title: Text(
                    "Pemasukkan",
                    style: GoogleFonts.montserrat(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: StreamBuilder<double>(
                    stream: pm.totalPendapatanStream,
                    initialData: 0,
                    builder: (context, snapshot) {
                      return Text(
                        "Rp. ${snapshot.data}",
                        style: GoogleFonts.montserrat(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      );
                    },
                  ),
                  leading: Container(
                    child: Icon(
                      Icons.download,
                      color: Colors.green,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(left: 25, right: 25, top: 25),
              child: Container(
                child: Row(
                  children: [
                    Text(
                      "Transaksi",
                      style: GoogleFonts.montserrat(
                          fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(width: 150),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        textStyle: GoogleFonts.montserrat(
                            fontSize: 14, fontWeight: FontWeight.w600),
                      ),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => AddPemasukan(),
                        ));
                        //     .then((value) {
                        //   // calculateTotalPemasukan();
                        //   setState(() {});
                        // });
                      },
                      child: Text(
                        "Tambah",
                        style: GoogleFonts.montserrat(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          StreamBuilder<QuerySnapshot>(
            stream:
                FirebaseFirestore.instance.collection('pemasukan').snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return SliverToBoxAdapter(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              final List<DocumentSnapshot> data =
                  snapshot.data!.docs.where((doc) {
                DateTime tanggalPemasukan =
                    DateFormat('dd-MMMM-yyyy').parse(doc['transactionDate']);
                return DateFormat('yyyy-MM-dd').format(tanggalPemasukan) ==
                    DateFormat('yyyy-MM-dd').format(selectedDate);
              }).toList();

              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    // Convert amount to string before calling substring
                    String amountString = data[index]['amount'].toString();

                    // Remove trailing zeros after the decimal point
                    amountString = amountString.contains('.')
                        ? amountString
                            .replaceAll(RegExp(r"0*$"), "")
                            .replaceAll(RegExp(r"\.$"), "")
                        : amountString;

                    String description =
                        data[index]['description'].toString(); // Add this line
                    String transactionDate =
                        data[index]['transactionDate'].toString();

                    return Card(
                      margin:
                          const EdgeInsets.only(right: 25, left: 25, top: 15),
                      elevation: 10,
                      child: ListTile(
                        title: Text(
                          'Rp. $amountString', // Display amount
                          style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '$description', // Display description
                              style: GoogleFonts.montserrat(
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              '$transactionDate', // Add your additional information here
                              style: GoogleFonts.montserrat(
                                  fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        leading: Container(
                          child: Icon(
                            Icons.download,
                            color: Colors.green,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            IconButton(
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        15.0)),
                                            content: Text(
                                              'Anda yakin ingin menghapus data ini?',
                                              style: GoogleFonts.montserrat(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            actions: [
                                              TextButton(
                                                  style: TextButton.styleFrom(
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          15.0)),
                                                      backgroundColor:
                                                          Colors.white),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Text(
                                                    'Tidak',
                                                    style:
                                                        GoogleFonts.montserrat(
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors.blue),
                                                  )),
                                              TextButton(
                                                  style: TextButton.styleFrom(
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          15.0)),
                                                      backgroundColor:
                                                          Colors.blue),
                                                  onPressed: () async {
                                                    Navigator.pop(context);
                                                    pm
                                                        .delPemasukan(
                                                            data[index].id)
                                                        .then((value) {
                                                      setState(() {
                                                        pm.getPemasukan(
                                                            selectedDate);
                                                      });
                                                    });
                                                    var snackBar = const SnackBar(
                                                        content: Text(
                                                            'Data berhasil dihapus'));
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(snackBar);
                                                  },
                                                  child: Text(
                                                    'Ya',
                                                    style:
                                                        GoogleFonts.montserrat(
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Colors.black),
                                                  )),
                                            ]);
                                      });
                                },
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                )),
                            IconButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => EditPemasukan(
                                                id: data[index]['id'],
                                                amountOlder: data[index]
                                                    ['amount'],
                                                transactionDateOlder:
                                                    data[index]
                                                        ['transactionDate'],
                                                descriptionOlder: data[index]
                                                    ['description'],
                                              )));
                                },
                                icon: Icon(Icons.edit),
                                color: Colors.blue)
                          ],
                        ),
                      ),
                    );
                  },
                  childCount: data.length,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

String removeTrailingZeros(String amountString) {
  if (amountString.contains('.')) {
    amountString = amountString
        .replaceAll(RegExp(r"0*$"), "")
        .replaceAll(RegExp(r"\.$"), "");
  }
  return amountString;
}
