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

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
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

  int page = 1;
  List<Map> hotGoodsList = [];

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    _getHotGoods();
    super.initState();
  }

  void _getHotGoods() {
      var formPage = {'page': page};
      request('homePageBelowConten', formData: formPage).then((val) {
        var data = json.decode(val.toString());
        
        List<Map> newGoodsList = (data['data'] as List).cast();
        print('DATA+$newGoodsList');
        setState(() {
          hotGoodsList.addAll(newGoodsList);
          page++;
        });
      });
    }

  @override
  Widget build(BuildContext context) {

    Widget hotTitle = Container(
      margin: EdgeInsets.only(top: 10.0),
      padding: EdgeInsets.all(5.0),
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: Colors.white,
          border:
              Border(bottom: BorderSide(width: 0.5, color: Colors.black12))),
      child: Text('火爆专区'),
    );

    //火爆专区子项
    Widget _wrapList() {
      if (hotGoodsList.length != 0) {
        List<Widget> listWidget = hotGoodsList.map((val) {
          return InkWell(
              onTap: () {
                print("点击了火爆商品");
                // Application.router.navigateTo(context,"/detail?id=${val['goodsId']}");
              },
              child: Container(
                width: ScreenUtil().setWidth(372),
                color: Colors.white,
                padding: EdgeInsets.all(5.0),
                margin: EdgeInsets.only(bottom: 3.0),
                child: Column(
                  children: <Widget>[
                    Image.network(
                      val['image'],
                      width: ScreenUtil().setWidth(375),
                    ),
                    Text(
                      val['name'],
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: Colors.pink, fontSize: ScreenUtil().setSp(26)),
                    ),
                    Row(
                      children: <Widget>[
                        Text('￥${val['mallPrice']}'),
                        Text(
                          '￥${val['price']}',
                          style: TextStyle(
                              color: Colors.black26,
                              decoration: TextDecoration.lineThrough),
                        )
                      ],
                    )
                  ],
                ),
              ));
        }).toList();

        return Wrap(
          spacing: 2,
          children: listWidget,
        );
      } else {
        return Text(' ');
      }
    }

    //火爆专区组合
    Widget _hotGoods() {
      return Container(
          child: Column(
        children: <Widget>[
          hotTitle,
          _wrapList(),
        ],
      ));
    }

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
            List<Map> swiperDataList = (data['data']['slides'] as List).cast();
            // print((data['data']['category'] as List));
            // List<Map> navigatorList =
            //     (data['data']['category'] as List).cast(); //类别列表
            List<Map> navigatorList = (data['data']['category'] as List).cast(); //类
            // print((data['data']['category'] as List).cast());

            String leaderImage = data['data']['shopInfo']['leaderImage'];
            String leaderPhone = data['data']['shopInfo']['leaderPhone'];

            // AdBanner数据获取
            String advertesPciture =
                data['data']['advertesPicture']['PICTURE_ADDRESS'];

            List<Map> recommendList =
                (data['data']['recommend'] as List).cast();

            // 楼层数据获取
            String floor1Title = data['data']['floor1Pic']['PICTURE_ADDRESS'];
            String floor2Title = data['data']['floor2Pic']['PICTURE_ADDRESS'];
            String floor3Title = data['data']['floor3Pic']['PICTURE_ADDRESS'];

            List<Map> floor1 = (data['data']['floor1'] as List).cast();
            List<Map> floor2 = (data['data']['floor2'] as List).cast();
            List<Map> floor3 = (data['data']['floor3'] as List).cast();

            // 超过边界的处理方法

            return SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  SwiperDiy(swiperDataList: swiperDataList), // 页面顶部swiper组件
                  TopNavigator(navigatorList: navigatorList),
                  AdBanner(advertesPicture: advertesPciture),
                  LeaderPhone(
                      leaderImage: leaderImage, leaderPhone: leaderPhone),
                  Recommend(recommendList: recommendList),
                  FloorTitle(pictureAddress: floor1Title),
                  FloorContent(floorGoodsList: floor1),
                  FloorTitle(pictureAddress: floor2Title),
                  FloorContent(floorGoodsList: floor2),
                  FloorTitle(pictureAddress: floor3Title),
                  FloorContent(floorGoodsList: floor3),
                  // _hotGoods(),
                  // HotGoods(),
                ],
              ),
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
    // print('设备宽度:${ScreenUtil.screenWidth}');
    // print('设备高度:${ScreenUtil.screenHeight}');
    // print('设备像素密度:${ScreenUtil.pixelRatio}');

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
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}

