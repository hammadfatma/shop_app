class CategoryModel {
  final bool status;
  final CategoryDataModel data;

  CategoryModel(this.status, this.data);

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      json['status'],
      CategoryDataModel.fromJson(json['data']),
    );
  }
}

class CategoryDataModel {
  int? currentPage;
  List<DataModel> data = [];
  CategoryDataModel.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    json['data'].forEach((element) {
      data.add(DataModel.fromJson(element));
    });
  }
}

class DataModel {
  final int id;
  final String name;
  final String image;

  DataModel(this.id, this.name, this.image);

  factory DataModel.fromJson(Map<String, dynamic> json) {
    return DataModel(json['id'], json['name'], json['image']);
  }
}
