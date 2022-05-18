import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spotify_clone/controllers/main_controller.dart';
import 'package:spotify_clone/methods/string_methods.dart';
import 'package:spotify_clone/models/catagory.dart';
import 'package:spotify_clone/screens/genre_page/genre_page.dart';
import 'package:spotify_clone/screens/search_results/search_result.dart';

// class untuk menampilkan serchbar
class SearchPage extends StatelessWidget { 
  final MainController con;

  const SearchPage({
    Key? key,
    required this.con,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final allTags = tags.map((e) => TagsModel.fromJson(e)).toList();
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: SafeArea(
          // membuat ui dinamik dan adaptif
          child: NestedScrollView(
            // untuk scroll 
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return [
                const SliverToBoxAdapter(
                    child: SizedBox(
                      // untuk mengatur ukuran
                  height: 40,
                )),
                // jembatan untuk kembali ke widget kotak biasa
                SliverToBoxAdapter(
                  child: Padding(
                    // untuk membuat padding
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Text(
                      // menampilkan teks
                      "Search",
                      style: Theme.of(context).textTheme.headline4!.copyWith(
                            fontSize: 36,
                          ),
                    ),
                  ),
                ),
                const SliverToBoxAdapter(
                    child: SizedBox(
                      // untuk mengatur ukuran 
                  height: 5,
                )),
                SliverPersistentHeader(
                  pinned: true,
                  delegate: SliverSearchAppBar(con: con),
                ),
              ];
            },
            body: ListView(
              children: [
                Padding(
                  // untuk membuat padding 
                  padding: const EdgeInsets.symmetric(vertical: 18.0),
                  child: Text(
                    // menampilkan teks
                    "Your Top genre",
                    style: Theme.of(context).textTheme.headline4!.copyWith(
                          fontSize: 18,
                        ),
                  ),
                ),
                untuk membuat tata letak 
                GridView(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 14,
                      crossAxisSpacing: 14,
                      childAspectRatio: 16 / 8,
                    ),
                    children: [
                      ...allTags
                          .sublist(0, 4)
                          .map((e) => TagWidget(tag: e, con: con))
                          .toList()
                    ]),
                Padding(
                  // untuk membuat padding 
                  padding: const EdgeInsets.symmetric(vertical: 24.0),
                  child: Text(
                    // menampilkan teks
                    "Browse all",
                    style: Theme.of(context).textTheme.headline4!.copyWith(
                          fontSize: 18,
                        ),
                  ),
                ),
                GridView(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 14,
                      crossAxisSpacing: 14,
                      childAspectRatio: 16 / 8,
                    ),
                    children: [
                      ...allTags
                          .sublist(4)
                          .map((e) => TagWidget(tag: e, con: con))
                          .toList()
                    ]),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TagWidget extends StatelessWidget {
  final TagsModel tag;
  final MainController con;
  const TagWidget({
    Key? key,
    required this.tag,
    required this.con,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      // area persegi panjang yang merespon sentuhan
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => GenrePage(
                      tag: tag,
                      con: con,
                    )));
      },
      child: ClipRRect(
        // membuat sudut menjadi bulat
        borderRadius: BorderRadius.circular(5),
        child: Container(
          decoration: BoxDecoration(
              color: tag.color,
              borderRadius: BorderRadius.circular(5),
              boxShadow: [
                BoxShadow(
                  // memberi efek bayangan
                    color: Colors.grey.shade900,
                    offset: const Offset(1, 1),
                    spreadRadius: 1,
                    blurRadius: 50,
                    blurStyle: BlurStyle.outer),
              ]),
          child: Stack(
            // menggunakan stack
            children: [
              const SizedBox(
                width: double.infinity,
                height: double.infinity,
              ),
              Positioned(
                bottom: 5,
                right: -15,
                child: RotationTransition(
                  turns: const AlwaysStoppedAnimation(385 / 360),
                  child: Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: tag.color,
                      borderRadius: BorderRadius.circular(3),
                      boxShadow: kElevationToShadow[2],
                    ),
                    child: ClipRRect(
                      // membuat sudut menjadi bulat
                      untuk 
                      borderRadius: BorderRadius.circular(3),
                      child: CachedNetworkImage(
                        // menyimpan data gambar yang sebelumnya pernah termuat
                        imageUrl: tag.image,
                        fit: BoxFit.cover,
                        width: 70,
                        height: 70,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                // untuk membuat padding
                padding:
                    const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                child: Text(tag.tag.toTitleCase(),
                // menampilkan teks
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1!
                        .copyWith(fontSize: 20, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SliverSearchAppBar extends SliverPersistentHeaderDelegate {
  final MainController con;
  SliverSearchAppBar({
    required this.con,
  });
  @override
  Widget build(context, double shrinkOffset, bool overlapsContent) {
    return InkWell(
      // area persegi panjang yang merespon sentuhan
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => SearchResultsPage(
                      con: con,
                    )));
      },
      child: Container(
        color: Colors.black,
        child: Padding(
          // membuat padding 
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
            ),
            height: 50,
            child: Padding(
              // untuk membuat padding
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Row(
                // membuat row
                children: [
                  const SizedBox(
                    // untuk mengatur ukuran kotak
                      height: 50, child: Icon(CupertinoIcons.search)),
                  const SizedBox(width: 10),
                  Text(
                    "Songs, Artists or Genres",
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                          color: Colors.grey.shade800,
                          fontSize: 18,
                        ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  double get maxExtent => 70;

  @override
  double get minExtent => 70;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}
