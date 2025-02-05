import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:restapi/Add_New_Products.dart';
import 'package:restapi/Update_Product.dart';
import 'package:restapi/product_model.dart';

class ProductList extends StatefulWidget {
  const ProductList({super.key});

  @override
  State<StatefulWidget> createState() {
    return _ProductList();
  }
}

class _ProductList extends State<ProductList> {
  bool _getProductListInProgress =false;
  List<ProductModel> productList = [];

  @override
  void initState() {
    super.initState();
    _getProductList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rest Api practice'),
        centerTitle: true,
        backgroundColor: Colors.amber,
      ),

      body: RefreshIndicator(
        onRefresh: _getProductList,

        child: Visibility(
          visible: _getProductListInProgress==false,
          replacement:const Center(
            child: CircularProgressIndicator(),
          ),
          child: ListView.builder(
            itemCount: productList.length,
            itemBuilder: (context, index) {
              return _buildProductItem(productList[index]);
            },
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton(onPressed: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => const AddProduct()));
        }, child:const Icon(Icons.add),),

    );
  }

  Future<void>_getProductList() async{
    _getProductListInProgress =true;
    setState(() {});
    productList.clear();

    const String productListReadUrl="https://crud.teamrabbil.com/api/v1/ReadProduct";
    Uri uri=Uri.parse(productListReadUrl);
    Response response=await get(uri);

    if(response.statusCode==200){
      final decodeData=jsonDecode(response.body);
      var jsonProductList=decodeData['data'];

      for(Map<String,dynamic>json in jsonProductList){
        ProductModel productModel = ProductModel.fromJson(
            id: json['_id'] ?? 'Unknown',
            productName: json['ProductName'] ?? 'Unknown',
            productCode: json['ProductCode'] ?? 'unknown',
            unitPrice: json['UnitPrice'] ?? 'Unknown',
            quantity: json['Qty'] ?? 'Unknown',
            totalPrice: json['TotalPrice'] ?? 'Unknown',
            image: json['Img'] ?? 'Unknown');
        productList.add(productModel);
      }
    }else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content:
              Text('Read Data Failed status Code :${response.statusCode}')));
    }
    _getProductListInProgress=false;
    setState(() {});

}

 Widget _buildProductItem(ProductModel product) {
    return Card(
      color: Colors.grey.shade200,
      child: ListTile(
        leading: Image.network(
          product.image ?? '',
          errorBuilder: (context, error, stackTrace) {
            return const SizedBox(
              width: 60,
              child: Icon(Icons.broken_image),
            );
          },
        ),

        title: Text(product.productName ?? 'Unknown'),
        subtitle: Wrap(
          spacing: 16,
          children: [
            Text("Product Code: ${product.productCode}"),
            Text("Unit Price: ${product.unitPrice}"),
            Text("Quantity: ${product.quantity}"),
            Text("Total Price: ${product.totalPrice}"),
          ],
        ),

        trailing: Wrap(
          children: [
            IconButton(onPressed: (){
              Navigator.push(context,MaterialPageRoute(builder: (context) =>UpdateProduct(product:product)));
            }, icon:const Icon(Icons.edit)),
            IconButton(onPressed: (){
              _showDeleteConfirmationButton(product.id!);
            }, icon:const Icon(Icons.delete)),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmationButton(String productId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Delete"),
          content: const Text("Are you sure you want to delete this product?"),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Cancel")),
            TextButton(
                onPressed: () {
                  _deleteProduct(productId);
                  Navigator.pop(context);
                },
                child: const Text("Yes, confirm"))
          ],
        );
      },
    );
  }

  Future<void> _deleteProduct(String productId) async {
    _getProductListInProgress = true;
    setState(() {});
    String deleteProductUrl =
        "https://crud.teamrabbil.com/api/v1/DeleteProduct/$productId";
    Uri uri = Uri.parse(deleteProductUrl);
    Response response = await get(uri);

    if (response.statusCode == 200) {
      _getProductList();
    } else {
      _getProductListInProgress = false;
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Delete Product failed!")));
    }
  }
}