class Recommend extends StatelessWidget {
  final List recommendList;
  Recommend({Key key, this.recommendList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: Column(
          children: <Widget>[_titleWidget(), _recommendList()],
        ),
        height: ScreenUtil().setHeight(330),
        margin: EdgeInsets.only(top: 10.0),
      ),
    );
  }

  //推荐商品标题项
  Widget _titleWidget() {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.fromLTRB(10.0, 2.0, 0, 5.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(width: 1.0, color: Colors.black12)),
      ),
      child: Text(
        '商品推荐',
        style: TextStyle(color: Colors.pink),
      ),
    );
  }

  // 商品单独项
  Widget _item(index) {
    return InkWell(
      onTap: () {},
      child: Container(
        height: ScreenUtil().setHeight(280),
        width: ScreenUtil().setWidth(250),
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            left: BorderSide(width: 1.0, color: Colors.black12),
          ),
        ),
        child: Column(
          children: <Widget>[
            Image.network(recommendList[index]['image']),
            Text('￥${recommendList[index]['mailPrice']}'),
            Text(
              '￥${recommendList[index]['price']}',
              style: TextStyle(
                  decoration: TextDecoration.lineThrough, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  // 横向列表组件
  Widget _recommendList() {
    return Container(
      height: ScreenUtil().setHeight(280),
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: recommendList.length,
          itemBuilder: (context, index) {
            return _item(index);
          }),
    );
  }
}

// 楼层标题组件编写
class FloorTitle extends StatelessWidget {
  final String pictureAddress;
  FloorTitle({Key key, this.pictureAddress}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      child: Image.network(pictureAddress),
    );
  }
}

// 楼层商品组件的编写
class FloorContent extends StatelessWidget {
  final List floorGoodsList;

  FloorContent({Key key, this.floorGoodsList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[_firstRow(), _otherGoods()],
      ),
    );
  }

  Widget _firstRow() {
    return Row(
      children: <Widget>[
        _goodsItems(floorGoodsList[0]),
        Column(
          children: <Widget>[
            _goodsItems(floorGoodsList[1]),
            _goodsItems(floorGoodsList[2]),
          ],
        )
      ],
    );
  }

  Widget _goodsItems(Map goods) {
    return Container(
      width: ScreenUtil().setWidth(375),
      child: InkWell(
        onTap: () {
          print("点击了楼层商品");
        },
        child: Image.network(goods['image']),
      ),
    );
  }

  Widget _otherGoods() {
    return Row(
      children: <Widget>[
        _goodsItems(floorGoodsList[3]),
        _goodsItems(floorGoodsList[4]),
      ],
    );
  }
}

// ! StatafulWidget 的方法，耦合性太强，不利于程序维护,所以写成Widget的形式
// class HotGoods extends StatefulWidget {
//   @override
//   _HotGoodsState createState() => _HotGoodsState();
// }

// class _HotGoodsState extends State<HotGoods> {
//   int page = 1;
//   List<Map> hotGoodsList = [];

//   void _getHotGoods(){
//     var formPage = {'page':page};
//     print(formPage);
//     request('homePageBelowConten',formData:formPage).then((val){

//       var data = json.decode(val.toString());
//       List<Map> newGoodsList = (data['data'] as List).cast();
//       setState(() {
//         hotGoodsList.addAll(newGoodsList);
//         page++;
//       });
//     });
//   }

//   void initState() {
//     super.initState();
//     // 更加通用的接口调用方式
//     _getHotGoods();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: Text('火爆专区'),
//     );
//   }

//   Widget hotTitle = Container(
//     margin: EdgeInsets.only(top:10.0),
//     padding: EdgeInsets.all(5.0),
//     alignment: Alignment.center,
//     decoration: BoxDecoration(
//       color: Colors.white,
//       border: Border(
//         bottom: BorderSide(width: 0.5,color: Colors.black12)
//       )

//     ),
//     child: Text('火爆专区'),
//   );

// }
