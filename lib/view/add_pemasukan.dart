import 'package:catataja_geblek/controller/pemasukan_controller.dart';
import 'package:catataja_geblek/home_page.dart';
import 'package:catataja_geblek/model/pemasukan_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

///Import DateFormat

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
        child: Form(
          key: formkey,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    left: 25, right: 25, top: 40, bottom: 40),
                child: ListTile(
                  title: Text("Pemasukkan",
                      style: GoogleFonts.montserrat(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Color.fromARGB(255, 123, 17, 10))),
                  leading: Column(
                    mainAxisAlignment: MainAxisAlignment.center,

                    ///Untuk mengatur ikon ke tengah vertikal
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
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 123, 17, 10),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      spreadRadius: 7,
                      blurRadius: 10,
                      offset: const Offset(1, 1),
                      color: Colors.black.withOpacity(0.2),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(15),
                height: 400,
                width: 350,
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,

                      ///Menempatkan teks di pojok kiri atas
                      child: Text(
                        "Tambah Pemasukkan",
                        style: GoogleFonts.montserrat(
                          color: Colors.white,

                          ///Warna teks
                          fontSize: 17,

                          ///Ukuran teks
                          fontWeight: FontWeight.bold,

                          ///Ketebalan teks
                        ),
                      ),
                    ),
                    SizedBox(height: 25),
                    Row(
                      children: [
                        ///Nama label di sebelah kiri
                        Text(
                          'Jumlah',
                          style: GoogleFonts.montserrat(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w500),
                        ),
                        SizedBox(width: 50),
                        Expanded(
                          child: Container(
                            width: 200,

                            ///Atur lebar sesuai diinginkan
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                fillColor: Colors.white,
                                filled: true,
                                hintText: "Amount",
                                focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.white, width: 1.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                    color: Colors.white,
                                    width: 1.0,
                                  ),
                                ),
                              ),
                              onChanged: (value) {
                                amount = double.tryParse(value);

                                ///Parse string to double
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please enter the amount";
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 15),
                    Row(
                      children: [
                        ///Nama label di sebelah kiri
                        Text(
                          'Tanggal',
                          style: GoogleFonts.montserrat(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w500),
                        ),
                        SizedBox(width: 48),
                        Expanded(
                          child: Container(
                            width: 200,

                            ///Atur lebar sesuai
                            child: TextFormField(
                              controller: date,
                              decoration: InputDecoration(
                                fillColor: Colors.white,
                                filled: true,
                                hintText: "Transaction Date",
                                focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.white, width: 1.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
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
                                  String datepicked = DateFormat('dd-MMMM-yyyy')
                                      .format(pickedDate);

                                  setState(() {
                                    date.text = datepicked;
                                    transactionDate = datepicked;

                                    ///Menetapkan pickedDate langsung
                                  });
                                }
                              },
                              onChanged: (value) {
                                ///Remove onChanged for date, as it is not needed
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please enter the animal birth date";
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 15),
                    Row(
                      children: [
                        ///Nama label di sebelah kiri
                        Text(
                          'Deskripsi',
                          style: GoogleFonts.montserrat(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w500),
                        ),
                        SizedBox(width: 40),
                        Expanded(
                          child: Container(
                            width: 200,

                            ///Atur lebar sesuai yang diinginkan
                            child: TextFormField(
                              decoration: InputDecoration(
                                fillColor: Colors.white,
                                filled: true,
                                hintText: "Description",
                                focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.white, width: 1.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                    color: Colors.white,
                                    width: 1.0,
                                  ),
                                ),
                              ),
                              onChanged: (value) {
                                description = value;

                                ///Parse string to double
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please enter the amount";
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.only(left: 90),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red.shade500,
                              minimumSize: Size(100, 45),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            onPressed: () {
                              Navigator.pop(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => HomePage()));
                            },
                            child: Text("Batal",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),
                        SizedBox(width: 5),

                        /// Memberikan jarak antara tombol
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            minimumSize: Size(100, 45),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          onPressed: () {
                            if (formkey.currentState!.validate()) {
                              PemasukanModel pm = PemasukanModel(
                                amount: amount!,
                                transactionDate: transactionDate!,
                                description: description!,
                              );
                              pc.addPemasukan(pm);

                              ///menampilkan pesan apabila isian sudah sesuai
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content:
                                          Text('Data berhasil ditambahkan')));

                              ///mengalihkan ke halaman AnimalData
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HomePage()),
                              );
                            }
                          },
                          icon: Icon(Icons.save, color: Colors.black, size: 20),

                          ///Ganti ikon sesuai kebutuhan
                          label: Text(
                            "Simpan",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),

                          ///Ganti teks sesuai kebutuhan
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
