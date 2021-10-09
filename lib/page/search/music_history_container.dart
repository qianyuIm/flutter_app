import 'package:flutter/material.dart';
import 'package:flutter_app/config/inch.dart';
import 'package:flutter_app/view_model/search/music_search_view_model.dart';
import 'package:flutter_app/view_model/theme_view_model.dart';
import 'package:provider/provider.dart';

class MusicHistoryContainer extends StatelessWidget {
  final ValueChanged<String>? onSearch;

  const MusicHistoryContainer({Key? key, this.onSearch}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var viewModel = Provider.of<MusicSearchViewModel>(context, listen: false);
    if (!viewModel.hasHistory) return SizedBox.shrink();
    var itemBackgroundColor = AppTheme.cardColor(context);
    return Container(
      height: 50,
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          Positioned(
            left: 60,
            child: Container(
              height: 36,
              width: Inchs.screenWidth - 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: viewModel.historyItems.length,
                itemBuilder: (context, index) {
                  var history = viewModel.historyItems[index];
                  return InkWell(
                    onTap: () {
                      onSearch?.call(history);
                    },
                    child: Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      margin: EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          color: itemBackgroundColor),
                      child: Text(history),
                    ),
                  );
                },
              ),
            ),
          ),
          Positioned(
            left: 0,
            child: Container(
              width: 60,
              height: 30,
              padding: EdgeInsets.only(right: 6),
              alignment: Alignment.centerRight,
              decoration: BoxDecoration(
                  // color: Colors.yellow,
                  boxShadow: [
                    BoxShadow(
                        offset: Offset(10, 0),
                        blurRadius: 10,
                        spreadRadius: 8,
                        color: itemBackgroundColor)
                  ]),
              child: Text(
                '历史',
                style: AppTheme.titleStyle(context),
              ),
            ),
          ),
          Positioned(
            right: 0,
            child: GestureDetector(
              onTap: () {
                viewModel.clearHistory();
              },
              child: Container(
                width: 40,
                height: 30,
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(boxShadow: [
                  BoxShadow(
                      offset: Offset(-10, 0),
                      blurRadius: 10,
                      spreadRadius: 8,
                      color: itemBackgroundColor)
                ]),
                child: Icon(
                  Icons.delete_forever,
                  color: AppTheme.subtitleColor(context),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
