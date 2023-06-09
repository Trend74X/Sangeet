import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:sangeet/src/widgets/show_message.dart';

class AudioController extends GetxController {
  final OnAudioQuery audioQuery = OnAudioQuery();
  final AudioPlayer audioPlayer = AudioPlayer(); 

  // ignore: prefer_typing_uninitialized_variables
  var nowPlaying;
  bool _hasPermission = false;
  RxList allSongs = [].obs;
  int isPlayingIdx = 0;
  bool isRepeat = false; 
  bool isShuffle = false; 
  RxBool isPlaying = false.obs;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  getAllFiles() {
    checkAndRequestPermissions();
  }

  checkAndRequestPermissions({bool retry = false}) async {
    // The param 'retryRequest' is false, by default.
    _hasPermission = await audioQuery.checkAndRequest(
      retryRequest: retry,
    );
    if(_hasPermission) {
      var data = await audioQuery.querySongs(
        sortType: SongSortType.TITLE,
        orderType: OrderType.ASC_OR_SMALLER,
        uriType: UriType.EXTERNAL,
        ignoreCase: true
      );
      allSongs(data);
      nowPlaying = data[0];
      convertSecondsToDuration(nowPlaying.duration);
      // duration = formatTime(time);
    }
  }

  playSong() async {
    try {
      convertSecondsToDuration(nowPlaying.duration);
      audioPlayer.play(DeviceFileSource(nowPlaying.data));
      isPlaying(true);
    } catch(e) {
      isPlaying(false);
    }
  }

  pauseSong() async {
    try {
      audioPlayer.pause();
      isPlaying(false);
    } catch(e) {
      isPlaying(false);
    }
  }

  resumeSong() async {
    duration = convertSecondsToDuration(nowPlaying.duration);
    await audioPlayer.resume();
    isPlaying(true);
  }

  addToNowPlaying(idx) {
    nowPlaying = allSongs[idx];
    isPlayingIdx = idx;
    playSong();
  }

  prevSong() {
    if(isPlayingIdx >= 0) {
      isPlayingIdx = isPlayingIdx - 1;
      nowPlaying = allSongs[isPlayingIdx];
      playSong();
    } else {
      showMessage('There is the first song');
      isPlaying(false);
    }
  }

  songLoop() async {
    if(isRepeat == false) {
      await audioPlayer.setReleaseMode(ReleaseMode.loop);
      isRepeat = true;
      showMessage('Repeat this song');
    } else {
      await audioPlayer.setReleaseMode(ReleaseMode.release);
      isRepeat = false;
      showMessage('Repeat turned off');
    }
  }

  songShuffle() async {
    if(isShuffle == false) {
      isShuffle = true;
      showMessage('Shuffle is on');
    } else {
      isShuffle = false;
      showMessage('Shuffle off');
    }
  }

  nextSong() {
    if(isShuffle) {
      shuffledList();
    } else {
      if(isPlayingIdx < allSongs.length) {
        isPlayingIdx = isPlayingIdx + 1;
        nowPlaying = allSongs[isPlayingIdx];
        playSong();
      } else {
        showMessage('There are no more songs');
        isPlaying(false);
      }
    }
  }

  shuffledList() async {
    var randomSongIdx = Random().nextInt(allSongs.length + 1);
    isPlayingIdx = randomSongIdx;
    nowPlaying = allSongs[randomSongIdx];
    playSong();

    // var random = Random();
    // allSongs.shuffle(random); // Shuffle the list of audio file URLs
    // for (var audioFile in audioFiles) {
    //   await audioPlayer.play(audioFile);
    // }

  }

  formatTime(value) {
    if(value is int) {
      convertSecondsToDuration(value);
    } else {
      if(value.inSeconds == 0) {
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
    duration  = Duration(milliseconds: value);
    return duration;
  }

}