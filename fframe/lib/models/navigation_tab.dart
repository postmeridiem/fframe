part of fframe;

class NavigationTab extends NavigationTarget {
  NavigationTab({
    required String title,
    required String path,
    required Widget contentPane,
    required Destination destination,
    List<String>? roles,
    public = false,
    private = true,
  }) :
        // assert(contentPane == null, "NavigationTab: '/${path}' contentPane must not be null"),
        super(
          title: title,
          path: path,
          contentPane: contentPane,
          destination: destination,
          roles: roles,
          public: public,
          private: private,
        );

  late NavigationTarget parentTarget;
}
