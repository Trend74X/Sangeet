import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_audio_query_forked/on_audio_query.dart';
import 'package:sangeet/src/controller/audio_controller.dart';

class AlbumList extends StatefulWidget {
  const AlbumList({super.key});

  @override
  State<AlbumList> createState() => _AlbumListState();
}

class _AlbumListState extends State<AlbumList> {
  final AudioController _con = Get.find();

  // @override
  // void initState() {
  //   super.initState();
  //   _con.getAlbumListFromDb(); // Ensure albumList is built from DB
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _con.albumList.isEmpty
          ? const Center(child: Text('No Albums Found'))
          : ListView.separated(
            itemCount: _con.albumList.length,
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            separatorBuilder: (_, __) => const Divider(),
            itemBuilder: (context, index) {
              final album = _con.albumList[index];
              return ListTile(
                tileColor: Theme.of(context).scaffoldBackgroundColor,
                leading: QueryArtworkWidget(
                  controller: _con.audioQuery,
                  id: album.id,
                  type: ArtworkType.ALBUM,
                  nullArtworkWidget: const Image(
                    image: AssetImage('assets/images/appIcon.png'),
                    width: 40.0,
                    height: 40.0,
                  ),
                ),
                title: Text(
                  album.album,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Row(
                  children: [
                    const Icon(Icons.person, size: 18),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: Text(
                        ' ${album.artist}',
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const Icon(Icons.album, size: 18),
                    Text(' ${album.numOfSongs}'),
                  ],
                ),
                onTap: () {
                  _con.getFilteredSongs(
                    'album',
                    album.id,
                    album.artistId!,
                    album.album,
                  );
                },
              );
            },
          ),
    );
  }
}
