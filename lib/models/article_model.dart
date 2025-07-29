class ArticleModel {
  final String? imags;
  final String title;
  final String? supTitle;
  ArticleModel(
      {required this.imags, required this.title, required this.supTitle});

  factory ArticleModel.fromJson(json) {
    return ArticleModel(
      imags: json['urlToImage'],
      title: json['title'],
      supTitle: json['description'],
    );
  }
}
