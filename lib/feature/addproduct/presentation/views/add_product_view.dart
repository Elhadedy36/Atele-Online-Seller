import 'dart:io';

import 'package:atele_seller/core/functions/custom_appbar.dart';
import 'package:atele_seller/feature/addproduct/presentation/cubit/addproduct_cubit.dart';
import 'package:atele_seller/feature/addproduct/presentation/cubit/addproduct_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddProductView extends StatelessWidget {
  const AddProductView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(title: 'Product Details'),
      body: BlocProvider(
        create: (_) => AddProductCubit(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: BlocConsumer<AddProductCubit, AddProductState>(
            listener: (context, state) {
              if (state is AddProductImagesPicked) {
                // Handle image selection if needed
              }
            },
            builder: (context, state) {
              final cubit = context.read<AddProductCubit>();
              final formKey = context.read<AddProductCubit>().formKey;
              return Form(
                key: formKey,
                child: ListView(
                  children: [
                    const SectionTitle(title: 'Product Information'),
                    CustomTextField(
                      controller: cubit.productNameController,
                      label: 'Product Name',
                      hint: 'Enter the product name',
                      validator: (value) => value == null || value.isEmpty ? 'Product name is required' : null,
                    ),
                    CustomTextField(
                      controller: cubit.descriptionController,
                      label: 'Description',
                      hint: 'Enter a detailed description',
                      maxLines: 4,
                      validator: (value) => value == null || value.isEmpty ? 'Description is required' : null,
                    ),
                    DropdownButtonFormField<String>(
                      items: const [
                        DropdownMenuItem(value: 'Wedding Dresses', child: Text('Wedding Dresses')),
                        DropdownMenuItem(value: 'Evening Dresses', child: Text('Evening Dresses')),
                      ],
                      onChanged: cubit.setCategory,
                      value: cubit.selectedCategory,
                      decoration: const InputDecoration(
                        labelText: 'Category',
                        hintText: 'Select category',
                      ),
                      validator: (value) => value == null || value.isEmpty ? 'Category is required' : null,
                    ),
                    const SectionTitle(title: 'Sale or Rent'),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () => cubit.setTransactionTab(0),
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                decoration: BoxDecoration(
                                  color: cubit.selectedTransactionTab == 0 ? Colors.black : Colors.transparent,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Text(
                                  'Sale',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () => cubit.setTransactionTab(1),
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                decoration: BoxDecoration(
                                  color: cubit.selectedTransactionTab == 1 ? Colors.black : Colors.transparent,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Text(
                                  'Rent',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SectionTitle(title: 'Images'),
                    GestureDetector(
                      onTap: () => cubit.pickImages(),
                      child: Container(
                        height: 150,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: cubit.productImages.isEmpty
                            ? const Center(child: Text('Tap to pick product images', style: TextStyle(color: Colors.grey)))
                            : GridView.builder(
                                shrinkWrap: true,
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 4,
                                  mainAxisSpacing: 4,
                                ),
                                itemCount: cubit.productImages.length,
                                itemBuilder: (context, index) => Image.file(
                                  File(cubit.productImages[index].path),
                                  fit: BoxFit.cover,
                                ),
                              ),
                      ),
                    ),
                    const SectionTitle(title: 'Pricing'),
                    CustomTextField(
                      controller: cubit.priceController,
                      label: 'Price',
                      hint: 'Enter the price',
                      keyboardType: TextInputType.number,
                      validator: (value) => value == null || value.isEmpty ? 'Price is required' : null,
                    ),
                    // if (cubit.selectedTransactionTab == 1)
                      CustomTextField(
                        controller: cubit.depositAmountController,
                        label: 'Deposit Amount',
                        hint: 'Enter deposit amount',
                        keyboardType: TextInputType.number,
                        validator: (value) => value == null || value.isEmpty ? 'Deposit amount is required' : null,
                      ),
                    const SectionTitle(title: 'Stock and Availability'),
                    CustomTextField(
                      controller: cubit.stockController,
                      label: 'Stock',
                      hint: 'Enter stock quantity',
                      keyboardType: TextInputType.number,
                      validator: (value) => value == null || value.isEmpty ? 'Stock is required' : null,
                    ),
                    const SectionTitle(title: 'Contact Details'),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Use Current Contact Details', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                        Switch(
                          value: cubit.useCurrentContact,
                          activeColor: Colors.black,
                          onChanged: cubit.toggleUseCurrentContact,
                        ),
                      ],
                    ),
                    if (!cubit.useCurrentContact)
                      CustomTextField(
                        controller: cubit.phoneNumberController,
                        label: 'Phone Number',
                        hint: 'Enter your phone number',
                        keyboardType: TextInputType.phone,
                        validator: (value) => value == null || value.isEmpty ? 'Phone number is required' : null,
                      ),
                    if (!cubit.useCurrentContact)
                      CustomTextField(
                        controller: cubit.addressController,
                        label: 'Address',
                        hint: 'Enter your address',
                        validator: (value) => value == null || value.isEmpty ? 'Address is required' : null,
                      ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: ElevatedButton(
                        onPressed: () => cubit.addProduct(),
                        child: const Text('Submit Product'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;
  const SectionTitle({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
    );
  }
}
class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final int? maxLines;
  final TextInputType keyboardType;
  final FormFieldValidator<String>? validator;

  const CustomTextField({
    Key? key,
    required this.controller,
    required this.label,
    required this.hint,
    this.maxLines = 1,
    this.keyboardType = TextInputType.text,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
        validator: validator,
        onTap: () {
          // Ensure focus when tapped

        },
      ),
    );
  }
}
