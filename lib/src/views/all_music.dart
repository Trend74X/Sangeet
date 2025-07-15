import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_audio_query_forked/on_audio_query.dart';
import 'package:sangeet/src/controller/audio_controller.dart';
import 'package:sangeet/src/helper/database_helper.dart';
import 'package:sangeet/src/widgets/custom_textfield.dart';

class AllMusic extends StatefulWidget {
  const AllMusic({super.key});

  @override
  State<AllMusic> createState() => _AllMusicState();
}

class _AllMusicState extends State<AllMusic> {
  final AudioController _con = Get.find();
  final TextEditingController textFldCon = TextEditingController();
  final dbHelper = DatabaseHelper();

  List<SongModel> filteredSongs = [];

  @override
  void initState() {
    super.initState();
    fetchSongsFromDb();
  }

  Future<void> fetchSongsFromDb() async {
    final dbSongs = await dbHelper.getAllSongs();
    final allDbSongs = dbSongs.map((e) => SongModel(e)).toList();
    setState(() {
      filteredSongs = allDbSongs;
      _con.allSongs = allDbSongs;
    });
  }

  void handleSearch(String query) {
    final lowerQuery = query.toLowerCase();
    setState(() {
      filteredSongs = _con.allSongs.where((song) {
        final title = song.title.toLowerCase();
        final artist = (song.artist ?? '').toLowerCase();
        return title.contains(lowerQuery) || artist.contains(lowerQuery);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              searchBox(),
              filteredSongs.isEmpty
                  ? const Center(child: Text('Songs not found'))
                  : allsongsList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget searchBox() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 8.0, 12.0, 8.0),
      child: CustomTextField(
        controller: textFldCon,
        hintText: 'Search a song',
        prefixIcon: const Icon(
          Icons.search,
          color: Colors.grey,
        ),
        suffixIcon: textFldCon.text.isEmpty
          ? null
          : IconButton(
              onPressed: () {
                setState(() {
                  textFldCon.clear();
                  filteredSongs = _con.allSongs;
                });
                FocusScope.of(context).unfocus();
              },
              icon: const Icon(
                Icons.close,
                color: Colors.grey,
              ),
            ),
        onChanged: handleSearch,
      ),
    );
  }

  Widget allsongsList() {
    return ListView.separated(
      itemCount: filteredSongs.length,
      shrinkWrap: true,
      separatorBuilder: (context, index) => const Divider(),
      physics: const ClampingScrollPhysics(),
      itemBuilder: (context, index) {
        final song = filteredSongs[index];
        return Obx(() => ListTile(
              tileColor: _con.isPlayingId.value != 0 && _con.isPlayingId.value == song.id 
                ? Theme.of(context).primaryColor
                : Theme.of(context).scaffoldBackgroundColor,
              leading: QueryArtworkWidget(
                controller: _con.audioQuery,
                id: song.id,
                type: ArtworkType.AUDIO,
                nullArtworkWidget: const Image(
                  image: AssetImage('assets/images/appIcon.png'),
                  width: 40.0,
                  height: 40.0,
                ),
              ),
              title: SizedBox(
                width: MediaQuery.of(context).size.width * 0.75,
                child: Text(
                  song.title,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              subtitle: Row(
                children: [
                  const Icon(Icons.person, size: 18),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.55,
                    child: Text(
                      ' ${song.artist}',
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              onTap: () {
                setState(() {
                  _con.currentPlayingList = List<SongModel>.from(filteredSongs);
                });
                _con.addToNowPlaying(index);
              },
            ));
      },
    );
  }
}
