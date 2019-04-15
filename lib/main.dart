import 'package:flutter/material.dart';
import 'expansion_listview.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ExpansionWidgetDemo(),
    );
  }
}

class ExpandStateBean {
  var isOpen;
  var index;
  ExpandStateBean(this.index, this.isOpen);
}

class ExpansionWidgetDemo extends StatefulWidget {
  @override
  _ExpansionWidgetDemoState createState() => _ExpansionWidgetDemoState();
}

class _ExpansionWidgetDemoState extends State<ExpansionWidgetDemo> {
  var currentIndex = -1;
  List<int> mList;
  List<ExpandStateBean> expandStateList;

  _ExpansionWidgetDemoState() {
    mList = new List();
    expandStateList = new List();
    for (int index = 0; index < 3; index++) {
      mList.add(index);
      expandStateList.add(ExpandStateBean(index, false));
    }
  }
  //修改展开与闭合的内部方法
  _setCurrentIndex(int index, isExpand) {
    setState(() {
      //遍历可展开状态列表
      expandStateList.forEach((item) {
        if (item.index == index) {
          //取反，经典取反方法
          item.isOpen = !isExpand;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Demo")),
      body: SingleChildScrollView(
        child: ExpansionListView(
          expansionCellCallBack: (index, bool) {
            _setCurrentIndex(index, bool);
          },
          children: mList.map((index) {
            return ExpansionCell(
                cellHeader: (context, isExpanded) {
                  return ListTile(title: Text('This is No. $index'));
                },
                body: ListTile(title: Text('expansion no.$index')),
                isExpanded: expandStateList[index].isOpen);
          }).toList(),
        ),
      ),
    );
  }
}
