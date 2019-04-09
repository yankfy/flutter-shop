import 'package:flutter/material.dart';
import './../service/service_method.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

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
            print((data['data']['category'] as List));
            // List<Map> navigatorList =
            //     (data['data']['category'] as List).cast(); //类别列表
            List<dynamic> navigatorList = data['data']['category'] as List; //类
            print((data['data']['category'] as List).cast());

            String leaderImage = data['data']['shopInfo']['leaderImage'];
            String leaderPhone = data['data']['shopInfo']['leaderPhone'];

            // AdBanner数据获取
            String advertesPciture =
                data['data']['advertesPicture']['PICTURE_ADDRESS'];

            return Column(
              children: <Widget>[
                SwiperDiy(swiperDataList: swiperDataList), // 页面顶部swiper组件
                TopNavigator(navigatorList: navigatorList),
                AdBanner(advertesPicture: advertesPciture),
                LeaderPhone(leaderImage: leaderImage, leaderPhone: leaderPhone),
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

// 首页导航组件
class TopNavigator extends StatelessWidget {
  final List navigatorList;
  TopNavigator({Key key, this.navigatorList}) : super(key: key);

  Widget _gridViewItemUI(BuildContext context, item) {
    return InkWell(
      onTap: () {
        print('点击了导航');
      },
      child: Column(
        children: <Widget>[
          Image.network(item['image'], width: ScreenUtil().setWidth(95)),
          Text(item['mallCategoryName']),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // 超过10个的List部分进行截掉
    if (navigatorList.length > 10) {
      navigatorList.removeRange(10, navigatorList.length);
    }
    return Container(
      color: Colors.white,
      margin: EdgeInsets.only(top: 5.0),
      height: ScreenUtil().setHeight(320),
      padding: EdgeInsets.all(3.0),
      child: GridView.count(
        physics: NeverScrollableScrollPhysics(),
        crossAxisCount: 5,
        padding: EdgeInsets.all(5.0),
        // children 属性，使用了map循环，再使用toList()进行转换。
        children: navigatorList.map((item) {
          return _gridViewItemUI(context, item);
        }).toList(),
      ),
    );
  }
}

// AdBanner 组件
class AdBanner extends StatelessWidget {
  final String advertesPicture;

  AdBanner({Key key, this.advertesPicture}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Image.network(advertesPicture),
    );
  }
}

// 使用 url_launch 插件进行打开网页和拨打电话的设置
class LeaderPhone extends StatelessWidget {
  final String leaderImage; // 店长图片
  final String leaderPhone; // 店长电话

  LeaderPhone({Key key, this.leaderImage, this.leaderPhone}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: InkWell(
        onTap: _launchURL,
        child: Image.network(leaderImage),
      ),
    );
  }

  void _launchURL() async {
    String url = 'tel:' + leaderPhone;
    if(await canLaunch(url)){
      await launch(url);
    }else{
      throw 'Could not launch $url';
    }
  }
}
