class ChangeFavoritesModel {
  final bool status;
  final String message;

  ChangeFavoritesModel(this.status, this.message);

  factory ChangeFavoritesModel.fromJson(Map<String, dynamic> json) {
    return ChangeFavoritesModel(json['status'], json['message']);
  }
}
