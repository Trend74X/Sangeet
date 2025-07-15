import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_audio_query_forked/on_audio_query.dart';
import 'package:sangeet/src/controller/audio_controller.dart';

class FilteredSongs extends StatefulWidget {
  const FilteredSongs({super.key});

  @override
  State<FilteredSongs> createState() => _FilteredSongsState();
}

class _FilteredSongsState extends State<FilteredSongs> {

  final AudioController _con = Get.find();
  var args = Get.arguments;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(args),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () => Get.back(), 
          icon: Icon(Icons.arrow_back_ios)
        ),
      ),
      body: SingleChildScrollView(
        child: _con.filteredSongs.isEmpty
          ? const Center(child: Text('No Songs'))
          : allsongsList()
      )
    );
  }

  allsongsList() {
    return ListView.separated(
      itemCount: _con.filteredSongs.length,
      shrinkWrap: true,
      separatorBuilder: (context, index) => const Divider(),
      physics: const ClampingScrollPhysics(),
      itemBuilder: (context, index) {
        return ListTile(
          tileColor: _con.nowPlaying.id == _con.filteredSongs[index].id ? Theme.of(context).primaryColor : Theme.of(context).scaffoldBackgroundColor,
          leading:  QueryArtworkWidget(
            controller: _con.audioQuery,
            id: _con.filteredSongs[index].id,
            type: ArtworkType.AUDIO,
            nullArtworkWidget: const Image(
              image: AssetImage('assets/images/appIcon.png'),
              width: 40.0,
              height: 40.0,
            )
          ),
          title: SizedBox(
            width: MediaQuery.of(context).size.width * 0.75,
            child: Text(
              _con.filteredSongs[index].title,
              overflow: TextOverflow.ellipsis
            )
          ),
          subtitle: Row(
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.person,
                    size: 18
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.3,
                    child: Text(
                      ' ${_con.filteredSongs[index].artist}',
                      overflow: TextOverflow.ellipsis
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  const Icon(
                    Icons.album,
                    size: 18
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.3,
                    child: Text(
                      ' ${_con.filteredSongs[index].album}',
                      overflow: TextOverflow.ellipsis
                    ),
                  ),
                ],
              ),
            ],
          ),
          onTap: () {
            _con.currentPlayingList = List<SongModel>.from(_con.filteredSongs);
            _con.addToNowPlaying(index);
            setState(() { });
          },
        );
      }
    );
  }

}