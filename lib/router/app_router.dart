class AppRouterPath {
  static const String splash = "splashscreen";
  static const String theme = "theme";
  static const String home = "home";
  static const String login = "login";
  static const String register = "register";
  static const String forgotPassword = "forgot-password";
  static const String otp = "otp";
  static const String profile = "profile";
  static const String settings = "settings";
  static const String accountDetail = "account-detail";
  static const String pdfViewer = "pdf-viewer";
  static const String about = "about";
  static const String contactUs = "contact-us";
  static const String news = "news";
  static const String newsDetail = "news-detail";
  static const String communityGuide = "community-guide";
  static const String legalDocuments = "legal-documents";
  static const String adminProcedures = "admin-procedures";
  static const String research = "research";
  static const String skillVideos = "skill-videos";
  static const String equipmentMarket = "equipment-market";
  static const String consultation = "consultation";
  static const String calculationTools = "calculation-tools";
  static const String pcccCheck = "pccc-check";
}

class AppRouter {
  String name;
  String path;
  AppRouter({required this.name, required this.path});

  factory AppRouter.withName(String name) {
    return AppRouter(name: name, path: name);
  }
}
