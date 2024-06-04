class HomeModel {
  final bool status;
  final HomeDataModel data;

  HomeModel(this.status, this.data);

  factory HomeModel.fromJson(Map<String, dynamic> json) {
    return HomeModel(
      json['status'],
      HomeDataModel.fromJson(
        json['data'],
      ),
    );
  }
}

class HomeDataModel {
  List<BannerModel> banners = [];
  List<ProductModel> products = [];
  HomeDataModel.fromJson(Map<String, dynamic> json) {
    json['banners'].forEach((element) {
      banners.add(BannerModel.fromJson(element));
    });
    json['products'].forEach((element) {
      products.add(ProductModel.fromJson(element));
    });
  }
}

class BannerModel {
  final int id;
  final String image;
  BannerModel(this.id, this.image);

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(json['id'], json['image']);
  }
}

class ProductModel {
  final int id;
  final dynamic price;
  final dynamic oldPrice;
  final dynamic discount;
  final String image;
  final String name;
  final bool inFavorites;
  final bool inCart;

  ProductModel(
    this.id,
    this.price,
    this.oldPrice,
    this.discount,
    this.image,
    this.name,
    this.inFavorites,
    this.inCart,
  );
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      json['id'],
      json['price'],
      json['old_price'],
      json['discount'],
      json['image'],
      json['name'],
      json['in_favorites'],
      json['in_cart'],
    );
  }
}
