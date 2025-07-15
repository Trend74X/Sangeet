import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_audio_query_forked/on_audio_query.dart';
import 'package:sangeet/src/controller/audio_controller.dart';

class ArtistList extends StatefulWidget {
  const ArtistList({super.key});

  @override
  State<ArtistList> createState() => _ArtistListState();
}

class _ArtistListState extends State<ArtistList> {
  final AudioController _con = Get.find();

  @override
  void initState() {
    super.initState();
    // _con.getArtistListFromDb(); // Fetch artist list from DB
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _con.artistSongs.isEmpty
          ? const Center(child: Text('No Artists Found'))
          : ListView.separated(
            itemCount: _con.artistSongs.length,
            shrinkWrap: true,
            separatorBuilder: (context, index) => const Divider(),
            physics: const ClampingScrollPhysics(),
            itemBuilder: (context, index) {
              final artist = _con.artistSongs[index];
              return ListTile(
                tileColor: Theme.of(context).scaffoldBackgroundColor,
                leading: QueryArtworkWidget(
                  controller: _con.audioQuery,
                  id: artist.id,
                  type: ArtworkType.ARTIST,
                  nullArtworkWidget: const Image(
                    image: AssetImage('assets/images/appIcon.png'),
                    width: 40.0,
                    height: 40.0,
                  ),
                ),
                title: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.75,
                  child: Text(
                    artist.artist,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                subtitle: Row(
                  children: [
                    const Icon(Icons.album, size: 18),
                    Text(
                      ' ${artist.numberOfTracks}',
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
                onTap: () {
                  _con.getFilteredSongs(
                    'artist',
                    0,
                    artist.id,
                    artist.artist,
                  );
                },
              );
            },
          ),
    );
  }
}