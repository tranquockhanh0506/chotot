import 'package:flutter/material.dart';

class HeroRouter extends PageRoute{
  final WidgetBuilder _buider;

  HeroRouter({@required WidgetBuilder buider}) : _buider = buider;

  @override
  // TODO: implement barrierColor
  Color get barrierColor => Colors.black54;

  @override
  // TODO: implement barrierLabel
  String get barrierLabel => 'Popup open';
  @override
  // TODO: implement opaque
  bool get opaque => false;
  @override
  // TODO: implement barrierDismissible
  bool get barrierDismissible => true;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
    return _buider(context);
  }

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
    // TODO: implement buildTransitions
    return child;
  }
  @override
  // TODO: implement maintainState
  bool get maintainState => true;

  @override
  // TODO: implement transitionDuration
  Duration get transitionDuration => Duration(milliseconds: 500);

}