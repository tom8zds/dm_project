import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

enum WidgetState { loading, done, fail }

class RecommendList extends StatefulWidget {
  final String api;

  const RecommendList({Key key, this.api}) : super(key: key);

  @override
  State<StatefulWidget> createState() => RecommendListState();
}

class RecommendListState extends State<RecommendList> {
  WidgetState widgetState = WidgetState.loading;

  @override
  void initState() {
    loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return EasyRefresh(
        header: MaterialHeader(),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 6,
          itemBuilder: (context, i) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                height: 3 * kToolbarHeight,
                width: 5 * kToolbarHeight,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [Colors.white, Colors.grey[300]],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey,
                          blurRadius: 12,
                          offset: Offset(4, 4))
                    ]),
                child: getItem(),
              ),
            );
          },
        ),
        onRefresh: loadData);
  }

  Widget getItem() {
    switch (widgetState) {
      case WidgetState.loading:
        return Center(child: CircularProgressIndicator());
      case WidgetState.done:
        return Text('data');
      case WidgetState.fail:
        return Text('fail');
      default:
        return Text('fail');
    }
  }

  Future<bool> loadData() async {
    setState(() {
      widgetState = WidgetState.loading;
    });
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      widgetState = WidgetState.done;
    });
    return true;
  }
}
