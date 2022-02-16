import 'package:flutter/material.dart';
import 'package:food_restaurant/helpers/style.dart';
import 'package:food_restaurant/providers/app.dart';
import 'package:food_restaurant/providers/category_provider.dart';
import 'package:food_restaurant/providers/products_provider.dart';
import 'package:food_restaurant/providers/user_provider.dart';
import 'package:food_restaurant/widgets/custom_file_button.dart';
import 'package:food_restaurant/widgets/custom_text.dart';
import 'package:food_restaurant/widgets/loading.dart';

import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class AddProductScreen extends StatefulWidget {
  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _key = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductsProvider>(context);
    final categoryProvider = Provider.of<CategoryProvider>(context);
    final appProvider = Provider.of<AppProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      key: _key,
      appBar: AppBar(
          iconTheme: const IconThemeData(color: black),
          centerTitle: true,
          elevation: 0.0,
          backgroundColor: white,
          title: const Text(
            "Add Product",
            style: TextStyle(color: black),
          )),
      body: appProvider.isLoading
          ? Loading()
          : ListView(
              children: [
                const SizedBox(height: 10),
                SizedBox(
                  height: 130,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        child: productProvider.productImage == null
                            ? CustomFileUploadButton(
                                icon: Icons.image,
                                text: "Add image",
                                onTap: () async {
                                  showModalBottomSheet(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return Wrap(
                                          children: [
                                            ListTile(
                                                leading:
                                                    const Icon(Icons.image),
                                                title:
                                                    const Text('From gallery'),
                                                onTap: () async {
                                                  productProvider.getImageFile(
                                                      source:
                                                          ImageSource.gallery);
                                                  Navigator.pop(context);
                                                }),
                                            ListTile(
                                                leading: const Icon(
                                                    Icons.camera_alt),
                                                title:
                                                    const Text('Take a photo'),
                                                onTap: () async {
                                                  productProvider.getImageFile(
                                                      source:
                                                          ImageSource.camera);
                                                  Navigator.pop(context);
                                                }),
                                          ],
                                        );
                                      });
                                },
                              )
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child:
                                    Image.file(productProvider.productImage!)),
                      ),
                    ],
                  ),
                ),
                Visibility(
                  visible: productProvider.productImage != null,
                  child: FlatButton(
                    onPressed: () {
                      showModalBottomSheet(
                          context: context,
                          builder: (BuildContext bc) {
                            return Wrap(
                              children: [
                                ListTile(
                                    leading: const Icon(Icons.image),
                                    title: const Text('From gallery'),
                                    onTap: () async {
                                      productProvider.getImageFile(
                                          source: ImageSource.gallery);
                                      Navigator.pop(context);
                                    }),
                                ListTile(
                                    leading: const Icon(Icons.camera_alt),
                                    title: const Text('Take a photo'),
                                    onTap: () async {
                                      productProvider.getImageFile(
                                          source: ImageSource.camera);
                                      Navigator.pop(context);
                                    }),
                              ],
                            );
                          });
                    },
                    child: CustomText(
                      text: "Change Image",
                      color: primary,
                    ),
                  ),
                ),
                const Divider(),
                Padding(
                    padding:
                        const EdgeInsets.only(left: 12, right: 12, bottom: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        CustomText(text: "featured Magazine"),
                        Switch(
                            value: productProvider.featured,
                            onChanged: (value) {
                              productProvider.changeFeatured();
                            })
                      ],
                    )),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    CustomText(
                      text: "Category:",
                      color: grey,
                      weight: FontWeight.w300,
                    ),
                    DropdownButton<String>(
                      value: categoryProvider.selectedCategory,
                      style: const TextStyle(
                          color: primary, fontWeight: FontWeight.w300),
                      icon: const Icon(
                        Icons.filter_list,
                        color: primary,
                      ),
                      elevation: 0,
                      onChanged: (value) {
                        categoryProvider.changeSelectedCategory(value!.trim());
                      },
                      items: categoryProvider.categoriesNames
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                            value: value, child: Text(value));
                      }).toList(),
                    ),
                  ],
                ),
                const Divider(),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 12, right: 12, bottom: 12),
                  child: Container(
                    decoration: BoxDecoration(
                        color: white,
                        border: Border.all(color: black, width: 0.2),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                              color: grey.withOpacity(0.5),
                              offset: const Offset(2, 7),
                              blurRadius: 7)
                        ]),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 14),
                      child: TextField(
                        controller: productProvider.name,
                        decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "Product name",
                            hintStyle: const TextStyle(
                                color: grey, fontFamily: "Sen", fontSize: 18)),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 12, right: 12, bottom: 12),
                  child: Container(
                    decoration: BoxDecoration(
                        color: white,
                        border: Border.all(color: black, width: 0.2),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                              color: grey.withOpacity(0.5),
                              offset: const Offset(2, 7),
                              blurRadius: 7)
                        ]),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 14),
                      child: TextField(
                        controller: productProvider.description,
                        decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "Product description",
                            hintStyle: TextStyle(
                                color: grey, fontFamily: "Sen", fontSize: 18)),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 12, right: 12, bottom: 12),
                  child: Container(
                    decoration: BoxDecoration(
                        color: white,
                        border: Border.all(color: black, width: 0.2),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                              color: grey.withOpacity(0.5),
                              offset: const Offset(2, 7),
                              blurRadius: 7)
                        ]),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 14),
                      child: TextField(
                        controller: productProvider.price,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "Price",
                            hintStyle: const TextStyle(
                                color: grey, fontFamily: "Sen", fontSize: 18)),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 12, right: 12, bottom: 12),
                  child: Container(
                      decoration: BoxDecoration(
                          color: primary,
                          border: Border.all(color: black, width: 0.2),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                                color: grey.withOpacity(0.3),
                                offset: const Offset(2, 7),
                                blurRadius: 4)
                          ]),
                      child: FlatButton(
                        onPressed: () async {
                          appProvider.changeLoading();
                          if (!await productProvider.uploadProduct(
                              category: categoryProvider.selectedCategory,
                              restaurantId: userProvider.restaurant!.id!,
                              restaurant: userProvider.restaurant!.name!)) {
                            _key.currentState!.showSnackBar(const SnackBar(
                              content: Text("Upload Failed"),
                              duration: Duration(seconds: 10),
                            ));
                            appProvider.changeLoading();
                            return;
                          }
                          _key.currentState!.showSnackBar(const SnackBar(
                            content: Text("Upload completed"),
                            duration: Duration(seconds: 10),
                          ));
                          userProvider.loadProductsByRestaurant(
                              restaurantId: userProvider.restaurant!.id!);
                          await userProvider.reload();
                          appProvider.changeLoading();
                        },
                        child: CustomText(
                          text: "Post",
                          color: white,
                        ),
                      )),
                ),
              ],
            ),
    );
  }
}
