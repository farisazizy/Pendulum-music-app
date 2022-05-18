import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:spotify_clone/controllers/main_controller.dart';
import 'package:spotify_clone/methods/snackbar.dart';
import 'package:spotify_clone/models/song_model.dart';
import 'package:spotify_clone/utils/botttom_sheet_widget.dart';
import 'package:spotify_clone/utils/loading.dart';

// ini merupakan class model untuk LikedSongs
class LikedSongs extends StatelessWidget {
  final MainController con;
  const LikedSongs({
    Key? key,
    required this.con,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ini merupakan sebuah widget, widget tentunya memiliki property seperti warna background, dll
    List<dynamic> data = [];
    return Scaffold(
        // widget utama untuk membuat sebuah halaman pada flutter
        body: CustomScrollView(
      // body ini untuk bagian tubuhnya
      slivers: [
        SliverAppBar(
          pinned: true, // agar sticky tidak ikut mengilang saat di scroll
          expandedHeight: 200, //SliverAppBar ini akan memiliki tinggi 20px
          backgroundColor: Colors.black, // warna backgroundnya adalah hitam
          flexibleSpace: FlexibleSpaceBar(
            centerTitle: true,
            collapseMode: CollapseMode.pin,
            background: ClipRRect(
              child: Stack(
                // Stack widget memungkinkan kita untuk menampilkan beberapa lapis widget ke layar
                children: [
                  // dalam children ini terdapat widget cachedNetworkImage itu untuk memunculkan image
                  CachedNetworkImage(
                    imageUrl: // lokasi gambar yang akan ditampilkan
                        'https://images.unsplash.com/photo-1578070181910-f1e514afdd08?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=933&q=80',
                    height: 200, //mengatur ukuran tinggi
                    width: MediaQuery.of(context)
                        .size
                        .width, // mengatur ukuran lebar
                    fit: BoxFit.cover, //mengatur gambar dengan box
                  ),
                  BackdropFilter(
                    // digunakan untuk membuat efek buram pada gambar
                    filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
                    child: Container(
                      // Container ini merupakan widget yang fungsinya untuk membungkus widget lain sehingga dapat diberikan properti seperti dekorasi, gradien, warna, dll
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.center,
                          colors: [
                            Colors.black,
                            Colors.black.withOpacity(0.5),
                          ],
                        ),
                      ),
                      height: 250,
                      width: MediaQuery.of(context).size.width,
                    ),
                  )
                ],
              ),
            ),
            title: Text(
              // text ini berfungsi untuk menampilkan teks pada judul
              "Liked Songs", // teks atau tulisan yang akan muncul
              style: Theme.of(context)
                  .textTheme
                  .headline4, // style yang diberikan pada teks tersebut
            ),
          ),
        ),
        SliverToBoxAdapter(
          // sliver dasar yang membuat jembatan kembali ke salah satu widget
          child: ValueListenableBuilder<Box>(
              // ValueListenableBuilder akan meneruskannya kembali ke fungsi builder sehingga dapat memasukkannya ke dalam build.
              valueListenable: Hive.box('liked').listenable(),
              builder: (context, box, child) {
                if (box.isEmpty) {
                  return const SizedBox(
                    height: 300,
                    child: Center(
                      child: Text(
                        // text ini berfungsi untuk menampilkan teks
                        "You don't have any liked songs", // teks atau tulisan yang akan muncul
                        style: TextStyle(
                          // style yang diberikan pada teks tersebut
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  );
                }
                return ListView.builder(
                  // untuk menampilkan data yang besar tanpa menurunkan performa aplikasi
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, i) {
                    final info = Hive.box('liked').getAt(i);
                    data.add(info);

                    return Dismissible(
                      key: Key(info['songname'].toString()),
                      onDismissed: (direction) {
                        box.deleteAt(i);
                        context.showSnackBar(
                            message: "Removed from liked songs.");
                      },
                      direction: DismissDirection.endToStart,
                      background: Container(
                        alignment: Alignment.centerRight,
                        child: const Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Icon(
                            CupertinoIcons.delete,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      child: ListTile(
                        onTap: () {
                          con.playSong(con.converLocalSongToAudio(data), i);
                        },
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: CachedNetworkImage(
                              // widget cachedNetworkImage itu untuk memunculkan image
                              imageUrl: info['cover'],
                              width: 50,
                              height: 50,
                              placeholder: (context, u) => const LoadingImage(),
                              fit: BoxFit.cover),
                        ),
                        title: Text(
                          info['songname'],
                          maxLines: 1,
                          style: const TextStyle(color: Colors.white),
                        ),
                        subtitle: Text(
                          info['fullname'],
                          style: const TextStyle(color: Colors.grey),
                        ),
                        trailing: IconButton(
                          onPressed: () {
                            showModalBottomSheet(
                                // menu pilihan yang pada umumnya disembunyikan dibagian bawah layar
                                useRootNavigator: true,
                                isScrollControlled: true,
                                elevation: 100,
                                backgroundColor: Colors.black38,
                                context: context,
                                builder: (context) {
                                  return BottomSheetWidget(
                                      con: con,
                                      song: SongModel(
                                        songid: info['id'],
                                        songname: info['songname'],
                                        userid: info['username'],
                                        trackid: info['track'],
                                        duration: '',
                                        coverImageUrl: info['cover'],
                                        name: info['fullname'],
                                      ));
                                });
                          },
                          icon: const Icon(
                            // Icon yang diberikan secara konstan, Icon disini diberikan warna putih
                            Icons.more_vert,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    );
                  },
                  itemCount: box.length,
                );
              }),
        ),
        const SliverToBoxAdapter(
          // sliver dasar yang membuat jembatan kembali ke salah satu widget
          child: SizedBox(
              height:
                  150), // yaitu untuk membuat box, widget ini biasanya digunakan untuk menambahkan tinggi, jarak, dll sesuai dengan yang kita atur
        )
      ],
    ));
  }
}
