import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sangeet/src/controller/app_controller.dart';
import 'package:sangeet/src/views/music_list_tab.dart';
import 'package:sangeet/src/views/now_playing.dart';

class BottomNavigation extends StatefulWidget {
  final int index;
  const BottomNavigation({super.key, this.index = 0});

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> with WidgetsBindingObserver{

  final AppController appCon = Get.put(AppController());

  int _curIdx = 0;

  static final List<Widget> _pages = <Widget>[
    const NowPlaying(),
    const MusicListTab()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _curIdx = index;
    });
  }

  @override
  void initState() {
    _curIdx =  widget.index;
    appCon.checkOnlineStatus();
    super.initState();
    // WidgetsBinding.instance.addObserver(this);
  }

  // @override
  // void dispose() {
  //   WidgetsBinding.instance.removeObserver(this);
  //   super.dispose();
  // }

  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   if(state == AppLifecycleState.paused || state == AppLifecycleState.inactive) {     // pausing audio when app is minimized
  //     // _con.pauseSong(); 
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: _pages.elementAt(_curIdx),
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _curIdx,
          selectedItemColor: Theme.of(context).primaryColor,
          onTap: _onItemTapped,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.queue_music,
              ),
              label: 'Now Playing'
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.list,
              ),
              label: 'All Music'
            )
          ]
        ),
      ),
    );
  }
}