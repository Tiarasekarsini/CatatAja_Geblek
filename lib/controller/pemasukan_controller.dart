import 'dart:async';

import 'package:catataja_geblek/model/pemasukan_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PemasukanController {
  /// deklarasi collection di firebase
  final pemasukanCollection =
      FirebaseFirestore.instance.collection('pemasukan');

  final StreamController<List<DocumentSnapshot>> streamController =
      StreamController<List<DocumentSnapshot>>.broadcast();

  final StreamController<double> totalPendapatanController =
      StreamController<double>.broadcast();

  Stream<List<DocumentSnapshot>> get stream => streamController.stream;
  Stream<double> get totalPendapatanStream => totalPendapatanController.stream;

  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _subscription;

  /// membuat method agar total pemasukan auto terupdated
  void initPemasukanListener(DateTime selectedMonth) {
    _subscription = pemasukanCollection.snapshots().listen((querySnapshot) {
      _hitungTotalPemasukan(selectedMonth);
    });
  }

  void cancelPemasukanListener() {
    _subscription?.cancel();
  }

  /// membuat method untuk menambahkan data pemasukan
  Future<void> addPemasukan(PemasukanModel pmModel) async {
    final pemasukan = pmModel.toMap();
    final DocumentReference docRef = await pemasukanCollection.add(pemasukan);
    final String docId = docRef.id;

    final PemasukanModel pemasukanModel = PemasukanModel(
      id: docId,
      amount: pmModel.amount,
      transactionDate: pmModel.transactionDate,
      description: pmModel.description,
    );

    await docRef.update(pemasukanModel.toMap());
  }

  /// membuat method untuk menampilkan data pemasukan berdasarkan tanggal yang dipilih oleh pengguna
  Future getPemasukan(DateTime selectedDate) async {
    final pemasukan = await pemasukanCollection
        .where('transactionDate', isEqualTo: selectedDate)
        .get();
    streamController.sink.add(pemasukan.docs);
    return pemasukan.docs;
  }

  /// membuat method untuk mengedit data pemasukan

  Future<void> editPemasukan(PemasukanModel pmModel) async {
    var document = pemasukanCollection.doc(pmModel.id);

    final PemasukanModel pemasukanModel = PemasukanModel(
      id: pmModel.id,
      amount: pmModel.amount,
      transactionDate: pmModel.transactionDate,
      description: pmModel.description,
    );

    await document.update(pemasukanModel.toMap());
  }

  /// membuat method untuk menghapus data pemasukan
  Future<void> delPemasukan(String id) async {
    var document = pemasukanCollection.doc(id);
    var DocumentSnapshot = await document.get();

    if (DocumentSnapshot.exists) {
      await document.delete();
    } else {
      throw Exception('Failed to delete data');
    }
  }

  /// membuat method untuk menampilkan total pemasukan berdasarkan bulan yang dipilih oleh pengguna
  Future<String> getTotalPemasukan(DateTime selectedMonth) async {
    try {
      final pemasukan = await pemasukanCollection
          .where('transactionDate', isEqualTo: selectedMonth)
          .get();
      double total = 0;

      pemasukan.docs.forEach((doc) {
        PemasukanModel pesananModel =
            PemasukanModel.fromMap(doc.data() as Map<String, dynamic>);
        double harga = pesananModel.amount ?? 0;
        total += harga;
      });

      return total.toStringAsFixed(2);
    } catch (e) {
      print('Error while getting total pendapatan: $e');
      return '0';
    }
  }

  Future<void> _hitungTotalPemasukan(DateTime selectedMonth) async {
    try {
      String value = await getTotalPemasukan(selectedMonth);
      double total = double.parse(value);
      totalPendapatanController.sink.add(total);
    } catch (e) {
      print('Error while calculating total pendapatan: $e');
    }
  }
}
