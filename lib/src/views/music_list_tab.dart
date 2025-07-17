// ignore_for_file: dead_code, null_check_always_fails

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_audio_query_forked/on_audio_query.dart';
import 'package:sangeet/src/controller/audio_controller.dart';
import 'package:sangeet/src/views/album_list.dart';
import 'package:sangeet/src/views/all_music.dart';
import 'package:sangeet/src/views/artist_list.dart';
import 'package:sangeet/src/widgets/bottom_nav.dart';
// import 'package:sangeet/src/views/playlist.dart';

class MusicListTab extends StatefulWidget {
  const MusicListTab({super.key});

  @override
  State<MusicListTab> createState() => _MusicListTabState();
}

class _MusicListTabState extends State<MusicListTab>  with SingleTickerProviderStateMixin{

  late final TabController _tabController;
  final AudioController _con = Get.find();

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() { 
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8.0),
          tabBarHeader(),
          Expanded(
            child: tabBarView(),
          )
        ],
      )
    );
  }

  tabBarHeader() {
    return TabBar(
      controller: _tabController,
      padding: const EdgeInsets.only(left: 16.0),
      isScrollable: true,
      labelColor: Colors.white,
      unselectedLabelColor: Colors.grey,
      indicatorColor: Theme.of(context).primaryColor,
      indicatorSize: TabBarIndicatorSize.label,
      indicatorWeight: 2.2,
      tabs: const [
        Tab(
          text: "All Songs",
          height: 40,
        ),
        Tab(
          text: "Albums",
          height: 40,
        ),
        Tab(
          text: "Artists",
          height: 40,
        ),
        // Tab(
        //   text: "PlayList",
        //   height: 40,
        // ),
      ],
    );
  }

  tabBarView() {
    return Stack(
      children: [
        Obx(() => 
          SizedBox(
            height: _con.isPlaying.value == false ? null : MediaQuery.of(context).size.height * 0.75 ,
            child: TabBarView(
              controller: _tabController,
              children: const [
                AllMusic(),
                AlbumList(),
                ArtistList(),
                // PlayList()
              ],
            ),
          ),
        ),
        Positioned(
          bottom: 0.0,
          child: Container(
            // height: 73.0,
            width: MediaQuery.of(context).size.width,
            color: Colors.red.shade400,
            child: nowPlayingSongSnippet(),
          ),
        )
      ],
    );
  }

  nowPlayingSongSnippet() {
    return InkWell(
      onTap: () => Get.to(() => const BottomNavigation(), preventDuplicates: false),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Obx(() =>
          Row(
            children: [
              QueryArtworkWidget(
                controller: _con.audioQuery,
                id: _con.isPlayingId.value,
                type: ArtworkType.AUDIO,
                nullArtworkWidget: const Image(
                  image: AssetImage('assets/images/appIcon.png'),
                  width: 40.0,
                  height: 40.0,
                )
              ),
              const SizedBox(width: 8.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: Text(
                      _con.nowPlaying.title,
                      maxLines: 2,
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        height: 1.15
                      ),
                    )
                  ),
                  Text(_con.nowPlaying.artist),
                ],
              ),
              const Spacer(),
              InkWell(
                onTap: () {
                  _con.isPlaying.value
                    ? _con.pauseSong()
                    : _con.playSong();
                  setState(() { });
                },
                child: CircleAvatar(
                  radius: 20.0,
                  backgroundColor: Theme.of(context).primaryColor,
                  child: Icon(
                    _con.isPlaying.value
                      ? Icons.pause
                      : Icons.play_arrow,
                    size: 30.0,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 8.0),
              InkWell(
                onTap: () {
                  _con.nextSong();
                  setState(() { });
                },
                child: CircleAvatar(
                  radius: 20.0,
                  backgroundColor: Theme.of(context).primaryColor,
                  child: Icon(
                    Icons.skip_next,
                    size: 30.0,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 4.0),
            ],
          ),
        )
      ),
    );
  }

}