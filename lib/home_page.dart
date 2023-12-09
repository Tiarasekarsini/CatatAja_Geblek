import 'dart:math';

import 'package:calendar_appbar/calendar_appbar.dart';
import 'package:catataja_geblek/controller/pemasukan_controller.dart';
import 'package:catataja_geblek/view/add_pemasukan.dart';
import 'package:catataja_geblek/view/edit_pemasukan.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var pm = PemasukanController();
  DateTime? selectedDate;
  Random random = Random();
  double totalPendapatan = 0;

  @override
  void initState() {
    super.initState();
    setState(() {
      selectedDate = DateTime.now();
      pm.getPemasukan().then((_) {
        _hitungTotalPemasukan();
        pm.initPendapatanListener();
      });
    });
  }

  @override
  void dispose() {
    pm.cancelPendapatanListener();
    super.dispose();
  }

  void _hitungTotalPemasukan() {
    pm.getTotalPendapatan().then((value) {
      setState(() {
        totalPendapatan = double.parse(value);
      });
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
        onDateChanged: (value) => setState(() => selectedDate = value),
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
          StreamBuilder<List<DocumentSnapshot>>(
            stream: pm.stream,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return SliverToBoxAdapter(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              final List<DocumentSnapshot> data = snapshot.data!;
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

                    return Card(
                      margin:
                          const EdgeInsets.only(right: 25, left: 25, top: 15),
                      elevation: 10,
                      child: ListTile(
                        title: Text(
                          'Rp. $amountString', // Display amount
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          '$description', // Display description
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
                                                        pm.getPemasukan();
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
