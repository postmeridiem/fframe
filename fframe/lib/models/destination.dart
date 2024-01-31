part of '../../fframe.dart';

class Destination {
  /// Creates a destination that is used with [NavigationRail.destinations].
  ///
  /// [icon] and [label] must be non-null. When the [NavigationRail.labelType]
  /// is [NavigationRailLabelType.none], the label is still used for semantics,
  /// and may still be used if [NavigationRail.extended] is true.
  const Destination({
    required this.icon,
    Widget? selectedIcon,
    required this.navigationLabel,
    this.tabLabel,
    this.padding,
  }) : selectedIcon = selectedIcon ?? icon;

  final Widget icon;
  final Widget selectedIcon;
  final NavigationLabel navigationLabel;
  final NavigationTabLabel? tabLabel;
  final EdgeInsetsGeometry? padding;
}

typedef NavigationLabel<T> = Widget Function();
typedef NavigationTabLabel<T> = String Function();
