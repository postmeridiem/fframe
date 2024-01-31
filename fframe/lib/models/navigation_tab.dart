part of '../../fframe.dart';

class NavigationTab extends NavigationTarget {
  // ignore: use_super_parameters
  NavigationTab({
    required super.title,
    required super.path,
    required Widget super.contentPane,
    required Destination super.destination,
    super.navigationTabs,
    super.roles,
    public = false,
    private = true,
  }) :
        // assert(contentPane == null, "NavigationTab: '/${path}' contentPane must not be null"),
        super(
          public: public,
          private: private,
        );

  late NavigationTarget parentTarget;
}
