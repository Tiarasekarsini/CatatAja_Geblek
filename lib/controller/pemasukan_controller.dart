import 'dart:async';

import 'package:catataja_geblek/model/pemasukan_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PemasukanController {
  final pemasukanCollection =
      FirebaseFirestore.instance.collection('pemasukan');

  final StreamController<List<DocumentSnapshot>> streamController =
      StreamController<List<DocumentSnapshot>>.broadcast();

  Stream<List<DocumentSnapshot>> get stream => streamController.stream;

  ///membuat method untuk menambahkan data pemasukan
  Future<void> addPemasukan(PemasukanModel pmModel) async {
    ///mengubah objek AnimalModel menjadi Map
    final pemasukan = pmModel.toMap();

    ///metode untuk menambahkan data ke collection dan mengembalikan nilai ref dokumen
    final DocumentReference docRef = await pemasukanCollection.add(pemasukan);

    final String docId = docRef.id;

    ///membuat objek untuk menjaga data yang telah disimpan di Firestore
    final PemasukanModel pemasukanModel = PemasukanModel(
      id: docId,
      amount: pmModel.amount,
      transactionDate: pmModel.transactionDate,
      description: pmModel.description,
      // createdAt: pmModel.createdAt,
      // updatedAt: pmModel.updatedAt,
    );

    await docRef.update(pemasukanModel.toMap());
  }

  ///membuat metode untuk mengambil/menampilkan data yang tersimpan di firestore
  Future getPemasukan() async {
    final pemasukan =
        await pemasukanCollection.orderBy('transactionDate').get();
    streamController.sink.add(pemasukan.docs);
    return pemasukan.docs;
  }

  ///membuat metode untuk mengubah data animal
  Future<void> editPemasukan(PemasukanModel pmModel) async {
    var document = pemasukanCollection.doc(pmModel.id);

    final PemasukanModel animalModel = PemasukanModel(
      id: pmModel.id,
      amount: pmModel.amount,
      transactionDate: pmModel.transactionDate,
      description: pmModel.description,
    );

    await document.update(animalModel.toMap());
  }
}
