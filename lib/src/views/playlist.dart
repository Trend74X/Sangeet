// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:on_audio_query/on_audio_query.dart';
// import 'package:sangeet/src/controller/audio_controller.dart';
// import 'package:sangeet/src/widgets/add_rename_playlist.dart';
// import 'package:sangeet/src/widgets/bottom_sheet.dart';
// import 'package:sangeet/src/widgets/custom_dialog.dart';

// class PlayList extends StatefulWidget {
//   const PlayList({super.key});

//   @override
//   State<PlayList> createState() => _PlayListState();
// }

// class _PlayListState extends State<PlayList> {

//   final AudioController _con = Get.find();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SingleChildScrollView(
//         child: Obx(() => 
//           _con.playlists.isEmpty
//             ? InkWell(
//               onTap: () => addRenamePlaylist(context),
//               child: SizedBox(
//                 height: MediaQuery.of(context).size.height * 0.8, 
//                 width: MediaQuery.of(context).size.width, 
//                 child: const Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     Icon(
//                       Icons.add,
//                       size: 40.0,
//                     ),
//                     SizedBox(height: 8.0),
//                     Text(
//                       'Create A Playlist.',
//                       style: TextStyle(
//                         color: Colors.grey
//                       ),
//                     )
//                   ] 
//                 )
//               ),
//             )
//             : playList()
//         ),
//       )
//     );
//   }

//   playList() {
//     return ListView.separated(
//       itemCount: _con.playlists.length,
//       shrinkWrap: true,
//       separatorBuilder: (context, index) => const Divider(),
//       physics: const ClampingScrollPhysics(),
//       itemBuilder: (context, index) {
//         return ListTile(
//           tileColor: Theme.of(context).scaffoldBackgroundColor,
//           leading:  QueryArtworkWidget(
//             controller: _con.audioQuery,
//             id: _con.playlists[index]['id'],
//             type: ArtworkType.PLAYLIST,
//             nullArtworkWidget: const Image(
//               image: AssetImage('assets/images/appIcon.png'),
//               width: 40.0,
//               height: 40.0,
//             )
//           ),
//           title: SizedBox(
//             width: MediaQuery.of(context).size.width * 0.75,
//             child: Text(
//               _con.playlists[index].playlist,
//               overflow: TextOverflow.ellipsis
//             )
//           ),
//           subtitle: Row(
//             children: [
//               const Icon(
//                 Icons.album,
//                 size: 18
//               ),
//               Text(
//                 ' ${_con.playlists[index].numOfSongs} Songs',
//                 overflow: TextOverflow.ellipsis
//               ),
//             ],
//           ),
//           trailing: IconButton(
//             icon: const Icon(
//               Icons.more_vert
//             ),
//             onPressed: () => moreBottomSheet(index, _con.playlists[index]), 
//           ),
//           onTap: () {
//             // _con.getFilteredSongs('artist' , null, _con.playlists[index].id, _con.playlists[index].artist);
//             // setState(() { });
//           },
//         );
//       }
//     );
//   }

//   moreBottomSheet(index, item) {
//     return bottomSheet(
//       context, 
//       Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           InkWell(
//             onTap: () {
//               Get.back();
//               // addRenamePlaylist(context, item.id);              
//             },
//             child: const SizedBox(
//               width: double.infinity,
//               child: Row(
//                 children: [
//                   Icon(
//                     Icons.edit,
//                     size: 30.0,
//                   ),
//                   SizedBox(width: 20.0),
//                   Text(
//                     'Rename Playlist',
//                     style: TextStyle(
//                       fontSize: 16.0
//                     ),
//                   )
//                 ],
//               ),
//             ),
//           ),
//           const SizedBox(height: 20.0),
//           InkWell(
//             onTap: () {
//               Get.back();
//               customAlertDialog(
//                 'Yes',
//                 () => {}, //_con.removePlaylist(item.id),
//                 'Cancel',
//                 null,
//                 'You are about to remove a playlist. \n Are you sure?'
//               );
//             },
//             child: const SizedBox(
//               width: double.infinity,
//               child: Row(
//                 children: [
//                   Icon(
//                     Icons.delete,
//                     size: 30.0,
//                   ),
//                   SizedBox(width: 20.0),
//                   Text(
//                     'Remove Playlist',
//                     style: TextStyle(
//                       fontSize: 16.0
//                     ),
//                   )
//                 ],
//               ),
//             ),
//           )
//         ],
//       )
//     );
//   }

// }