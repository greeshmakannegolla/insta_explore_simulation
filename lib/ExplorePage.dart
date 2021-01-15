import 'package:flutter/material.dart';
import 'package:insta_explore/ExploreBloc.dart';
import 'package:insta_explore/Model.dart';

class ExplorePage extends StatefulWidget {
  @override
  _ExplorePageState createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  ExploreBloc exploreBloc = ExploreBloc();
  List<ExploreResult> masterList = [];

  @override
  void initState() {
    super.initState();
    exploreBloc.exploreEventSink.add(UserAction.Scroll);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Text(
              "Explore",
              style: TextStyle(fontSize: 30),
            ),
            SizedBox(
              height: 15,
            ),
            Expanded(
              child: StreamBuilder<List<ExploreResult>>(
                  stream: exploreBloc.exploreResultStream,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return CircularProgressIndicator();
                    masterList += snapshot.data;
                    return GridView.builder(
                      //(snapshot.data as List<ExploreResult>).length,
                      itemCount: masterList.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3),
                      itemBuilder: (BuildContext context, int index) {
                        if (index == (masterList.length - 1)) {
                          exploreBloc.exploreEventSink.add(UserAction.Scroll);
                        }
                        return new Card(
                          child: new GridTile(
                            child: Image.network(masterList[index].url),
                          ),
                        );
                      },
                    );
                  }),
            )
          ],
        ),
      ),
    );
  }
}
