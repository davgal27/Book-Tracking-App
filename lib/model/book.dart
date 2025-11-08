// models/book.dart

enum Status { ToRead, Reading, Finished }

class Book {
  int id;
  String title;
  String author;
  String publisher;
  String datePublished;
  String genre;
  int pages;
  int pageProgress;
  int rating;           // new field: 1-5
  String description;   // new field: short description
  bool inLibrary;
  Status section;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.publisher,
    required this.datePublished,
    required this.genre,
    required this.pages,
    this.pageProgress = 0,
    this.rating = 0,            // default 0 (no rating)
    this.description = "",      // default empty
    this.inLibrary = true,
    this.section = Status.ToRead,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'],
      title: json['title'],
      author: json['author'],
      publisher: json['publisher'],
      datePublished: json['datePublished'],
      genre: json['genre'],
      pages: json['pages'],
      pageProgress: json.containsKey('pageProgress') ? json['pageProgress'] : 0,
      rating: json.containsKey('rating') ? json['rating'] : 0,
      description: json.containsKey('description') ? json['description'] : "",
      inLibrary: json.containsKey('inLibrary') ? json['inLibrary'] : true,
      section: json.containsKey('section') ? Status.values[json['section']] : Status.ToRead,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'publisher': publisher,
      'datePublished': datePublished,
      'genre': genre,
      'pages': pages,
      'pageProgress': pageProgress,
      'rating': rating,
      'description': description,
      'inLibrary': inLibrary,
      'section': section.index,
    };
  }
}

