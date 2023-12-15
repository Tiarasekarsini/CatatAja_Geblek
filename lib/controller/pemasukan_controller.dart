import 'dart:async';

import 'package:catataja_geblek/model/pemasukan_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PemasukanController {
  final pemasukanCollection =
      FirebaseFirestore.instance.collection('pemasukan');

  final StreamController<List<DocumentSnapshot>> streamController =
      StreamController<List<DocumentSnapshot>>.broadcast();

  final StreamController<double> totalPendapatanController =
      StreamController<double>.broadcast();

  Stream<List<DocumentSnapshot>> get stream => streamController.stream;
  Stream<double> get totalPendapatanStream => totalPendapatanController.stream;

  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _subscription;

  void initPemasukanListener(DateTime selectedMonth) {
    _subscription = pemasukanCollection.snapshots().listen((querySnapshot) {
      _hitungTotalPemasukan(selectedMonth);
    });
  }

  void cancelPemasukanListener() {
    _subscription?.cancel();
  }

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

  Future getPemasukan(DateTime selectedDate) async {
    final pemasukan = await pemasukanCollection
        .where('transactionDate', isEqualTo: selectedDate)
        .get();
    streamController.sink.add(pemasukan.docs);
    return pemasukan.docs;
  }

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

  Future<void> delPemasukan(String id) async {
    var document = pemasukanCollection.doc(id);
    var DocumentSnapshot = await document.get();

    if (DocumentSnapshot.exists) {
      await document.delete();
    } else {
      throw Exception('Failed to delete data');
    }
  }

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
      // Handle the error appropriately, e.g., show an error message.
    }
  }
}
