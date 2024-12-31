import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class AddProductState {
  final List<XFile> productImages;
  final String? selectedCategory;
  final int selectedTransactionTab;
  final bool useCurrentContact;

  AddProductState({
    this.productImages = const [],
    this.selectedCategory,
    this.selectedTransactionTab = 0,
    this.useCurrentContact = true,
  });

  AddProductState copyWith({
    List<XFile>? productImages,
    String? selectedCategory,
    int? selectedTransactionTab,
    bool? useCurrentContact,
  }) {
    return AddProductState(
      productImages: productImages ?? this.productImages,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      selectedTransactionTab: selectedTransactionTab ?? this.selectedTransactionTab,
      useCurrentContact: useCurrentContact ?? this.useCurrentContact,
    );
  }
}

class AddProductCubit extends Cubit<AddProductState> {
  AddProductCubit() : super(AddProductState());

  Future<void> pickImages() async {
    final picker = ImagePicker();
    final pickedFiles = await picker.pickMultiImage();
    if (pickedFiles != null) {
      emit(state.copyWith(productImages: pickedFiles));
    }
  }

  void changeCategory(String? category) {
    emit(state.copyWith(selectedCategory: category));
  }

  void changeTransactionTab(int tab) {
    emit(state.copyWith(selectedTransactionTab: tab));
  }

  void toggleUseCurrentContact(bool value) {
    emit(state.copyWith(useCurrentContact: value));
  }
}
