import 'package:flutter/material.dart';
import 'package:photo_viewer/photo_model.dart';
import 'package:photo_viewer/service/api_service.dart';

class PhotoProvider extends ChangeNotifier {
  final _services = ApiServices();
  int _page = 1;
  int get page => _page;
  bool isLoadMoreRunning = false;
  bool isFirstLoadRunning = false;
  bool hasNextPage = true;
  final ScrollController controller = ScrollController();
  set page(int value) {
    _page = value;
    notifyListeners();
  }

  List<Photo> _photosList = <Photo>[];
  List<Photo> get photosList => _photosList;
  set photosList(List<Photo> value) {
    _photosList = value;
  }

// load first page
  void firstLoad() async {
    isFirstLoadRunning = true;
    notifyListeners();
    await _services.photoServices(_page).then((response) {
      for (var item in response) {
        if (response.length - 1 >= _photosList.length) {
          addFeaturedToList(item);
          notifyListeners();
        }
      }
    });
    isFirstLoadRunning = false;
    notifyListeners();
  }

// for next page load
  double controllermaxScroll = 0;
  double controllerpixels = 0;
  void loadMore() async {
    if (controller.hasClients) {
      controllermaxScroll = controller.position.maxScrollExtent;
      controllerpixels = controller.position.pixels;
    }
    if (hasNextPage == true &&
        isFirstLoadRunning == false &&
        isLoadMoreRunning == false &&
        (controllerpixels == controllermaxScroll)) {
      isLoadMoreRunning = true;
      notifyListeners();
      if (hasNextPage == true) {
        _page = _page + 1;
        await _services.photoServices(_page).then((response) {
          List<Photo> fetchedData = [];
          for (var item in response) {
            fetchedData.add(item);
            notifyListeners();
          }
          if (fetchedData.isNotEmpty) {
            _photosList.addAll(fetchedData);
            notifyListeners();
          } else {
            hasNextPage = false;
            notifyListeners();
          }
        });
      }
      isLoadMoreRunning = false;
      notifyListeners();
    }
  } // add to list

  void addFeaturedToList(Photo featuredData) {
    _photosList.add(featuredData);
    notifyListeners();
  }
}
