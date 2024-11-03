import 'package:ecomerce_shop_app/models/banner_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BannerProvider extends StateNotifier<List<BannerModel>> {
  BannerProvider() : super([]);
  //method to set the list of categories
  void setBanners(List<BannerModel> banners) {
    state = banners;
  }
}

final bannerProvider =
    StateNotifierProvider<BannerProvider, List<BannerModel>>((ref) {
  return BannerProvider();
});
