import 'package:atele_seller/core/utils/app_strings.dart';
import 'package:atele_seller/feature/addproduct/presentation/cubit/addproduct_state.dart';
import 'package:atele_seller/feature/auth/data/seller_model.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';


class AddProductCubit extends Cubit<AddProductState> {
  AddProductCubit() : super(AddProductInitial());

  final TextEditingController productNameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController depositAmountController = TextEditingController();
  final TextEditingController stockController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  List<XFile> productImages = [];
  String? selectedCategory;
  int selectedTransactionTab = 0; // 0: Sale, 1: Rent
  bool useCurrentContact = true;

  Future<void> pickImages() async {
    final picker = ImagePicker();
    final pickedFiles = await picker.pickMultiImage();
    if (pickedFiles != null) {
      emit(AddProductImagesPicked(pickedFiles));
    }
  }

  void setCategory(String? category) {
    selectedCategory = category;
    emit(AddProductCategoryChanged());
  }

  void setTransactionTab(int tabIndex) {
    selectedTransactionTab = tabIndex;
    emit(AddProductTransactionTabChanged());
  }

  void toggleUseCurrentContact(bool value) {
    useCurrentContact = value;
    emit(AddProductUseCurrentContactChanged());
  }

  void submitForm(GlobalKey<FormState> formKey, BuildContext context) {
    if (formKey.currentState!.validate()) {
      // Implement form submission logic (e.g., saving to database or API)
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Product added successfully!')),
      );
    }
  }

CollectionReference _firestoreAddProduct = FirebaseFirestore.instance.collection(FirebaseStrings.products);
CollectionReference _firestoreAddSellerProduct = FirebaseFirestore.instance.collection(FirebaseStrings.sellers).doc(FirebaseAuth.instance.currentUser!.uid).collection(FirebaseStrings.products);
Future<void> addProduct() async {
  try {
    // Get the current seller's ID
    String sellerId = FirebaseAuth.instance.currentUser!.uid;

    // Fetch seller data from Firestore
    DocumentSnapshot sellerDoc = await FirebaseFirestore.instance
        .collection(FirebaseStrings.sellers)
        .doc(sellerId)
        .get();

    // Check if the seller document exists
    if (sellerDoc.exists) {
      // Parse the seller data into a SellerModel
      SellerModel sellerData = SellerModel.fromJson(sellerDoc.data() as Map<String, dynamic>);
      double price = double.tryParse(priceController.text) ?? 0.0;
      double depositAmount = double.tryParse(depositAmountController.text) ?? 0.0;

      // Generate a new document ID for the product
      String productId = _firestoreAddProduct.doc().id;

      // Prepare the product data
      Map<String, dynamic> productData = {
        FirebaseStrings.productName: productNameController.text,
        FirebaseStrings.productDescription: descriptionController.text,
        FirebaseStrings.price: price,
        FirebaseStrings.depositeAmount: depositAmount,
        FirebaseStrings.stock: int.tryParse(stockController.text) ?? 0,
        FirebaseStrings.phoneNumber: useCurrentContact ? sellerData.phoneNumber : phoneNumberController.text,
        FirebaseStrings.address: useCurrentContact ? sellerData.location : addressController.text,
        FirebaseStrings.categoryName: selectedCategory,
        FirebaseStrings.isForRent: selectedTransactionTab == 0 ? false : true,
        FirebaseStrings.productsImages:
            'https://firebasestorage.googleapis.com/v0/b/dalel-ca09b.appspot.com/o/Atele%20Online%2FApp%20Images%2FWhatsApp%20Image%202024-12-13%20at%2003.52.47_7eca10ed.jpg?alt=media&token=32a71ee3-3a47-47b4-80c0-d94b1fdc5782',
        FirebaseStrings.sellerId: sellerId,
        FirebaseStrings.ateleName: sellerData.ateleName,
        FirebaseStrings.productId: productId,
      };

      // Add the product to the global "Products" collection with the same ID
      await _firestoreAddProduct.doc(productId).set(productData);

      // Add the product to the seller's "Products" subcollection with the same ID
      await _firestoreAddSellerProduct.doc(productId).set(productData);

      // Clear form fields
      productNameController.clear();
      descriptionController.clear();
      priceController.clear();
      depositAmountController.clear();
      stockController.clear();
      phoneNumberController.clear();
      addressController.clear();
      selectedCategory = null;
      selectedTransactionTab = 0;
      useCurrentContact = true;

      emit(AddProductSuccess());
      print('Product added successfully!');
    } else {
      emit(AddProductError('Seller data not found.'));
      print('Error: Seller document does not exist.');
    }
  } catch (e) {
    emit(AddProductError(e.toString()));
    print('Error adding product: $e');
  }
}


// }
// final CollectionReference _firestoreGetSellerData =
//       FirebaseFirestore.instance.collection('Sellers');

//   Future<SellerModel?> getSellerData(String sellerId) async {
//     try {
//       // Fetch the seller document by ID      
//       final DocumentSnapshot doc = await _firestoreGetSellerData.doc(sellerId).get();

//       if (doc.exists) {
//         // Parse the document data into a SellerModel
//         return SellerModel.fromJson(doc.data() as Map<String, dynamic>);
//       } else {
//         // Handle case where seller does not exist
//         print('Seller not found');
//         return null;
//       }
//     } catch (e) {
//       // Handle errors
//       print('Error fetching seller data: $e');
//       return null;
//     }

   

}
