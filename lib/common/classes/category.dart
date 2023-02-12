class Category {

  int? id;
  String? title;

  Category(int? id, String title) {
    this.id = id;
    this.title = title;
  }

  getTitle() {
    return this.title;
  }

  static mapAll(data) {

    List<Category> categories = [];
    int length = data["categories"].length;

    for(int i = 0; i < length; ++i) {
      Category cat = new Category(
        data["categories"][i]["id"], 
        data["categories"][i]["name"]
      );

      categories.add(cat);
    }

    return categories;
  } 

}