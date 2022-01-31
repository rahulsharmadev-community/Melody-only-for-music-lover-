// ignore_for_file: camel_case_types,file_names

class API_PROFILE {
  final String authId;
  final String apiDomain;
  API_PROFILE({required this.authId, required this.apiDomain});
}

abstract class API_Credentials {
  static API_PROFILE get songsApi => API_PROFILE(
      authId: '2022khk013123494', apiDomain: 'https://www.example.com/songs');

  static API_PROFILE get playlistsApi => API_PROFILE(
      authId: '2022khk013123494www.example',
      apiDomain: 'https://www.example.com/playlists');

  static API_PROFILE get songsBlockApi => API_PROFILE(
      authId: '2022khk013123494www.example',
      apiDomain: 'https://www.example.com/songsblock');

  static API_PROFILE get playlistsBlockApi => API_PROFILE(
      authId: '2022khk013123494www.example',
      apiDomain: 'https://www.example.com/playlistsblock');
}
