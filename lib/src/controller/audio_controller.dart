import 'dart:async';
import 'dart:developer' as dev;
import 'dart:math' as math;

import 'package:audioplayers/audioplayers.dart';
import 'package:get/get.dart';
import 'package:on_audio_query_forked/on_audio_query.dart';
import 'package:sangeet/src/views/filtered_songs.dart';
import 'package:sangeet/src/widgets/bottom_nav.dart';
import 'package:sangeet/src/widgets/cache_storage.dart';
import 'package:sangeet/src/widgets/show_message.dart';

class AudioController extends GetxController {
  final OnAudioQuery audioQuery = OnAudioQuery();
  final AudioPlayer audioPlayer = AudioPlayer(); 

  dynamic nowPlaying;
  bool _hasPermission = false;
  List<SongModel> allSongs = [];
  List<SongModel> currentPlayingList = [];
  List<SongModel> filteredSongs = [];
  List<AlbumModel> albumList = [];
  List<dynamic> artistSongs = [];
  List<Map<String, dynamic>> playlists = [];
  RxInt isPlayingIdx = 0.obs;
  RxInt isPlayingId = 0.obs;
  bool isRepeat = false; 
  bool isShuffle = false; 
  RxBool isPlaying = false.obs;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  double? dragValue;

  getAllFiles() {
    checkAndRequestPermissions();
  }

  checkAndRequestPermissions({bool retry = true}) async {
    _hasPermission = await audioQuery.checkAndRequest(
      retryRequest: retry,
    );
    if (_hasPermission) {
      await getAllSongs();
      await getAlbumList();
      await getArtistList();
      // await getPlayList();
      convertSecondsToDuration(nowPlaying.duration);
      Get.off(() => const BottomNavigation());
    }
  }

  Future<void> getAllSongs() async {
    try {
      final scannedSongs = await audioQuery.querySongs(
        sortType: SongSortType.TITLE,
        orderType: OrderType.ASC_OR_SMALLER,
        uriType: UriType.EXTERNAL,
        ignoreCase: true,
      );

      allSongs.assignAll(scannedSongs);
      filteredSongs.assignAll(scannedSongs);
      currentPlayingList.assignAll(allSongs);

      // Restore from cache (GetStorage or similar)
      final cachedNowPlaying = read('nowPlaying');
      final cachedPlayingList = read('currentPlayingList');
      final cachedIndex = read('isPlayingIdx');

      if (cachedNowPlaying != null && cachedNowPlaying != '') {
        nowPlaying = SongModel(cachedNowPlaying);
      } else {
        nowPlaying = currentPlayingList.isNotEmpty ? currentPlayingList[0] : null;
      }

      if (cachedPlayingList != null && cachedPlayingList != '') {
        final List<SongModel> cachedList = cachedPlayingList
            .map<SongModel>((songData) => SongModel(songData))
            .toList();
        currentPlayingList.assignAll(cachedList);
      }

      isPlayingIdx(cachedIndex == '' ? 0 : cachedIndex);
    } catch (e) {
      dev.log('Error: $e');
    }
  }

  getAlbumList() async {
    var data = await audioQuery.queryAlbums(
      sortType: AlbumSortType.ALBUM,
      orderType: OrderType.ASC_OR_SMALLER,
      ignoreCase: true,
    );
    albumList = data;
  }

  getArtistList() async {
    var data = await audioQuery.queryArtists(
      sortType: ArtistSortType.ARTIST,
      orderType: OrderType.ASC_OR_SMALLER,
      uriType: UriType.EXTERNAL,
      ignoreCase: true,
    );
    artistSongs = data;
  }

  // Future<void> getPlayList() async {
  //   playlists = await dbHelper.getPlaylists();
  // }

  getFilteredSongs(type, albumId, artistId, name) {
    var songs = [];
    for (var item in allSongs) {
      if (type == 'album') {
        if (item.albumId == albumId && item.artistId == artistId && item.isMusic!) {
          songs.add(item);
        }
      } else if (type == 'artist') {
        if (item.artistId == artistId && item.isMusic!) {
          songs.add(item);
        }
      }
    }
    filteredSongs = List<SongModel>.from(songs);
    Get.to(() => const FilteredSongs(), arguments: name);
  }

  playSong() {
    try {
      convertSecondsToDuration(nowPlaying.duration);
      audioPlayer.play(DeviceFileSource(nowPlaying.data));
      isPlayingId(nowPlaying.id);
      isPlaying(true);

      // Store in memory
      write('nowPlaying', nowPlaying.getMap);
      write('currentPlayingList', currentPlayingList.map((s) => s.getMap).toList());
      write('isPlayingIdx', isPlayingIdx.value);
    } catch (e) {
      isPlaying(false);
    }
  }

