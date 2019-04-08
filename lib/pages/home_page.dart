import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

// 增加请求头文件
import '../config/httpHeaders.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

// class _HomePageState extends State<HomePage> {
//   TextEditingController typeController = TextEditingController();
//   String showText = '欢迎来到美好人间';

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: Scaffold(
//         appBar: AppBar(
//           title: Text('美好人间'),
//         ),
//         // 一个可滚动的widget.没有组件实体。
//         body: SingleChildScrollView(
//           child: Container(
//             // height: 100.0,
//             child: Column(
//               children: <Widget>[
//                 // TextField Widget的基本使用
//                 TextField(
//                   controller: typeController,
//                   decoration: InputDecoration(
//                     contentPadding: EdgeInsets.all(10.0),
//                     labelText: '美女类型',
//                     helperText: '请输入你喜欢的类型',
//                   ),
//                   autofocus: false,
//                 ),
//                 RaisedButton(
//                   onPressed: _choiceAction,
//                   child: Text('选择完毕'),
//                 ),
//                 Text(
//                   showText,
//                   overflow: TextOverflow.ellipsis,
//                   maxLines: 2,
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   void _choiceAction() {
//     print('开始选择你喜欢的类型。。。');
//     if (typeController.text.toString() == '') {
//       showDialog(
//         context: context,
//         builder: (context) => AlertDialog(
//               title: Text('美女类型不能为空'),
//             ),
//       );
//     } else {
//       getHttp(typeController.text.toString()).then((res) {
//         // 改变状态和界面的setState的方法应用
//         setState(() {
//           showText = res['data']['name'].toString();
//         });
//       });
//     }
//   }
//   // 返回一个Future，支持一个等待回调方法 then
//   Future getHttp(String typeText) async {
//     try {
//       Response response;
//       var data = {'name': typeText};
//       response = await Dio().get(
//         "https://www.easy-mock.com/mock/5c60131a4bed3a6342711498/baixing/dabaojian",
//         queryParameters: data,
//       );
//       print(response.data);
//       return response.data;
//     } catch (e) {
//       return print(e);
//     }
//   }

//   // // 返回一个Future，支持一个等待回调方法 then
//   // Future getHttp(String typeText) async {
//   //   try {
//   //     Response response;
//   //     var data = {'name': typeText};
//   //     response = await Dio().post(
//   //       "https://www.easy-mock.com/mock/5caae160c41e561afc30ba47/example/dabaojian",
//   //       queryParameters: data,
//   //     );
//   //     print(response.data);
//   //     return response.data;
//   //   } catch (e) {
//   //     return print(e);
//   //   }
//   // }
// }

// 设置请求头
class _HomePageState extends State<HomePage> {
  String showText = "还没有请求数据";
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Text('请求远程数据'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              RaisedButton(
                child: Text('请求数据'),
                onPressed: _jike,
              ),
              Text(showText),
            ],
          ),
        ),
      ),
    );
  }

  void _jike() {
    print("开始向极客时间请求数据...");
    getHttp().then((val) {
      setState(() {
        showText = val['data'].toString();
      });
    });
  }

  Future getHttp() async {
    try {
      Response response;
      Dio dio = new Dio();
      dio.options.headers= httpHeaders;
      response =
          await dio.get("https://time.geekbang.org/serv/v1/column/newAll");
      print(response);
      return response.data;
    } catch (e) {
      return print(e);
    }
  }
}
