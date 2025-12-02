import 'package:flutter/material.dart';

void main() {
  runApp(const MovieCatalog());
}

class MyMovie extends StatelessWidget {
  final String title;

  const MyMovie({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(title, style: const TextStyle(fontSize: 18)),
    );
  }
}

class MovieCatalog extends StatefulWidget {
  const MovieCatalog({super.key});

  @override
  State<MovieCatalog> createState() => _MovieCatalogState();
}

class _MovieCatalogState extends State<MovieCatalog> {
  final List<String> moviesList = ['Titanic', 'Hulk', 'Lorem', 'Ipsum'];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: false),
      home: Scaffold(
        appBar: AppBar(title: const Text('Movie Catalog'), centerTitle: true),
        drawer: const Drawer(),
        body: Column(
          children: moviesList.map((e) {
            return GestureDetector(
              child: MyMovie(title: e),
              onTap: () {
                setState(() {
                  moviesList.add(e);
                });
              },
            );
          }).toList(),
        ),
        floatingActionButton: FloatingActionButton(
          child: TextField(),
          onPressed: () {
            setState(() {
              moviesList.add(value); // limpa a lista
            });
          },
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
            BottomNavigationBarItem(icon: Icon(Icons.abc), label: 'XXX'),
          ],
        ),
      ),
    );
  }
}