  pauseSong() {
    try {
      audioPlayer.pause();
      isPlaying(false);
    } catch (e) {
      isPlaying(false);
    }
  }

  resumeSong() {
    duration = convertSecondsToDuration(nowPlaying.duration);
    audioPlayer.resume();
    isPlaying(true);
  }

  Future<void> addToNowPlaying(int idx) async {
    nowPlaying = currentPlayingList[idx];
    isPlayingIdx(idx);
    playSong();
  }

  prevSong() {
    if (isPlayingIdx.value > 0) {
      isPlayingIdx(isPlayingIdx.value - 1);
      nowPlaying = currentPlayingList[isPlayingIdx.value];

      // Reset slider state
      dragValue = null;
      position = Duration.zero;
      duration = Duration.zero;

      playSong();
    } else {
      showMessage('This is the first song.');
      isPlaying(false);
    }
  }

  nextSong() {
    if (isShuffle) {
      shuffledList();
    } else {
      if (isPlayingIdx.value < currentPlayingList.length - 1) {
        isPlayingIdx(isPlayingIdx.value + 1);
        nowPlaying = currentPlayingList[isPlayingIdx.value];

        // Reset slider state
        dragValue = null;
        position = Duration.zero;
        duration = Duration.zero;

        playSong();
      } else {
        showMessage('This is the last song.');
        isPlaying(false);
      }
    }
  }

  songLoop() async {
    if (isRepeat == false) {
      await audioPlayer.setReleaseMode(ReleaseMode.loop);
      isRepeat = true;
      showMessage('Repeat this song');
    } else {
      await audioPlayer.setReleaseMode(ReleaseMode.release);
      isRepeat = false;
      showMessage('Repeat turned off');
    }
  }

  songShuffle() {
    isShuffle = !isShuffle;
    showMessage(isShuffle ? 'Shuffle is on' : 'Shuffle off');
  }

  shuffledList() {
    var randomSongIdx = math.Random().nextInt(currentPlayingList.length);
    isPlayingIdx(randomSongIdx);
    nowPlaying = currentPlayingList[randomSongIdx];

    // Reset slider state
    dragValue = null;
    position = Duration.zero;
    duration = Duration.zero;

    playSong();
  }

  formatTime(value) {
    if (value is int) {
      convertSecondsToDuration(value);
    } else {
      if (value.inSeconds == 0) {
        return '00:00';
      } else {
        final hh = (value.inHours).toString().padLeft(2, '0');
        final mm = (value.inMinutes % 60).toString().padLeft(2, '0');
        final ss = (value.inSeconds % 60).toString().padLeft(2, '0');
        return hh != '00' ? '$hh:$mm:$ss' : '$mm:$ss';
      }
    }
  }

  convertSecondsToDuration(value) {
    duration = Duration(milliseconds: value);
    return duration;
  }

  searchSong(name) async {
    var results = await audioQuery.queryWithFilters(
      name,
      WithFiltersType.AUDIOS,
    );
    allSongs = results.toSongModel();
  }

  Function debounce(Function function, Duration duration) {
    Timer? timer;
    return () {
      if (timer != null) {
        timer!.cancel();
      }
      timer = Timer(duration, () => function());
    };
  }


  // for playlist

  // addPlaylist(name) async {
    // bool success = await audioQuery.createPlaylist(name);
    // if(success) {
    //   getPlayList();
    // } else {
    //   showMessage('Failed to create PlayList');
    // }
  // }

  // removePlaylist(id) async {
  //   bool success = await audioQuery.removePlaylist(id);
  //   if(success) {
  //     getPlayList();
  //   } else {
  //     showMessage('Failed to create PlayList');
  //   }
  // }

  // renamePlaylist(id, name) async {
  //   try {
  //     var success = await audioQuery.renamePlaylist(id, name);
  //     if(success) {
  //       Get.back();
  //       Get.back();
  //       getPlayList();
  //       return true;
  //     } else {
  //       showMessage('Failed to create PlayList');
  //       return false;
  //     }
  //   } catch (e) {
  //     showMessage('Rename failed!!! \n Please try again later');
  //     return false;
  //   }
  // }

  // addToPlaylist(playlistId, audioId) async {
  //   try {
  //     var success = await audioQuery.addToPlaylist(playlistId, audioId);
  //     if(success) {
  //       getPlayList();
  //       return true;
  //     } else {
  //       showMessage('Failed to add to PlayList');
  //       return false;
  //     }
  //   } catch (e) {
  //     showMessage(e.toString());
  //   }
  // }

}