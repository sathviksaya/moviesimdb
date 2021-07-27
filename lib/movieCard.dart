import 'package:flutter/material.dart';

// ignore: must_be_immutable
class MovieCard extends StatelessWidget {
  final movie;
  final bool search;
  MovieCard({Key? key, required this.search, required this.movie})
      : super(key: key);
  late Color ratingColor;
  late double rating = 0.0;
  bool noRating = false;

  @override
  Widget build(BuildContext context) {
    if (search) {
      rating = movie["vote_average"] == null
          ? 0.0
          : double.parse(movie["vote_average"].toString());
    } else {
      rating = movie["imDbRating"] == null
          ? 0.0
          : double.parse(movie["imDbRating"].toString());
    }
    if (rating == 0.0) {
      ratingColor = Colors.grey;
      noRating = true;
    } else if (rating <= 3.5) {
      ratingColor = Colors.red;
    } else if (rating > 3.5 && rating < 7) {
      ratingColor = Colors.blue;
    } else {
      ratingColor = Colors.green;
    }
    return Stack(
      children: [
        Card(
          elevation: 2,
          margin: EdgeInsets.fromLTRB(15, 20, 15, 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Container(
            height: 140,
            child: Row(
              children: [
                SizedBox(
                  width: 140,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        movie["title"],
                        maxLines: 2,
                        softWrap: true,
                        style: TextStyle(
                          fontSize: 25,
                          color: Colors.black54,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      Container(
                        width: 220,
                        child: Text(
                          search ? movie["overview"] : movie["crew"] ?? "NA",
                          softWrap: true,
                          maxLines: search ? 4 : 2,
                          overflow: TextOverflow.fade,
                          style: TextStyle(
                            fontSize: search ? 10 : 13,
                            color: Colors.black87,
                            fontWeight:
                                search ? FontWeight.w300 : FontWeight.w600,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: ratingColor,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: EdgeInsets.symmetric(
                          vertical: 5,
                          horizontal: 10,
                        ),
                        child: Text(
                          noRating
                              ? "No Ratings"
                              : "${movie[search ? "vote_average" : "imDbRating"]} IMDB",
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          left: 25,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              search
                  ? movie["poster_path"] != null
                      ? "http://image.tmdb.org/t/p/w400/${movie["poster_path"]}"
                      : "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSNO3hziJ9HVvBASDh6lMDRX3p6eS_Fb4dvWN0pGyaGETX6yYt3PAl9mBgrqQFPE1fGDTU&usqp=CAU"
                  : movie["image"] ??
                      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSNO3hziJ9HVvBASDh6lMDRX3p6eS_Fb4dvWN0pGyaGETX6yYt3PAl9mBgrqQFPE1fGDTU&usqp=CAU",
              fit: BoxFit.fill,
              width: 0.8 * 140,
              height: 150,
            ),
          ),
        ),
      ],
    );
  }
}
