import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({super.key});

  @override
  State<StatefulWidget> createState() => _AddProduct();
}

class _AddProduct extends State<AddProduct> {
  final TextEditingController _nameTEController = TextEditingController();
  final TextEditingController _codeTEController = TextEditingController();
  final TextEditingController _priceTEController = TextEditingController();
  final TextEditingController _quantityTEController = TextEditingController();
  final TextEditingController _totalPriceTEController = TextEditingController();
  final TextEditingController _imageTEController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _addNewProductInProgress=false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Product Screen'),
        centerTitle: true,
        backgroundColor: Colors.amber,
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _nameTEController,
                  decoration: const InputDecoration(
                    hintText: "Product Name",
                    labelText: "Product Name",
                  ),
                  validator: (String? value) {
                    if (value == null || value.trim().isEmpty) {
                      return "write your product Name";
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 16,
                ),

                TextFormField(
                  controller: _codeTEController,
                  decoration: const InputDecoration(
                    hintText: "Product Code",
                    labelText: "Product Code",
                  ),
                  validator: (String? value) {
                    if (value == null || value.trim().isEmpty) {
                      return "write your product Code";
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 16,
                ),

                TextFormField(
                  controller: _priceTEController,
                  decoration: const InputDecoration(
                    hintText: "Unit Price",
                    labelText: "Unit Price",
                  ),
                  validator: (String? value) {
                    if (value == null || value.trim().isEmpty) {
                      return "write your produce price";
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 16,
                ),

                TextFormField(
                  controller: _quantityTEController,
                  decoration: const InputDecoration(
                    hintText: "Quantity",
                    labelText: "Quantity",
                  ),
                  validator: (String? value) {
                    if (value == null || value.trim().isEmpty) {
                      return "write your quantity";
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 16,
                ),

                TextFormField(
                  controller: _totalPriceTEController,
                  decoration: const InputDecoration(
                    hintText: "Total Price",
                    labelText: "Total price",
                  ),
                  validator: (String? value) {
                    if (value == null || value.trim().isEmpty) {
                      return "write total Price";
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 16,
                ),

                TextFormField(
                  controller: _imageTEController,
                  decoration: const InputDecoration(
                    hintText: "Image.png",
                    labelText: "Image",
                  ),
                  validator: (String? value) {
                    if (value == null || value.trim().isEmpty) {
                      return "write image url";
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 16,
                ),

                Visibility(
                  visible: _addNewProductInProgress == false,
                  replacement: const Center(
                    child: CircularProgressIndicator(),
                  ),
                  child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _addProduct();
                        }
                      },
                      child: const Text("Add")),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _addProduct() async{
    _addNewProductInProgress=true;
    setState(() {});

    const String addNewProductUrl = "https://crud.teamrabbil.com/api/v1/CreateProduct";
    Uri uri=Uri.parse(addNewProductUrl);

    Map<String, dynamic>inputData = {
      "ProductName": _nameTEController.text,
      "ProductCode": _codeTEController.text,
      "Img": _imageTEController.text.trim(),
      "Qty": _quantityTEController.text,
      "UnitPrice": _priceTEController.text,
      "TotalPrice": _totalPriceTEController.text
    };
    Response response=await post(uri,body: jsonEncode(inputData),headers: { 'content-type':'application/json'});

    _addNewProductInProgress = false;
    setState(() {});

    if (response.statusCode == 200) {
      _nameTEController.clear();
      _priceTEController.clear();
      _codeTEController.clear();
      _quantityTEController.clear();
      _totalPriceTEController.clear();
      _imageTEController.clear();
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("New Product added")));
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Add New Product failed! try again")));
    }
  }

  @override
  void dispose() {
    _nameTEController.dispose();
    _priceTEController.dispose();
    _codeTEController.dispose();
    _quantityTEController.dispose();
    _totalPriceTEController.dispose();
    _imageTEController.dispose();
    super.dispose();
  }
}