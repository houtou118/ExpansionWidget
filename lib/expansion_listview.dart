import 'package:flutter/material.dart';

class _ShjKey<S, V> extends LocalKey {
  const _ShjKey(this.shj, this.value);
  
  final S shj;
  final V value;
  
  @override
  bool operator ==(dynamic other) {
    if (other.runtimeType != runtimeType) return false;
    final _ShjKey<S, V> typedOther = other;
    return shj == typedOther.shj && value == typedOther.value;
  }
  
  @override
  int get hashCode => hashValues(runtimeType, shj, value);
  
  @override
  String toString() {
    final String saltString = S == String ? '<\'$shj\'>' : '<$shj>';
    final String valueString = V == String ? '<\'$value\'>' : '<$value>';
    return '[$saltString $valueString]';
  }
}

typedef ExpansionCellCallBack = void Function(int cellIndex);

typedef ExpansionCellHeader = Widget Function(BuildContext context, bool isExpanded);

class ExpansionCell {
  final ExpansionCellHeader cellHeader;
  final Widget body;
  final bool isExpanded;
  
  ExpansionCell({
    @required this.cellHeader,
    @required this.body,
    this.isExpanded = false,
  })  : assert(cellHeader != null),
            assert(body != null),
            assert(isExpanded != null);
}

class ExpansionListView extends StatefulWidget {
  final List<ExpansionCell> children;
  final ExpansionCellCallBack expansionCellCallBack;
  final Duration animationDuration;
  
  const ExpansionListView({
    Key key,
    this.children = const <ExpansionCell>[],
    this.expansionCellCallBack,
    this.animationDuration = kThemeAnimationDuration,
  })  : assert(children != null),
            assert(animationDuration != null),
            super(key: key);
  
  @override
  _ExpansionListViewState createState() => _ExpansionListViewState();
}

class _ExpansionListViewState extends State<ExpansionListView> {
  @override
  void initState() {
    super.initState();
  }
  
  bool _isChildExpanded(int index) {
    return widget.children[index].isExpanded;
  }
  
  void _handlePressed(int index) {
    if (widget.expansionCellCallBack != null) widget.expansionCellCallBack(index);
    setState(() {});
  }
  
  @override
  Widget build(BuildContext context) {
    final List<MergeableMaterialItem> items = <MergeableMaterialItem>[];
    for (int index = 0; index < widget.children.length; index += 1) {
      final ExpansionCell child = widget.children[index];
      
      final Stack shjHeader = Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: Colors.yellow,
            ),
            child: AnimatedContainer(
              duration: widget.animationDuration,
              curve: Curves.fastOutSlowIn,
              margin: EdgeInsets.zero,
              child: Container(
                child: child.cellHeader(
                  context,
                  _isChildExpanded(index),
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              print('sssssss');
              return _handlePressed(index);
            },
            child: SizedBox(
              width: double.maxFinite,
              height: 50,
            ),
          ),
        ],
      );
      
      items.add(
        MaterialSlice(
          key: _ShjKey<BuildContext, int>(context, index * 2),
          child: Column(
            children: <Widget>[
              MergeSemantics(child: shjHeader),
              AnimatedCrossFade(
                firstChild: Container(height: 0.0),
                secondChild: child.body,
                firstCurve: const Interval(0.0, 0.6, curve: Curves.fastOutSlowIn),
                secondCurve: const Interval(0.4, 1.0, curve: Curves.fastOutSlowIn),
                sizeCurve: Curves.fastOutSlowIn,
                crossFadeState:
                _isChildExpanded(index) ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                duration: widget.animationDuration,
              )
            ],
          ),
        ),
      );
    }
    
    return MergeableMaterial(
      hasDividers: false,
      children: items,
    );
  }
}

