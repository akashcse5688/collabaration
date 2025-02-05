import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:restapi/product_model.dart';

class UpdateProduct extends StatefulWidget {
  const UpdateProduct({super.key, required this.product});
  final ProductModel product;
  @override
  State<StatefulWidget> createState() => _UpdateProduct();
}

class _UpdateProduct extends State<UpdateProduct> {
  final TextEditingController _nameTEController = TextEditingController();
  final TextEditingController _codeTEController = TextEditingController();
  final TextEditingController _priceTEController = TextEditingController();
  final TextEditingController _quantityTEController = TextEditingController();
  final TextEditingController _totalPriceTEController = TextEditingController();
  final TextEditingController _imageTEController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _updateProductInProgress=false;


  @override
  void initState() {
    super.initState();
    _nameTEController.text = widget.product.productName ?? '';
    _codeTEController.text = widget.product.productCode ?? '';
    _priceTEController.text = widget.product.unitPrice ?? '';
    _quantityTEController.text = widget.product.quantity ?? '';
    _totalPriceTEController.text = widget.product.totalPrice ?? '';
    _imageTEController.text = widget.product.image ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Product Screen'),
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
                  visible: _updateProductInProgress == false,
                  replacement: const Center(
                    child: CircularProgressIndicator(),
                  ),
                  child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _updateProduct();
                        }
                      },
                      child: const Text("Update")),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _updateProduct() async{
    _updateProductInProgress=true;
    setState(() {});

    String updateProductUrl = "https://crud.teamrabbil.com/api/v1/UpdateProduct/${widget.product.id}";
    Uri uri=Uri.parse(updateProductUrl);

    Map<String, dynamic>inputData = {
      "ProductName": _nameTEController.text,
      "ProductCode": _codeTEController.text,
      "Img": _imageTEController.text.trim(),
      "Qty": _quantityTEController.text,
      "UnitPrice": _priceTEController.text,
      "TotalPrice": _totalPriceTEController.text
    };
    Response response=await post(uri,body: jsonEncode(inputData),headers: { 'content-type':'application/json'});

    _updateProductInProgress = false;
    setState(() {});

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Update Product successful")));
      Navigator.pop(context,true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Update Product failed! try again")));
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