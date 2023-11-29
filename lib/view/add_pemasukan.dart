import 'package:catataja_geblek/controller/pemasukan_controller.dart';
import 'package:catataja_geblek/home_page.dart';
import 'package:catataja_geblek/model/pemasukan_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart'; // Import DateFormat

class AddPemasukan extends StatefulWidget {
  const AddPemasukan({Key? key}) : super(key: key);

  @override
  State<AddPemasukan> createState() => _AddPemasukanState();
}

class _AddPemasukanState extends State<AddPemasukan> {
  var pc = PemasukanController();
  TextEditingController date = TextEditingController();
  final formkey = GlobalKey<FormState>();
  double? amount;
  String? transactionDate;
  String? description;

  @override
  void initState() {
    date.text = "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: formkey,
          child: Stack(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 25, left: 25, right: 25),
                alignment: Alignment.center,
                child: ListTile(
                  title: Text("Pemasukkan",
                      style: GoogleFonts.montserrat(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Color.fromARGB(255, 123, 17, 10))),
                  leading: Column(
                    mainAxisAlignment: MainAxisAlignment
                        .center, // Untuk mengatur ikon ke tengah vertikal
                    children: [
                      Icon(
                        Icons.trending_up_outlined,
                        color: Colors.black,
                        size: 45,
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                height: 50,
                margin: const EdgeInsets.only(top: 100, left: 10, right: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      spreadRadius: 7,
                      blurRadius: 10,
                      offset: Offset(1, 1),
                      color: Colors.grey.withOpacity(0.2),
                    ),
                  ],
                ),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: "Masukkan Jumlah",
                    prefixIcon: const Icon(
                      Icons.pets,
                      color: Color.fromARGB(230, 252, 87, 158),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 1.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: const BorderSide(
                        color: Colors.white,
                        width: 1.0,
                      ),
                    ),
                  ),
                  onChanged: (value) {
                    amount = double.tryParse(value); // Parse string to double
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter the amount";
                    }
                    return null;
                  },
                ),
              ),
              Container(
                height: 50,
                margin: const EdgeInsets.only(top: 170, left: 10, right: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      spreadRadius: 7,
                      blurRadius: 10,
                      offset: Offset(1, 1),
                      color: Colors.grey.withOpacity(0.2),
                    ),
                  ],
                ),
                child: TextFormField(
                  controller: date,
                  decoration: InputDecoration(
                    hintText: "Enter the animal's birth date",
                    prefixIcon: const Icon(
                      Icons.calendar_today,
                      color: Color.fromARGB(230, 252, 87, 158),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 1.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: const BorderSide(
                        color: Colors.white,
                        width: 1.0,
                      ),
                    ),
                  ),
                  readOnly: true,
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2008),
                      lastDate: DateTime(2050),
                    );
                    if (pickedDate != null) {
                      String datepicked =
                          DateFormat('dd-MM-yyyy').format(pickedDate);

                      setState(() {
                        date.text = datepicked;
                        transactionDate =
                            datepicked; // Menetapkan pickedDate langsung
                      });
                    }
                  },
                  onChanged: (value) {
                    // Remove onChanged for date, as it is not needed
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter the animal birth date";
                    }
                    return null;
                  },
                ),
              ),
              Container(
                height: 50,
                margin: const EdgeInsets.only(top: 240, left: 10, right: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      spreadRadius: 7,
                      blurRadius: 10,
                      offset: Offset(1, 1),
                      color: Colors.grey.withOpacity(0.2),
                    ),
                  ],
                ),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: "Masukkan Deskripsi",
                    prefixIcon: const Icon(
                      Icons.pets,
                      color: Color.fromARGB(230, 252, 87, 158),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 1.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: const BorderSide(
                        color: Colors.white,
                        width: 1.0,
                      ),
                    ),
                  ),
                  onChanged: (value) {
                    description = value; // Parse string to double
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter the amount";
                    }
                    return null;
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.only(top: 520, left: 10, right: 10),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    minimumSize: Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40)),
                    textStyle: GoogleFonts.lato(
                      fontSize: 18,
                      color: Colors.white,
                      letterSpacing: 3.5 / 100,
                      height: 152 / 100,
                    ),
                  ),

                  ///proses ketika pengguna menekan tombol save
                  onPressed: () {
                    ///memeriksa inputan dari pengguna
                    if (formkey.currentState!.validate()) {
                      PemasukanModel pm = PemasukanModel(
                        amount: amount!,
                        transactionDate: transactionDate!,
                        description: description!,
                      );
                      pc.addPemasukan(pm);

                      ///menampilkan pesan apabila isian sudah sesuai
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text(
                              'Pawrents! Your data has been successfully added!')));

                      ///mengalihkan ke halaman AnimalData
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HomePage()),
                      );
                    }
                  },
                  child: Text(
                    'Save',
                    style: GoogleFonts.lato(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
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
