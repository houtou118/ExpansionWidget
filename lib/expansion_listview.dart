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

typedef ExpansionCellCallBack = void Function(int cellIndex, bool isExpanded);

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

  void _handlePressed(bool isExpanded, int index) {
    if (widget.expansionCellCallBack != null) widget.expansionCellCallBack(index, isExpanded);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final List<MergeableMaterialItem> items = <MergeableMaterialItem>[];
    for (int index = 0; index < widget.children.length; index += 1) {
//      if (_isChildExpanded(index) && index != 0 && !_isChildExpanded(index - 1))
//        items.add(MaterialGap(key: _ShjKey<BuildContext, int>(context, index * 2 - 1)));

      final ExpansionCell child = widget.children[index];
      final Row header = Row(
        children: <Widget>[
          Expanded(
            child: AnimatedContainer(
              duration: widget.animationDuration,
              curve: Curves.fastOutSlowIn,
              margin: EdgeInsets.zero,
              child: ConstrainedBox(
                constraints: const BoxConstraints(minHeight: 100.0),
                child: child.cellHeader(
                  context,
                  _isChildExpanded(index),
                ),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsetsDirectional.only(end: 8.0),
            child: ExpandIcon(
              isExpanded: _isChildExpanded(index),
              padding: const EdgeInsets.all(16.0),
              onPressed: (bool isExpanded) {
                return _handlePressed(isExpanded, index);
              },
            ),
          ),
        ],
      );

      items.add(
        MaterialSlice(
          key: _ShjKey<BuildContext, int>(context, index * 2),
          child: Column(
            children: <Widget>[
              MergeSemantics(child: header),
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

//			if (_isChildExpanded(index) && index != widget.children.length - 1)
//				items.add(MaterialGap(key: _ShjKey<BuildContext, int>(context, index * 2 + 1)));
    }

    return MergeableMaterial(
			hasDividers: true,
			children: items,
		);
  }
}
