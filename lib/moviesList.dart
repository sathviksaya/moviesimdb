import 'package:flutter/material.dart';
import 'package:moviesimdb/movieCard.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class MoviesList extends StatefulWidget {
  const MoviesList({Key? key}) : super(key: key);

  @override
  _MoviesListState createState() => _MoviesListState();
}

class _MoviesListState extends State<MoviesList> {
  var movies;
  TextEditingController _controller = new TextEditingController();

  void getMovie(String movieName) async {
    var url = Uri.parse(movieName.length == 0
        // ? "https://imdb-api.com/en/API/MostPopularMovies/k_wf7idpk8"
        ? "https://api.themoviedb.org/3/movie/popular?api_key=887061d89b4c0c59eafb64826d461009&language=en-US&page=1"
        : "https://api.themoviedb.org/3/search/movie?api_key=887061d89b4c0c59eafb64826d461009&language=en-US&query=$movieName&page=1&include_adult=false");
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonResponse =
          convert.jsonDecode(response.body) as Map<String, dynamic>;
      setState(() {
        movies = jsonResponse["results"];
            // movieName.length == 0 ? jsonResponse["items"] : jsonResponse["results"];
      });
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }

  @override
  void initState() {
    super.initState();
    getMovie(_controller.text) ;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.black,
            ),
          ),
          margin: const EdgeInsets.symmetric(horizontal: 10),
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: TextField(
            controller: _controller,
            keyboardType: TextInputType.name,
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(
              suffixIcon: Icon(
                Icons.search,
                color: Colors.black,
                size: 20,
              ),
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              hintText: "Search Movie...",
              hintStyle: TextStyle(
                fontSize: 20,
              ),
            ),
            onChanged: (String? val) {
              setState(() {
                getMovie(_controller.text);
              });
            },
          ),
        ),
        SizedBox(
          height: 20,
        ),
        movies == null
            ? Center(
                child: CircularProgressIndicator(
                  color: Colors.black,
                ),
              )
            : Expanded(
                child: ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: movies.length,
                  itemBuilder: (context, index) {
                    return MovieCard(
                      // search: _controller.text.length == 0 ? false : true,
                      search: true,
                      movie: movies[index],
                    );
                  },
                ),
              ),
      ],
    );
  }
}
