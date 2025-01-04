import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

@immutable
abstract class AddProductState {}

class AddProductInitial extends AddProductState {}

class AddProductImagesUploaded extends AddProductState {
  final List<String> imageUrls; // A list of URLs
  AddProductImagesUploaded(this.imageUrls);
}

class AddProductImagesPicked extends AddProductState {
  final List<XFile> productImages; // A list of picked images
  AddProductImagesPicked(this.productImages);
}

class AddProductCategoryChanged extends AddProductState {}

class AddProductTransactionTabChanged extends AddProductState {}

class AddProductUseCurrentContactChanged extends AddProductState {}

class AddProductLoading extends AddProductState {}

class AddProductSuccess extends AddProductState {}

class AddProductError extends AddProductState {
  final String errorMessage;
  AddProductError(this.errorMessage);
}

class AddProductFinalizationComplete extends AddProductState {
  AddProductFinalizationComplete();
}
