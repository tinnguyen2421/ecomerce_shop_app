import 'package:ecomerce_shop_app/controllers/subcategory_controller.dart';
import 'package:ecomerce_shop_app/models/category.dart';
import 'package:ecomerce_shop_app/models/subcategory.dart';
import 'package:ecomerce_shop_app/views/screens/detail/screens/widgets/inner_banner_widget.dart';
import 'package:ecomerce_shop_app/views/screens/detail/screens/widgets/inner_header_widget.dart';
import 'package:ecomerce_shop_app/views/screens/detail/screens/widgets/subcategory_title_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class InnerCategoryContentWidget extends StatefulWidget {
  final Category category;

  const InnerCategoryContentWidget({super.key, required this.category});

  @override
  State<InnerCategoryContentWidget> createState() =>
      _InnerCategoryContentWidgetState();
}

class _InnerCategoryContentWidgetState
    extends State<InnerCategoryContentWidget> {
  late Future<List<Subcategory>> _subCategories;
  final SubcategoryController _subcategoryController = SubcategoryController();

  @override
  void initState() {
    super.initState();
    _subCategories = _subcategoryController
        .getSubcategoriesByCategoryName(widget.category.name);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(MediaQuery.of(context).size.height * 20),
        child: const InnerHeaderWidget(),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            InnerBannerWidget(image: widget.category.banner),
            Center(
              child: Text(
                'Shop By categories',
                style: GoogleFonts.quicksand(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            FutureBuilder(
              future: _subCategories,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error ${snapshot.error}'),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text('No Subcategories'),
                  );
                } else {
                  final subCategories = snapshot.data!;
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Column(
                      children: List.generate(
                        (subCategories.length / 7).ceil(),
                        (setIndex) {
                          final start = setIndex * 7;
                          final end = (setIndex + 1) * 7;
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: subCategories
                                  .sublist(
                                    start,
                                    end > subCategories.length
                                        ? subCategories.length
                                        : end,
                                  )
                                  .map(
                                    (subCategory) => SubcategoryTitleWidget(
                                      image: subCategory.image,
                                      title: subCategory.subCategoryName,
                                    ),
                                  )
                                  .toList(),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
