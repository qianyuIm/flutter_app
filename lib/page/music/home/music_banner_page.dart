import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/config/inch.dart';
import 'package:flutter_app/helper/image_helper.dart';
import 'package:flutter_app/provider/provider_widget.dart';
import 'package:flutter_app/provider/view_state_widget.dart';
import 'package:flutter_app/view_model/music/music_view_model.dart';
import 'package:flutter_app/widget/image_load_view.dart';

class MusicBannerPage extends StatefulWidget {
  @override
  _MusicBannerPageState createState() => _MusicBannerPageState();
}

class _MusicBannerPageState extends State<MusicBannerPage> {
  @override
  Widget build(BuildContext context) {
    return ProviderWidget<MusicBannerViewModel>(
      viewModel: MusicBannerViewModel(),
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

  Widget _buildCarouselSlider(MusicBannerViewModel viewModel) {
    return Padding(
      padding: EdgeInsets.only(top: 10),
      child: CarouselSlider(
        options: CarouselOptions(
          autoPlay: true,
          height: Inchs.adapter(134),
          aspectRatio: 343 / 134,
          viewportFraction: 0.9,
          autoPlayInterval: Duration(seconds: 5),
          enlargeCenterPage: true,
        ),
        items: viewModel.banners
            .map((banner) => ImageLoadView(
                  imagePath:
                      ImageCompressHelper.musicCompress(banner.pic, 343, 134),
                  radius: 5,
                ))
            .toList(),
      ),
    );
  }
}
