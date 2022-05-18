import 'dart:ui';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:spotify_clone/controllers/main_controller.dart';
import 'package:spotify_clone/models/song_model.dart';
import 'package:spotify_clone/utils/botttom_sheet_widget.dart';
import 'package:spotify_clone/utils/like_button/like_button.dart';
import 'package:spotify_clone/utils/loading.dart';
import 'package:spotify_clone/utils/play_list.dart';
import 'package:spotify_clone/utils/player/playing_controls.dart';
import 'package:spotify_clone/utils/player/position_seek_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class CurrentPlayingSong extends StatelessWidget {
  final MainController con;
  const CurrentPlayingSong({
    Key? key,
    required this.con,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: con.player.builderCurrent(builder: (context, playing) {
      final myAudio = con.find(con.audios, playing.audio.assetAudioPath);

      return Stack(
        // Menggunakan Stack supaya component bisa menumpuk
        children: [
          CachedNetworkImage(
            /*
          A flutter library to show images from the internet and keep them in the cache directory.
          ImageUrl: Gambar diambil dari myAudio.metas
          w x h: Menyesuaikan screen
          progressIndicatorBuilder: Membuat bar progress
          */
            imageUrl: myAudio.metas.image!.path,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * .7,
            progressIndicatorBuilder: (context, url, l) => const LoadingImage(),
            fit: BoxFit.cover,
            alignment: Alignment.center,
          ),
          BackdropFilter(
            // BackdropFilter untuk mewarnai background dengan warna Gambar CachedNetworkImage
            filter: ImageFilter.blur(
                sigmaX: 200, sigmaY: 200), // Menggunakan filter blur
            child: Container(
              // Container untuk mengelompokkan seluruh bagian Now Playing
              color: Colors.black38, // Warna hitam
              child: Padding(
                // Container dibalut dengan Padding
                padding: const EdgeInsets.symmetric(horizontal: 0.0),
                child: Column(
                  // Wrap dengan Column
                  mainAxisAlignment: MainAxisAlignment
                      .spaceBetween, // Space dengan metode space Between
                  crossAxisAlignment:
                      CrossAxisAlignment.start, // Align dari sebelah kiri
                  children: [
                    SafeArea(
                      // It works by insetting its child by sufficient padding to avoid intrusions.
                      // Supaya component yang ada memiliki padding utama dan tidak menabrak dengan layar
                      child: Padding(
                        // Wrap dengan Padding
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 12),
                        child: Row(
                          // Wrap dengan Row untuk menyimpan komponen kearah horizontal
                          children: [
                            /*
                            BAGIAN HEADER ATAS

                            Kiri:
                            Back Button

                            Tengah: Wrap with Expanded
                            Judul Halaman 
                            Nama Artist

                            Kanan:
                            More Button

                            */
                            IconButton(
                              // Back Icon
                              onPressed: () => Navigator.pop(context),
                              icon: const Icon(
                                Icons.arrow_back_ios,
                                color: Colors.white,
                              ),
                            ),
                            Expanded(
                              // Wrap Expanded
                              child: Center(
                                // Title and artist Text
                                child: Column(
                                  children: [
                                    const Text(
                                      "NOW PLAYING",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(
                                      // Memberi Jarak antara component atas dan bawah
                                      height: 4,
                                    ),
                                    Text(
                                      myAudio.metas.artist!,
                                      style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            IconButton(
                              // Icon More Button
                              onPressed: () {
                                showModalBottomSheet(
                                    // Mengeluarkan Modal
                                    useRootNavigator: true,
                                    isScrollControlled: true,
                                    elevation: 100,
                                    backgroundColor: Colors.black38,
                                    context: context,
                                    builder: (context) {
                                      return BottomSheetWidget(
                                          con: con,
                                          isNext: true,
                                          song: SongModel(
                                            songid: myAudio.metas.id,
                                            songname: myAudio.metas.title,
                                            userid: myAudio.metas.album,
                                            trackid: myAudio.path,
                                            duration: '',
                                            coverImageUrl:
                                                myAudio.metas.image!.path,
                                            name: myAudio.metas.artist,
                                          ));
                                    });
                              },
                              icon: const Icon(
                                Icons.more_vert,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      // Wrap Padding untuk menampilkan gambar cover album
                      padding: const EdgeInsets.all(26.0),
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: ClipRRect(
                          // ClipRRect untuk membuat lekukan pada shape
                          borderRadius: BorderRadius.circular(3),
                          child: CachedNetworkImage(
                            // CachedNetworkImage dari imageUrl yang didapat pada database
                            imageUrl: myAudio.metas.image!.path,
                            progressIndicatorBuilder: (context, url, l) =>
                                const LoadingImage(
                              // Exception untuk menunggu koneksi internet
                              icon: Icon(
                                // Mengambil icon compactDisc
                                LineIcons.compactDisc,
                                size: 120,
                              ),
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Column(
                      // Wrap dengan Column
                      crossAxisAlignment:
                          CrossAxisAlignment.start, // Align dari sebelah kiri
                      children: [
                        const SizedBox(height: 20), // Jarak sebanyak 20
                        Row(
                          // Wrap Row dengan Row supaya component disimpan pada baris horizontal
                          children: [
                            Expanded(
                              // Wrap Expanded
                              child: Column(
                                // Wrap Column
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 24.0),
                                    // Padding seluruh posisi
                                    child: Text(
                                      // Info Lagu
                                      myAudio.metas.title!,
                                      maxLines: 1,
                                      style:
                                          Theme.of(context).textTheme.headline4,
                                    ),
                                  ),
                                  const SizedBox(
                                      height: 5), // Jarak vertical 5px
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 24.0),
                                    child: Text(
                                      myAudio.metas.artist!,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1!
                                          .copyWith(color: Colors.grey),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            LikeButton(
                              // Like button dengan parameter
                              name: myAudio.metas.title!,
                              fullname: myAudio.metas.artist!,
                              username: myAudio.metas.album!,
                              id: myAudio.metas.id!,
                              track: myAudio.path,
                              isIcon: false,
                              cover: myAudio.metas.image!.path,
                            ),
                            const SizedBox(width: 24)
                          ],
                        ),
                        con.player.builderCurrent(
                          /*
                            Function: Assets Audio Player

                            Play music/audio stored in assets files (simultaneously) directly from Flutter (android / ios / web / macos).
                            You can also use play audio files from network using their url, radios/livestream and local files

                            final assetsAudioPlayer = AssetsAudioPlayer();

                            try {
                                await assetsAudioPlayer.open(
                                    Audio.liveStream(MY_LIVESTREAM_URL),
                                );
                            } catch (t) {
                                //stream unreachable
                            }

                          */
                          builder: (context, Playing? playing) {
                            return Column(children: <Widget>[
                              con.player.builderRealtimePlayingInfos(builder:
                                  (context, RealtimePlayingInfos? infos) {
                                if (infos == null) {
                                  return const SizedBox();
                                  // Kosong
                                }
                                return PositionSeekWidget(
                                  currentPosition:
                                      infos.currentPosition, // Waktu Lagu
                                  duration: infos.duration, // info Durasi lagu
                                  seekTo: (to) {
                                    con.player.seek(
                                        to); // Function: Seek, digunakan untuk slide posisi durasi
                                  },
                                );
                              }),
                              con.player.builderLoopMode(
                                // Control Button Audio Player
                                builder: (context, loopMode) {
                                  return PlayerBuilder.isPlaying(
                                      player: con.player,
                                      builder: (context, isPlaying) {
                                        return PlayingControls(
                                          // Pengaturan control audio
                                          // Seluruh kontrol ada di sini
                                          loopMode: loopMode,
                                          isPlaying: isPlaying,
                                          con: con,
                                          isPlaylist: true,
                                          onStop: () {
                                            con.player.stop();
                                          },
                                          toggleLoop: () {
                                            con.player.toggleLoop();
                                          },
                                          onPlay: () {
                                            con.player.playOrPause();
                                          },
                                          onNext: () {
                                            con.player.next(keepLoopMode: true);
                                          },
                                          onPrevious: () {
                                            con.player.previous();
                                          },
                                        );
                                      });
                                },
                              ),
                              const SizedBox(height: 20),
                              Padding(
                                // FOOTER CONTENT
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 26.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    InkWell(
                                      // Button dengan gambar
                                      onTap: () {
                                        launch(myAudio.path);
                                      },
                                      child: const Icon(
                                        Icons.download_sharp,
                                        color: Colors.grey,
                                        size: 18,
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                PlayListWidget(
                                              audios:
                                                  con.player.playlist!.audios,
                                              con: con,
                                            ),
                                          ),
                                        );
                                      },
                                      child: const Icon(
                                        CupertinoIcons.music_note_list,
                                        color: Colors.grey,
                                        size: 18,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ]);
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    }));
  }
}
