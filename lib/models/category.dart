class Category {
  final String name;
  final String imageAssetPath;

  Category({
    required this.name,
    required this.imageAssetPath,
  });
}

final List<Category> categories = [
  Category(name: 'Bread', imageAssetPath: 'images/bread.png'),
  Category(name: 'Cake', imageAssetPath: 'images/cake.png'),
  Category(name: 'Cookies', imageAssetPath: 'images/cookie.png'),
  Category(name: 'Doughnut', imageAssetPath: 'images/doughnut.png'),
];
