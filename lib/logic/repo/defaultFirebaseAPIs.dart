import '/logic/repo/API_Credentials.dart';
import '/logic/repo/firebaseAPI.dart';

abstract class DefaultFirebaseAPIs {
  static FirebaseAPI get playlistsBlock => FirebaseAPI(
      api: API_Credentials.playlistsBlockApi.apiDomain,
      auth: API_Credentials.playlistsBlockApi.authId);

  static FirebaseAPI get playlists => FirebaseAPI(
      api: API_Credentials.playlistsApi.apiDomain,
      auth: API_Credentials.playlistsApi.authId);

  static FirebaseAPI get songs => FirebaseAPI(
      api: API_Credentials.songsApi.apiDomain,
      auth: API_Credentials.songsApi.authId);

  static FirebaseAPI get songsBlock => FirebaseAPI(
      api: API_Credentials.songsBlockApi.apiDomain,
      auth: API_Credentials.songsBlockApi.authId);
}
