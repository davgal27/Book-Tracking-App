import 'dart:convert';
import 'dart:io';
import 'book.dart';

import 'package:flutter/services.dart' show rootBundle;

enum FilterBy {Title, Author, Genre}

class Books {
  static const String libraryFile = 'data/books.json';

  static Future<List<Book>> loadLibrary() async {
  final content = await rootBundle.loadString('data/books.json');
  final jsonList = jsonDecode(content) as List<dynamic>;
  return jsonList.map((e) => Book.fromJson(e)).toList();
  }

  static Future<void> saveLibrary(List<Book> books) async {
    final file = File(libraryFile);
    final jsonList = books.map((b) => b.toJson()).toList();
    await file.writeAsString(JsonEncoder.withIndent('  ').convert(jsonList));
  }

  static Future<Book?> findBook(int id, List<Book> books) async {
    try{
      return books.firstWhere((b) => b.id == id);
    } catch (e) {
      return null;
    }
  }

  static Future<bool> addBook(Book b, Status section) async {
    var books = await loadLibrary();

    for (var book in books) {
      if (book.id == b.id) {
        if (!book.inLibrary) {
          book.inLibrary = true;
          book.section = section;
          await saveLibrary(books);
          return true;
        }
        return false;
      }
    }

    return false; // book already in library
  }

  static Future<bool> removeBook(int id) async {
    var books = await loadLibrary();
    var book = await findBook(id, books);
    if (book == null || !book.inLibrary) return false;

    book.inLibrary = false;
    await saveLibrary(books);
    return true;
  }

  static Future<bool> changeSection(int id, Status newSection) async {
    var books = await loadLibrary();
    var book = await findBook(id, books);
    if (book == null) return false;

    book.section = newSection;
    await saveLibrary(books);
    return true;
  }

  static Future<bool> updateProgress(int id, int page) async {
    var books = await loadLibrary();
    var book = await findBook(id, books);
    if (book == null || book.section != Status.Reading) return false;

    book.pageProgress = page;
    await saveLibrary(books);
    return true;
  }

  static Future<List<Book>> getBooks([Status? section]) async {
    var books = await loadLibrary();
    if (section != null) {
      books = books.where((b) => b.section == section).toList();
    }
    return books;
  }

  static Future<List<Book>> getBooksFiltered({Status? section, FilterBy? filterBy, String? filterValue}) async {
    var books = await getBooks(section); // get books optionally filtered by Section

    if (filterBy != null && filterValue != null){
      final lowerValue = filterValue.toLowerCase();
      books = books.where((b){
        switch (filterBy) {
          case FilterBy.Title: 
            return b.title.toLowerCase().contains(lowerValue);
          case FilterBy.Author:
            return b.author.toLowerCase().contains(lowerValue);
          case FilterBy.Genre:
            return b.genre.toLowerCase().contains(lowerValue);
        }
      }).toList();
    }

    return books;
  }

  static Future<List<Book>> searchBooks(String term, [Status? section]) async {
    var books = await getBooks(section);
    final lowerTerm = term.toLowerCase();

    return books.where((b) {
      return b.title.toLowerCase().contains(lowerTerm) ||
             b.author.toLowerCase().contains(lowerTerm) ||
             b.genre.toLowerCase().contains(lowerTerm);
    }).toList();
  }
}
