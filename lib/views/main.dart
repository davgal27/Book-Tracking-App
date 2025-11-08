import 'package:flutter/material.dart';
import '../model/pager_logic.dart';
import '../model/book.dart';

void main() {
  runApp(MyBookApp());
}

class MyBookApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Book Library',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: BookListPage(),
    );
  }
}

class BookListPage extends StatefulWidget {
  @override
  State<BookListPage> createState() => _BookListPageState();
}

class _BookListPageState extends State<BookListPage> {
  late Future<List<Book>> _booksFuture;

  @override
  void initState() {
    super.initState();
    _booksFuture = Books.getBooks(); // Load from JSON
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Library')),
      body: FutureBuilder<List<Book>>(
        future: _booksFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No books found.'));
          }

          final books = snapshot.data!;
          return ListView.builder(
            itemCount: books.length,
            itemBuilder: (context, index) {
              final b = books[index];
              return ListTile(
                title: Text(b.title),
                subtitle: Text('${b.author} • ${b.genre}'),
                trailing: Text(b.section.name),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BookDetailPage(book: b),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

class BookDetailPage extends StatelessWidget {
  final Book book;
  const BookDetailPage({required this.book, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(book.title)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(book.author, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text('Genre: ${book.genre}'),
            Text('Publisher: ${book.publisher}'),
            Text('Pages: ${book.pages}'),
            Text('Published: ${book.datePublished}'),
            Text('Rating: ${book.rating}/5'),
            const SizedBox(height: 12),
            Text(book.description),
          ],
        ),
      ),
    );
  }
}
