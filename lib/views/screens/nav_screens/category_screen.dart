import 'package:ecomerce_shop_app/controllers/category_controller.dart';
import 'package:ecomerce_shop_app/controllers/subcategory_controller.dart';
import 'package:ecomerce_shop_app/models/category.dart';
import 'package:ecomerce_shop_app/models/subcategory.dart';
import 'package:ecomerce_shop_app/views/screens/detail/screens/widgets/subcategory_title_widget.dart';
import 'package:ecomerce_shop_app/views/screens/nav_screens/widgets/header_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  //A future that will hold the list of categories once loaded from the API
  late Future<List<Category>> futureCategories;
  Category? _selectedCategory;
  List<Subcategory> _subcategories = [];
  final SubcategoryController _subcategoryController = SubcategoryController();
  @override
  void initState() {
    super.initState();
    futureCategories = CategoryController().loadCategories();
    //once the categories are loaded proccess then
    futureCategories.then((categories) {
      //iterate through the categories to find the "Fashion" category
      for (var category in categories) {
        if (category.name == "Fashion") {
          //if "Fashion" category is found , set if as the selected category
          setState(() {
            _selectedCategory = category;
          });
          //load subcategories for the "Fashion" category
          _loadSubcategories(category.name);
        }
      }
    });
  }

  //this will load subScategories base on the categoryName
  Future<void> _loadSubcategories(String categoryName) async {
    final subcategories = await _subcategoryController
        .getSubcategoriesByCategoryName(categoryName);
    setState(() {
      _subcategories = subcategories;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(MediaQuery.of(context).size.height * 20),
        child: HeaderWidget(),
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //left side -display category
          Expanded(
            flex: 2,
            child: Container(
              color: Colors.grey.shade200,
              child: FutureBuilder(
                  future: futureCategories,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text('Error: ${snapshot.error}'),
                      );
                    } else {
                      final categories = snapshot.data!;
                      return ListView.builder(
                          itemCount: categories.length,
                          itemBuilder: (context, index) {
                            final category = categories[index];
                            return ListTile(
                              onTap: () {
                                setState(() {
                                  _selectedCategory = category;
                                });
                                _loadSubcategories(category.name);
                              },
                              title: Text(
                                category.name,
                                style: GoogleFonts.quicksand(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: _selectedCategory == category
                                        ? Colors.blue
                                        : Colors.black),
                              ),
                            );
                          });
                    }
                  }),
            ),
          ),
          //Right Side -Display selected category detail
          Expanded(
              flex: 5,
              child: _selectedCategory != null
                  ? SingleChildScrollView(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              _selectedCategory!.name,
                              style: GoogleFonts.quicksand(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.7),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              height: 150,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                image: NetworkImage(_selectedCategory!.banner),
                                fit: BoxFit.cover,
                              )),
                            ),
                          ),
                          _subcategories.isNotEmpty
                              ? GridView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: _subcategories.length,
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 3,
                                          crossAxisSpacing: 8,
                                          mainAxisSpacing: 8,
                                          childAspectRatio: 2 / 3),
                                  itemBuilder: (contex, index) {
                                    final subcategory = _subcategories[index];

                                    return SubcategoryTitleWidget(
                                        image: subcategory.image,
                                        title: subcategory.categoryName);
                                  })
                              : Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(
                                    child: Text(
                                      'No Subcategories',
                                      style: GoogleFonts.quicksand(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 1.7),
                                    ),
                                  ),
                                )
                        ],
                      ),
                    )
                  : Container())
        ],
      ),
    );
  }
}
