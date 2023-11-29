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

  ///membuat metode untuk mengubah data
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

  Future<void> delPemasukan(String id) async {
    var document = pemasukanCollection.doc(id);
    var DocumentSnapshot = await document.get();

    ///memeriksa apakah data yang akan dihapus ada/tidak
    if (DocumentSnapshot.exists) {
      /// proses delete jika data tersebut ada
      await document.delete();

      ///output apabila data yang akan dihapus tidak ditemukan
    } else {
      throw Exception('Failed to delete data');
    }
  }
}
