import 'dart:async';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

import 'Model.dart';

enum UserAction { Scroll }

class ExploreBloc {
  final _exploreResultStreamController =
      StreamController<List<ExploreResult>>();
  StreamSink<List<ExploreResult>> get _exploreResultSink =>
      _exploreResultStreamController.sink;
  Stream<List<ExploreResult>> get exploreResultStream =>
      _exploreResultStreamController.stream;

  final _exploreEventStreamController = StreamController<UserAction>();
  StreamSink<UserAction> get exploreEventSink =>
      _exploreEventStreamController.sink;
  Stream<UserAction> get _exploreEventStream =>
      _exploreEventStreamController.stream;

  ExploreBloc() {
    _exploreEventStream.listen(onDataReceived);

    //  _exploreEventStream.listen((event)  {
    //   if (event == UserAction.Scroll) {
    //     _fetchImages().then((exploreResult)
    //      {
    //       _exploreResultSink.add(exploreResult);
    //       });

    //   }
    // });
  }

  void onDataReceived(UserAction action) async {
    if (action == UserAction.Scroll) {
      List<ExploreResult> exploreResult = await _fetchImages();
      _exploreResultSink.add(exploreResult);
    }
  }

  void dispose() {
    _exploreEventStreamController.close();
    _exploreResultStreamController.close();
  }

  Future<List<ExploreResult>> _fetchImages() async {
    List<ExploreResult> imageURLmasterlist = []; //final list of image urls

    String apiURL = "https://picsum.photos/v2/list";

    var image = await http.get(apiURL);

    List<dynamic> listImageMaps =
        convert.jsonDecode(image.body); //jsondecode returns a list of maps

    listImageMaps.forEach((imageMap) {
      //iterate the listimagemaps to get a map and from that map get required url
      ExploreResult temp =
          ExploreResult(); //url in map is a string, so create a instance of the model and assign url to it
      temp.url = imageMap["download_url"];
      imageURLmasterlist.add(
          temp); //finally, add the url after each iteration into the final list
    });

    // for (var imageMap in listImageMaps) {
    //   ExploreResult temp = ExploreResult();
    //   temp.url = imageMap["url"];
    //   images.add(temp);
    // }

    // for (int i = 0; i < listImageMaps.length; ++i) {
    //   var imageMap = listImageMaps[i];

    //   ExploreResult temp = ExploreResult();
    //   temp.url = imageMap["url"];
    //   images.add(temp);
    // }

    return imageURLmasterlist;
  }
}
