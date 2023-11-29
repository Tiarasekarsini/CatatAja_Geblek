import 'dart:math';

import 'package:calendar_appbar/calendar_appbar.dart';
import 'package:catataja_geblek/controller/pemasukan_controller.dart';
import 'package:catataja_geblek/view/add_pemasukan.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var pm = PemasukanController();
  DateTime? selectedDate;
  Random random = Random();

  @override
  void initState() {
    setState(() {
      selectedDate = DateTime.now();
      pm.getPemasukan();
    });
    super.initState();
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
              padding: const EdgeInsets.only(top: 5),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AddPemasukan(),
                    ),
                  );
                },
                child: const Text('tambah'),
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
                          const EdgeInsets.only(right: 20, left: 20, top: 20),
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
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            IconButton(
                              onPressed: () {},
                              icon: Icon(Icons.delete),
                              color: Colors.red,
                            ),
                            IconButton(
                                onPressed: () {},
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
