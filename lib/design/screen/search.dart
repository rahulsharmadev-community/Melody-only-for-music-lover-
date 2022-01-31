import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:melody/logic/blocs/audioservice_cubit/audio_cubit.dart';
import 'package:melody/logic/objects/song.dart';
import 'package:melody/logic/repo/database.dart';
import 'package:melody/logic/repo/defaultFirebaseAPIs.dart';
import '/logic/service/iScaffold.dart';
import '../widget/commonWidgets.dart';
import 'package:provider/provider.dart';

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  late ScrollController _controller;
  final TextEditingController _textController = TextEditingController();
  List<Song> _searchList = [];

  Future<void> fetchAndsetdata() async {
    var database = Provider.of<Database>(context, listen: false);
    showSnackBar(context, 'Loading...');
    var jsonData = await DefaultFirebaseAPIs.songs.rangeQuery(
        startAt: database.songsList.isNotEmpty
            ? '"${database.songsList.last.id}>>"'
            : '',
        range: 30,
        path: '',
        orderBy: '\$key');

    if (jsonData?.isEmpty ?? true) {
      showSnackBar(context, 'No Data Found!');
    }
    jsonData!.forEach((key, value) {
      (value as Map<String, dynamic>).addAll({"id": key});
      database.addSongs(Song.fromJson((value)));
    });
  }

  Future<void> searchIn() async {
    List<Song> tempList = [];
    if (_textController.text.length > 1) {
      var jsonData = await DefaultFirebaseAPIs.songs
          .searchByKey(query: _textController.text, path: '', orderBy: 'title');
      jsonData!.forEach((key, value) {
        (value as Map<String, dynamic>).addAll({"id": key});
        tempList.add(Song.fromJson((value)));
      });
      _searchList = tempList;
    } else {
      _searchList.clear();
    }
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = ScrollController();
    _controller.addListener(_scrollListener);
    if (Provider.of<Database>(context, listen: false).songsList.isEmpty) {
      Future.delayed(Duration.zero, () {
        fetchAndsetdata();
      });
    }
  }

  _scrollListener() {
    if (_controller.offset >= _controller.position.maxScrollExtent &&
        !_controller.position.outOfRange) {
      fetchAndsetdata();
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Database>(builder: (context, database, child) {
      return BlocBuilder<AudioCubit, AudioState>(
        builder: (context, _asp) => IScafford(
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            floatingActionButton: Container(
              margin: EdgeInsets.only(
                  bottom: _asp.playbackState!.processingState !=
                          AudioProcessingState.idle
                      ? 80
                      : 16,
                  left: 16,
                  right: 16),
              height: 48,
              child: TextField(
                style: const TextStyle(color: Colors.white60),
                controller: _textController,
                keyboardType: TextInputType.name,
                onSubmitted: (value) => searchIn(),
                onChanged: (value) => setState(() {}),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Theme.of(context).canvasColor,
                  hintText: 'Search',
                  hintStyle: const TextStyle(color: Colors.white60),
                  contentPadding: EdgeInsets.zero,
                  suffixIcon: _textController.text.isNotEmpty
                      ? IconButton(
                          color: Colors.white60,
                          onPressed: () {
                            _textController.clear();
                            searchIn();
                          },
                          icon: const Icon(Icons.clear_rounded))
                      : null,
                  prefixIcon: const Icon(
                    Icons.search,
                    color: Colors.white60,
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
            body: database.songsList.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : _searchList.isNotEmpty
                    ? ListView.builder(
                        itemCount: _searchList.length,
                        itemBuilder: (itemBuilder, index) => Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ListTile(
                                  onTap: () {
                                    _asp.audioPlayerHandler.updateQueue(
                                        [_searchList[index].toMediaItem()]);
                                    _asp.audioPlayerHandler.seek(Duration.zero);
                                    _asp.audioPlayerHandler.play();
                                  },
                                  leading: Image.asset(
                                    'assets/images/placeholder.png',
                                    height: 30,
                                    alignment: Alignment.center,
                                  ),
                                  title: Text(_searchList[index].title),
                                  subtitle: Text(_searchList[index].artist)),
                            ))
                    : ListView.builder(
                        itemCount: database.songsList.length,
                        controller: _controller,
                        itemBuilder: (itemBuilder, index) => Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ListTile(
                                  onTap: () {
                                    _asp.audioPlayerHandler.updateQueue([
                                      database.songsList[index].toMediaItem()
                                    ]);
                                    _asp.audioPlayerHandler.seek(Duration.zero);
                                    _asp.audioPlayerHandler.play();
                                  },
                                  leading: Image.asset(
                                    'assets/images/placeholder.png',
                                    height: 30,
                                    alignment: Alignment.center,
                                  ),
                                  title: Text(database.songsList[index].title),
                                  subtitle:
                                      Text(database.songsList[index].artist)),
                            ))),
      );
    });
  }
}
