
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

@immutable
abstract class AddProductState {}

class AddProductInitial extends AddProductState {}

class AddProductImagesPicked extends AddProductState {
  final List<XFile> productImages;
  AddProductImagesPicked(this.productImages);
}

class AddProductCategoryChanged extends AddProductState {}

class AddProductTransactionTabChanged extends AddProductState {}

class AddProductUseCurrentContactChanged extends AddProductState {}
class AddProductLoading extends AddProductState {}
class AddProductSuccess extends AddProductState {}
class AddProductError extends AddProductState 
{
  final String errorMessage;
  AddProductError(this.errorMessage);
}