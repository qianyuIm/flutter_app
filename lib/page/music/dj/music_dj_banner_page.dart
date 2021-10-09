import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/config/inch.dart';
import 'package:flutter_app/provider/provider_widget.dart';
import 'package:flutter_app/provider/view_state_widget.dart';
import 'package:flutter_app/view_model/dj/music_dj_view_model.dart';
import 'package:flutter_app/view_model/theme_view_model.dart';
import 'package:flutter_app/widget/image_load_view.dart';


class MusicDJBannerPage extends StatefulWidget {
  @override
  _MusicDJBannerPageState createState() => _MusicDJBannerPageState();
}

class _MusicDJBannerPageState extends State<MusicDJBannerPage> {

  late double _bannerHeight;
  @override
  void initState() {
    _bannerHeight = Inchs.screenWidth * 0.85 * 287 / 738;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ProviderWidget<MusicDJBannerViewModel>(
      viewModel: MusicDJBannerViewModel(),
      onModelReady: (viewModel) => viewModel.initData(),
      builder: (context, viewModel, child) {
        if (viewModel.isBusy) {
          return ViewStateBusyWidget();
        } else if (viewModel.isError && viewModel.banners.isEmpty) {
          return ViewStateErrorWidget(
              error: viewModel.viewStateError!, onPressed: viewModel.initData);
        } else if (viewModel.isEmpty) {
          return ViewStateEmptyWidget(onPressed: viewModel.initData);
        }
        return _buildCarouselSlider(viewModel);
      },
    );
  }

  Widget _buildCarouselSlider(MusicDJBannerViewModel viewModel) {
    
    return Container(
      color: AppTheme.scaffoldBackgroundColor(context),
      child: CarouselSlider(
        options: CarouselOptions(
          autoPlay: true,
          aspectRatio: 738 / 287,
          height: _bannerHeight,
          viewportFraction: 0.85,
          autoPlayInterval: Duration(seconds: 5),
          enlargeCenterPage: true,
        ),
        items: viewModel.banners
            .map((banner) => ImageLoadView(
                  imagePath:
                      banner.pic,
                  radius: 5,
                ))
            .toList(),
      ),
    );
  }
}

