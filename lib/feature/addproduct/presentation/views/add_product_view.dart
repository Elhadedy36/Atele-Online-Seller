import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddProductView extends StatefulWidget {
  const AddProductView({super.key});

  @override
  _AddProductViewState createState() => _AddProductViewState();
}

class _AddProductViewState extends State<AddProductView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _depositAmountController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  List<XFile> _productImages = [];
  String? _selectedCategory;
  int _selectedTransactionTab = 0; // 0: Sale, 1: Rent
  bool _useCurrentContact = true;

  // Picking images
  Future<void> _pickImages() async {
    final picker = ImagePicker();
    final pickedFiles = await picker.pickMultiImage();
    if (pickedFiles != null) {
      setState(() {
        _productImages = pickedFiles;
      });
    }
  }

  // Handling form submission
  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      // Here you can handle form submission logic, such as sending data to an API or saving it locally
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Product added successfully!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Product', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const SectionTitle(title: 'Product Information'),
              CustomTextField(
                controller: _productNameController,
                label: 'Product Name',
                hint: 'Enter the product name',
                validator: (value) => value == null || value.isEmpty ? 'Product name is required' : null,
              ),
              CustomTextField(
                controller: _descriptionController,
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
  onChanged: (value) => setState(() {
    _selectedCategory = value;
  }),
  value: _selectedCategory,
  decoration: InputDecoration(
    labelText: 'Category',
    hintText: 'Select category',
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
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
                        onTap: () => setState(() {
                          _selectedTransactionTab = 0;
                        }),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          decoration: BoxDecoration(
                            color: _selectedTransactionTab == 0 ? Colors.black : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'Sale',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: _selectedTransactionTab == 0 ? Colors.white : Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() {
                          _selectedTransactionTab = 1;
                        }),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          decoration: BoxDecoration(
                            color: _selectedTransactionTab == 1 ? Colors.black : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'Rent',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: _selectedTransactionTab == 1 ? Colors.white : Colors.black,
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
                onTap: _pickImages,
                child: Container(
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: _productImages.isEmpty
                      ? const Center(
                          child: Text('Tap to pick product images', style: TextStyle(color: Colors.grey)),
                        )
                      : GridView.builder(
                          shrinkWrap: true,
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 4,
                            mainAxisSpacing: 4,
                          ),
                          itemCount: _productImages.length,
                          itemBuilder: (context, index) => Image.file(
                            File(_productImages[index].path),
                            fit: BoxFit.cover,
                          ),
                        ),
                ),
              ),
              const SectionTitle(title: 'Pricing'),
              CustomTextField(
                controller: _priceController,
                label: 'Price',
                hint: 'Enter the price',
                keyboardType: TextInputType.number,
                validator: (value) => value == null || value.isEmpty ? 'Price is required' : null,
              ),
              if (_selectedTransactionTab == 1) // Show deposit field for Rent only
                CustomTextField(
                  controller: _depositAmountController,
                  label: 'Deposit Amount',
                  hint: 'Enter deposit amount',
                  keyboardType: TextInputType.number,
                  validator: (value) => value == null || value.isEmpty ? 'Deposit amount is required' : null,
                ),
              const SectionTitle(title: 'Stock and Availability'),
              CustomTextField(
                controller: _stockController,
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
                    value: _useCurrentContact,
                    activeColor: Colors.black,
                    onChanged: (value) {
                      setState(() {
                        _useCurrentContact = value;
                      });
                    },
                  ),
                ],
              ),
              if (!_useCurrentContact)
                CustomTextField(
                  controller: _phoneNumberController,
                  label: 'Phone Number',
                  hint: 'Enter your phone number',
                  keyboardType: TextInputType.phone,
                  validator: (value) => value == null || value.isEmpty ? 'Phone number is required' : null,
                ),
              if (!_useCurrentContact)
                CustomTextField(
                  controller: _addressController,
                  label: 'Address',
                  hint: 'Enter your address',
                  validator: (value) => value == null || value.isEmpty ? 'Address is required' : null,
                ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: ElevatedButton(
                  onPressed: _submitForm,
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
      ),
    );
  }
}
