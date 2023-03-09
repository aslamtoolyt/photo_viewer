import 'package:flutter/material.dart';
import 'package:photo_viewer/provider/photo_provider.dart';
import 'package:photo_viewer/thumbnail.dart';
import 'package:provider/provider.dart';

class PhotoListViews extends StatefulWidget {
  const PhotoListViews({super.key});

  @override
  _PhotoListViewsState createState() => _PhotoListViewsState();
}

class _PhotoListViewsState extends State<PhotoListViews> {
  ScrollController scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<PhotoProvider>(context, listen: false).firstLoad();
    });
    Provider.of<PhotoProvider>(context, listen: false).controller.addListener(
        Provider.of<PhotoProvider>(context, listen: false).loadMore);
  }

  @override
  void dispose() {
    Provider.of<PhotoProvider>(context, listen: false)
        .controller
        .removeListener(
            Provider.of<PhotoProvider>(context, listen: false).loadMore);
    super.dispose();
  }

  Widget build(BuildContext context) {
    final photoProvider = Provider.of<PhotoProvider>(context, listen: false);
    return Scaffold(
        appBar: AppBar(title: Text("CybPress")),
        body: Consumer<PhotoProvider>(
          builder: (context, data, _) {
            return photoProvider.isFirstLoadRunning
                ? const Center(child: CircularProgressIndicator())
                : Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                            controller: photoProvider.controller,
                            itemCount: data.photosList.length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                child: Column(children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16.0, horizontal: 16),
                                    child: Stack(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                              color: Colors.black12,
                                              borderRadius:
                                                  BorderRadius.circular(12)),
                                          height: 250,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Image.network(
                                              data.photosList[index]
                                                  .thumbnailUrl,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                            bottom: 20,
                                            left: 20,
                                            child: Align(
                                                alignment:
                                                    Alignment.bottomCenter,
                                                child: Container(
                                                  child: Text(
                                                    data.photosList[index]
                                                        .title,
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                      color: Colors.deepOrange,
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                ))),
                                      ],
                                    ),
                                  ),

                                ]),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => PhotoDetailView(
                                            photo: data.photosList[index])),
                                  );
                                },
                              );
                            }),
                      ),
                      if (photoProvider.isLoadMoreRunning == true)
                        const CircularProgressIndicator(),
                      if (photoProvider.hasNextPage) Container()
                    ],
                  );
          },
        ));
  }
}
