import 'package:flutter/material.dart';
import 'package:flutter_app/view_model/theme_view_model.dart';

/// 小说页面
class NovelPage extends StatefulWidget {
  @override
  _NovelPageState createState() => _NovelPageState();
}

class _NovelPageState extends State<NovelPage> {
  @override
  Widget build(BuildContext context) {
    var headline1 = Theme.of(context).textTheme.headline1;
    var headline2 = Theme.of(context).textTheme.headline2;
    var headline3 = Theme.of(context).textTheme.headline3;
    var headline4 = Theme.of(context).textTheme.headline4;
    var headline5 = Theme.of(context).textTheme.headline5;
    var headline6 = Theme.of(context).textTheme.headline6;
    var subtitle1 = Theme.of(context).textTheme.subtitle1;
    var subtitle2 = Theme.of(context).textTheme.subtitle2;
    var bodyText1 = Theme.of(context).textTheme.bodyText1;
    var bodyText2 = Theme.of(context).textTheme.bodyText2;
    var caption = Theme.of(context).textTheme.caption;

    var button = Theme.of(context).textTheme.button;

    var overline = Theme.of(context).textTheme.overline;
    var self = AppTheme.titleStyle(context);
    var defaultTextStyle = DefaultTextStyle.of(context).style;
    Map <String, TextStyle> styles = {
      'headline1':headline1!, 
    'headline2':headline2!, 
    'headline3':headline3!,
    'headline4':headline4!,
    'headline5':headline5!,
    'headline6':headline6!,
    'subtitle1':subtitle1!,
    'subtitle2':subtitle2!,
    'bodyText1':bodyText1!,
    'bodyText2':bodyText2!,
    'caption':caption!,
    'button':button!,
    'overline':overline!,
    'defaultTextStyle':defaultTextStyle,
    'self':self
    };
    

    return Scaffold(
      body: ListView.builder(
        itemBuilder: (context, index) {
          var key = styles.keys.toList()[index];
          var style = styles[key];
          return Container(
            padding: EdgeInsets.only(top: 30),
            child: Center(
              child: Text(
                '$key => ${style!.fontSize} => ${style.color}',
                style: style,
              ),
            ),
          );
        },
        itemCount: styles.keys.length,
      ),
    );
  }
}
