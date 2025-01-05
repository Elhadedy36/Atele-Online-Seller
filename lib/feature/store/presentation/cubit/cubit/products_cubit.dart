
import 'package:atele_seller/core/models/product_model.dart';
import 'package:atele_seller/core/utils/app_strings.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

part 'products_state.dart';class ProductsCubit extends Cubit<ProductsState> {
  ProductsCubit() : super(ProductsInitial());

  Stream<List<ProductModel>> getProductStream(String categoryName, bool isForRent) {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    return _firestore
        .collection(FirebaseStrings.sellers).doc(FirebaseAuth.instance.currentUser!.uid).collection(FirebaseStrings.products)
        .where(FirebaseStrings.categoryName, isEqualTo: categoryName)
        .where(FirebaseStrings.isForRent, isEqualTo: isForRent)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return ProductModel.fromJson(doc.data());
      }).toList();
    });
  }
}
