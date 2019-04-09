import 'package:flutter/material.dart';
import './../service/service_method.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:convert';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // String homePageContent = '正在获取数据';
  // @override
  // void initState() {
  //   getHomePageContent().then((val) {
  //     setState(() {
  //       homePageContent = val.toString();
  //     });
  //   });

  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('百姓生活'),
      ),
      // body: SingleChildScrollView(
      //   child: Text(homePageContent),
      // ),
      body: FutureBuilder(
        future: getHomePageContent(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var data = json.decode(snapshot.data.toString());
            // 顶部轮播组件数
            List<dynamic> swiperDataList = (data['data']['slides'] as List);
            return Column(
              children: <Widget>[
                SwiperDiy(swiperDataList: swiperDataList), // 页面顶部swiper组件
              ],
            );
          } else {
            return Center(
              child: Text('加载中'),
            );
          }
        },
      ),
    );
  }
}

// flutter_Swiper 组件的简单使用方法
// FlutterBuilder 解决异步渲染的问题

class SwiperDiy extends StatelessWidget {
  final List swiperDataList;
  SwiperDiy({Key key, this.swiperDataList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // return Container(
    //   height: 333.0,
    //   child: Swiper(
    //     itemBuilder: (BuildContext context, int index) {
    //       return Image.network("${swiperDataList[index]['image']}",
    //           fit: BoxFit.fill);
    //     },
    //     itemCount: swiperDataList.length,
    //     pagination: new SwiperPagination(),
    //     autoplay: true,
    //     // control: new SwiperControl({color:Colors.pinkAccent}),
    //   ),
    // );

    // flutter_ScreenUtil屏幕适配方案，让UI在不同尺寸下的屏幕上都可以显示合理的布局
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);
    print('设备宽度:${ScreenUtil.screenWidth}');
    print('设备高度:${ScreenUtil.screenHeight}');
    print('设备像素密度:${ScreenUtil.pixelRatio}');

    return Container(
      height: ScreenUtil().setHeight(333),
      width: ScreenUtil().setWidth(750),
      child: Swiper(
        itemBuilder: (BuildContext context, int index) {
          return Image.network(
            "${swiperDataList[index]['image']}",
            fit: BoxFit.fill,
          );
        },
        itemCount: swiperDataList.length,
        pagination: new SwiperPagination(),
        autoplay: true,
      ),
    );
  }
}
