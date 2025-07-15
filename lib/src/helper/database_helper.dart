import 'dart:async';

import 'package:on_audio_query_forked/on_audio_query.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _db;

  Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'music_player.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE songs (
        id INTEGER PRIMARY KEY,
        _id INTEGER,
        title TEXT,
        artist TEXT,
        album TEXT,
        album_id INTEGER,
        artist_id INTEGER,
        duration INTEGER,
        data TEXT,
        is_music INTEGER,
        genre TEXT,
        genre_id INTEGER,
        bookmark INTEGER,
        composer TEXT,
        date_added INTEGER,
        date_modified INTEGER,
        track INTEGER,
        display_name TEXT,
        display_name_wo_ext TEXT,
        file_extension TEXT,
        size INTEGER,
        is_alarm INTEGER,
        is_audiobook INTEGER,
        is_notification INTEGER,
        is_podcast INTEGER,
        is_ringtone INTEGER
      )
    ''');

    await db.execute('''
      CREATE TABLE current_playing (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        _id INTEGER,
        playing_index INTEGER
      )
    ''');

    await db.execute('''
      CREATE TABLE playlists (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        playlist TEXT NOT NULL,
        numOfSongs INTEGER DEFAULT 0
      )
    ''');

    await db.execute('''
      CREATE TABLE playlist_songs (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        playlist_id INTEGER,
        _id INTEGER,
        FOREIGN KEY (playlist_id) REFERENCES playlists(id),
        FOREIGN KEY (_id) REFERENCES songs(id)
      )
    ''');
  }

  // SONGS
  Future<void> insertSong(SongModel song) async {
    final dbClient = await db;

    await dbClient.insert('songs', {
      'id': song.id,
      '_id': song.id,
      'title': song.title,
      'artist': song.artist,
      'album': song.album,
      'album_id': song.albumId,
      'artist_id': song.artistId,
      'duration': song.duration,
      'data': song.data,
      'is_music': (song.isMusic ?? false) ? 1 : 0,
      'genre': song.genre,
      'genre_id': song.genreId,
      'bookmark': song.bookmark,
      'composer': song.composer,
      'date_added': song.dateAdded,
      'date_modified': song.dateModified,
      'track': song.track,
      'display_name': song.displayName,
      'display_name_wo_ext': song.displayNameWOExt,
      'file_extension': song.fileExtension,
      'size': song.size,
      'is_alarm': (song.isAlarm ?? false) ? 1 : 0,
      'is_audiobook': (song.isAudioBook ?? false) ? 1 : 0,
      'is_notification': (song.isNotification ?? false) ? 1 : 0,
      'is_podcast': (song.isPodcast ?? false) ? 1 : 0,
      'is_ringtone': (song.isRingtone ?? false) ? 1 : 0,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String, dynamic>>> getAllSongs() async {
    final dbClient = await db;
    return await dbClient.query(
      'songs',
      orderBy: 'title COLLATE NOCASE ASC',
    );
  }

  Future<Map<String, dynamic>?> getSongById(int id) async {
    final dbClient = await db;
    final result = await dbClient.query(
      'songs',
      where: 'id = ?',
      whereArgs: [id],
    );
    return result.isNotEmpty ? result.first : null;
  }

  // CURRENT PLAYING
  Future<void> insertCurrentPlaying({required int songId, required int index}) async {
    final dbClient = await db;
    await dbClient.delete('current_playing');
    await dbClient.insert('current_playing', {
      '_id': songId,
      'playing_index': index,
    });
  }

  Future<Map<String, dynamic>?> getCurrentPlaying() async {
    final dbClient = await db;
    final result = await dbClient.query('current_playing', limit: 1);
    return result.isNotEmpty ? result.first : null;
  }

  // PLAYLISTS
  Future<int> createPlaylist(String name) async {
    final dbClient = await db;
    return await dbClient.insert('playlists', {'playlist': name});
  }


  // Future<List<Map<String, dynamic>>> getPlaylists() async {
  //   final dbClient = await db;
  //   return await dbClient.query('playlists');
  // }

  // Future<void> deletePlaylist(int id) async {
  //   final dbClient = await db;
  //   await dbClient.delete('playlist_songs', where: 'playlist_id = ?', whereArgs: [id]);
  //   await dbClient.delete('playlists', where: 'id = ?', whereArgs: [id]);
  // }

  // Future<void> renamePlaylist(int id, String newName) async {
  //   final dbClient = await db;
  //   await dbClient.update(
  //     'playlists',
  //     {'name': newName},
  //     where: 'id = ?',
  //     whereArgs: [id],
  //   );
  // }

  // // PLAYLIST SONGS
  // Future<void> addSongToPlaylist(int playlistId, int songId) async {
  //   final dbClient = await db;
  //   await dbClient.insert('playlist_songs', {
  //     'playlist_id': playlistId,
  //     'song_id': songId
  //   });
  // }

  // Future<List<Map<String, dynamic>>> getSongsFromPlaylist(int playlistId) async {
  //   final dbClient = await db;
  //   return await dbClient.rawQuery('''
  //     SELECT songs.* FROM songs
  //     INNER JOIN playlist_songs ON songs.id = playlist_songs.song_id
  //     WHERE playlist_songs.playlist_id = ?
  //   ''', [playlistId]);
  // }

  // Future<void> removeSongFromPlaylist(int playlistId, int songId) async {
  //   final dbClient = await db;
  //   await dbClient.delete('playlist_songs',
  //     where: 'playlist_id = ? AND song_id = ?',
  //     whereArgs: [playlistId, songId]
  //   );
  // }
}
