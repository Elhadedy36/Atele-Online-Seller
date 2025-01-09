import 'dart:io';
import 'package:atele_seller/core/utils/app_strings.dart';
import 'package:atele_seller/feature/addproduct/presentation/cubit/addproduct_state.dart';
import 'package:atele_seller/feature/auth/data/seller_model.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

// Global variable to store finalized image URLs
List<String> realImageList = [];

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
  List<XFile> productImagesList = [];
  String? selectedCategory;
  int selectedTransactionTab = 0; // 0: Sale, 1: Rent
  bool useCurrentContact = true;
  FirebaseStorage fireStorage = FirebaseStorage.instance;
  final _picker = ImagePicker();
  String? tempProductId;

  // Method to pick images
  Future<void> pickImages() async {
    try {
      final pickedImages = await _picker.pickMultiImage();
      if (pickedImages != null) {
        productImagesList.clear();
        productImagesList.addAll(pickedImages);
        emit(AddProductImagesPicked(productImagesList));
      }
    } catch (error) {
      emit(AddProductError("Failed to pick images: $error"));
    }
  }

  // Method to upload images with unique names
  Future<void> uploadImages() async {
    try {
      final String userId = FirebaseAuth.instance.currentUser!.uid;
      tempProductId ??= Uuid().v4();
      final String productTempFolder = "$userId/images/$tempProductId";
      final List<String> imageUrls = [];

      for (var image in productImagesList) {
        final timestamp = DateTime.now().millisecondsSinceEpoch;
        final fileName = "${Uuid().v4()}_$timestamp.jpg";
        final imagePath = "$productTempFolder/$fileName";

        final imageRef = fireStorage.ref().child(imagePath);
        await imageRef.putFile(File(image.path));
        final imageUrl = await imageRef.getDownloadURL();
        imageUrls.add(imageUrl);
      }

      emit(AddProductImagesUploaded(imageUrls));
    } catch (error) {
      emit(AddProductError("Failed to upload images: $error"));
    }
  }

  // Finalize product creation and move images to final folder
  Future<void> finalizeProductCreation(String newProductId) async {
    if (tempProductId != null) {
      try {
        final String userId = FirebaseAuth.instance.currentUser!.uid;
        final tempFolderRef = fireStorage.ref("$userId/images/$tempProductId");
        final ListResult listResult = await tempFolderRef.listAll();
        final newProductFolderRef =
            fireStorage.ref("$userId/images/$newProductId");

        realImageList.clear();

        for (Reference fileRef in listResult.items) {
          final String newPath = "$userId/images/$newProductId/${fileRef.name}";
          final fileBytes = await fileRef.getData();

          if (fileBytes != null) {
            final newFileRef = newProductFolderRef.child(fileRef.name);
            await newFileRef.putData(fileBytes);
            final newFileUrl = await newFileRef.getDownloadURL();
            realImageList.add(newFileUrl);
            await fileRef.delete();
          }

          print("File moved to: $newPath");
        }

        print("Images moved and URLs added to realImageList: $realImageList");
        emit(AddProductFinalizationComplete());
      } catch (error) {
        emit(AddProductError("Error finalizing product creation: $error"));
      }
    } else {
      emit(AddProductError("No temporary product ID found."));
    }
  }

  // Set category
  void setCategory(String? category) {
    selectedCategory = category;
    emit(AddProductCategoryChanged());
  }

  // Set transaction tab (Sale or Rent)
  void setTransactionTab(int tabIndex) {
    selectedTransactionTab = tabIndex;
    emit(AddProductTransactionTabChanged());
  }

  // Toggle use current contact information
  void toggleUseCurrentContact(bool value) {
    useCurrentContact = value;
    emit(AddProductUseCurrentContactChanged());
  }

  // Submit form
  void submitForm(GlobalKey<FormState> formKey, BuildContext context) {
    if (formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Product added successfully!')),
      );
    }
  }

  // Firestore reference for products and seller's products
  final CollectionReference _firestoreAddProduct =
      FirebaseFirestore.instance.collection(FirebaseStrings.products);
  final CollectionReference _firestoreAddSellerProduct = FirebaseFirestore
      .instance
      .collection(FirebaseStrings.sellers)
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection(FirebaseStrings.products);

  // Method to add product to Firestore
  Future<void> addProduct() async {
    try {
      String sellerId = FirebaseAuth.instance.currentUser!.uid;
      DocumentSnapshot sellerDoc = await FirebaseFirestore.instance
          .collection(FirebaseStrings.sellers)
          .doc(sellerId)
          .get();

      if (sellerDoc.exists) {
        SellerModel sellerData =
            SellerModel.fromJson(sellerDoc.data() as Map<String, dynamic>);
        double price = double.tryParse(priceController.text) ?? 0.0;
        double depositAmount =
            double.tryParse(depositAmountController.text) ?? 0.0;
        String productId = _firestoreAddProduct.doc().id;
        await uploadImages();

        await finalizeProductCreation(productId);
        emit(AddProductLoading());
        Map<String, dynamic> productData = {
          FirebaseStrings.productName: productNameController.text,
          FirebaseStrings.productDescription: descriptionController.text,
          FirebaseStrings.price: price,
          FirebaseStrings.depositeAmount: depositAmount,
          FirebaseStrings.stock: int.tryParse(stockController.text) ?? 0,
          FirebaseStrings.phoneNumber: useCurrentContact
              ? sellerData.phoneNumber
              : phoneNumberController.text,
          FirebaseStrings.address:
              useCurrentContact ? sellerData.location : addressController.text,
          FirebaseStrings.categoryName: selectedCategory,
          FirebaseStrings.isForRent: selectedTransactionTab == 0 ? false : true,
          FirebaseStrings.productsImages: realImageList,
          FirebaseStrings.sellerId: sellerId,
          FirebaseStrings.ateleName: sellerData.ateleName,
          FirebaseStrings.productId: productId,
        };

        await _firestoreAddProduct.doc(productId).set(productData);
        await _firestoreAddSellerProduct.doc(productId).set(productData);

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
        productImagesList.clear();
        emit(AddProductSuccess());
      } else {
        emit(AddProductError('Seller data not found.'));
      }
    } catch (e) {
      emit(AddProductError(e.toString()));
    }
  }

  // Method to delete a product and its associated images folder
  Future<void> deleteProduct(String productId) async {
    try {
      final String userId = FirebaseAuth.instance.currentUser!.uid;

      // Reference to the product's images folder
      final folderRef = fireStorage.ref("$userId/images/$productId");

      // List all items in the folder
      final ListResult listResult = await folderRef.listAll();

      // Delete all files in the folder
      for (Reference fileRef in listResult.items) {
        await fileRef.delete();
      }

      // Delete the folder itself (if needed, Firebase Storage might handle this automatically)
      emit(ProductDeletedLoading());
      // Delete product data from Firestore
      await _firestoreAddProduct.doc(productId).delete();
      await _firestoreAddSellerProduct.doc(productId).delete();

      emit(ProductDeletedSuccess());
    } catch (error) {
      print("Error deleting product $productId: $error");
      emit(ProductDeletedError("Error deleting product: $error"));
    }
  }
}
