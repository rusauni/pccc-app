# Kế hoạch triển khai ứng dụng PCCC

Tài liệu này mô tả chi tiết kế hoạch triển khai ứng dụng PCCC, bao gồm các bước từ thiết lập dự án đến triển khai từng tính năng cụ thể.

## Mục lục

1. [Tổng quan](#tổng-quan)
2. [Stack công nghệ](#stack-công-nghệ)
3. [Cấu trúc dự án](#cấu-trúc-dự-án)
4. [Chi tiết triển khai](#chi-tiết-triển-khai)
5. [Các màn hình chức năng](#các-màn-hình-chức-năng)
6. [Quy trình phát triển](#quy-trình-phát-triển)
7. [Dummy data](#dummy-data)

## Tổng quan

Ứng dụng PCCC là nền tảng di động cung cấp các thông tin, hướng dẫn và công cụ về phòng cháy chữa cháy. Ứng dụng bao gồm nhiều chức năng khác nhau từ xem tin tức, tra cứu văn bản pháp luật đến tính toán hệ thống PCCC và tư vấn trực tuyến.

Ứng dụng được phát triển với mục đích:
- Cung cấp thông tin chính thống về PCCC
- Hướng dẫn người dùng về các biện pháp phòng cháy chữa cháy
- Hỗ trợ tra cứu văn bản và thủ tục hành chính
- Cung cấp công cụ tính toán và tư vấn

## Stack công nghệ

- **Framework:** Flutter
- **UI Components:** VNL UI từ vnl_common_ui
- **Navigation:** GoRouter
- **Kiến trúc:** MVVM (Model-View-ViewModel)
- **Data Access:** Repository Pattern
- **Networking:** gtd_network
- **Helper Libraries:** gtd_helper (Error Handler, Cache Helper, Shared Preferences)

## Cấu trúc dự án

```
lib/
├── app/
│   ├── main_app.dart        # Khởi tạo ứng dụng
│   └── app_router.dart      # Cấu hình GoRouter
├── models/                 # Data models
├── pages/                  # Các màn hình (theo MVVM)
│   ├── auth/               # Xác thực
│   │   ├── login/
│   │   │   ├── model/
│   │   │   ├── view/
│   │   │   └── view_model/
│   │   ├── register/
│   │   └── otp/
│   ├── home/               # Trang chủ
│   ├── news/               # Tin tức PCCC
│   ├── community_guide/    # Hướng dẫn cộng đồng
│   ├── legal_documents/    # Văn bản pháp quy
│   ├── admin_procedures/   # Thủ tục hành chính
│   ├── research/           # Nghiên cứu - Trao đổi
│   ├── skill_videos/       # Video kỹ năng
│   ├── equipment_market/   # Mua bán thiết bị
│   ├── consultation/       # Tư vấn chat
│   ├── calculation_tools/  # Công cụ tính toán
│   └── search/             # Tra cứu
├── repositories/           # Repository pattern
│   ├── auth_repository.dart
│   ├── news_repository.dart
│   └── ... (các repository khác)
├── common/                 # Widgets dùng chung
│   ├── widgets/
│   └── constants/
└── utils/                  # Tiện ích
    ├── extensions/
    └── helpers/
```

## Chi tiết triển khai

### Bước 1: Thiết lập dự án

1. Tạo dự án Flutter mới
2. Cấu hình pubspec.yaml với các dependencies cần thiết:

```yaml
dependencies:
  flutter:
    sdk: flutter
  vnl_common_ui: ^x.y.z
  go_router: ^x.y.z
  provider: ^x.y.z  # Hoặc riverpod/bloc tùy theo lựa chọn state management
  gtd_network: ^x.y.z
  gtd_helper: ^x.y.z
  # Các dependency khác
```

3. Thiết lập cấu trúc thư mục theo mô hình MVVM
4. Cấu hình GoRouter trong app_router.dart

### Bước 2: Xây dựng hệ thống xác thực

Tạo các màn hình:

#### Đăng nhập

```dart
// Model
class LoginModel {
  final String username;
  final String password;
  
  LoginModel({required this.username, required this.password});
  
  Map<String, dynamic> toJson() => {'username': username, 'password': password};
}

// ViewModel
class LoginViewModel extends ChangeNotifier {
  final _repository = AuthRepository();
  bool isLoading = false;
  String? errorMessage;
  
  Future<bool> login(String username, String password) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    
    try {
      final result = await _repository.login(username, password);
      return result;
    } catch (e) {
      errorMessage = ErrorHandler.getMessage(e);
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
  
  Future<bool> loginWithGoogle() async {
    // Triển khai đăng nhập với Google
    return false;
  }
}

// View
class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _viewModel = LoginViewModel();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    return VNLScaffold(
      headers: [
        VNLAppBar(title: Text('Đăng nhập')),
      ],
      child: ChangeNotifierProvider.value(
        value: _viewModel,
        child: Consumer<LoginViewModel>(
          builder: (context, model, child) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  VNLTextField(
                    controller: _usernameController,
                    label: 'Tên đăng nhập',
                  ),
                  SizedBox(height: 16),
                  VNLTextField(
                    controller: _passwordController,
                    obscureText: true,
                    label: 'Mật khẩu',
                  ),
                  SizedBox(height: 24),
                  if (model.errorMessage != null)
                    Text(
                      model.errorMessage!,
                      style: TextStyle(color: Colors.red),
                    ),
                  SizedBox(height: 16),
                  VNLButton(
                    style: ButtonStyle.primary(),
                    onPressed: model.isLoading
                        ? null
                        : () async {
                            final success = await model.login(
                              _usernameController.text,
                              _passwordController.text,
                            );
                            if (success) {
                              context.go('/');
                            }
                          },
                    child: model.isLoading
                        ? VNLProgressIndicator(size: ProgressIndicatorSize.small)
                        : Text('Đăng nhập'),
                  ),
                  SizedBox(height: 16),
                  VNLButton(
                    style: ButtonStyle.secondary(),
                    onPressed: model.isLoading
                        ? null
                        : () async {
                            final success = await model.loginWithGoogle();
                            if (success) {
                              context.go('/');
                            }
                          },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(RadixIcons.google),
                        SizedBox(width: 8),
                        Text('Đăng nhập với Google'),
                      ],
                    ),
                  ),
                  VNLButton(
                    style: ButtonStyle.ghost(),
                    onPressed: () => context.go('/auth/register'),
                    child: Text('Chưa có tài khoản? Đăng ký ngay'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
```

#### Đăng ký

```dart
// Model
class RegisterModel {
  final String username;
  final String password;
  final String email;
  final String phone;
  
  RegisterModel({
    required this.username,
    required this.password,
    required this.email,
    required this.phone,
  });
  
  Map<String, dynamic> toJson() => {
        'username': username,
        'password': password,
        'email': email,
        'phone': phone,
      };
}

// ViewModel
class RegisterViewModel extends ChangeNotifier {
  final _repository = AuthRepository();
  bool isLoading = false;
  String? errorMessage;
  
  Future<bool> register(RegisterModel model) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    
    try {
      final result = await _repository.register(model);
      return result;
    } catch (e) {
      errorMessage = ErrorHandler.getMessage(e);
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}

// View (tương tự như LoginPage với các field phù hợp)
```

#### Xác thực OTP

```dart
// Model
class OtpModel {
  final String phone;
  final String otp;
  
  OtpModel({required this.phone, required this.otp});
  
  Map<String, dynamic> toJson() => {'phone': phone, 'otp': otp};
}

// ViewModel
class OtpViewModel extends ChangeNotifier {
  final _repository = AuthRepository();
  bool isLoading = false;
  String? errorMessage;
  
  Future<bool> verifyOtp(String phone, String otp) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    
    try {
      final result = await _repository.verifyOtp(phone, otp);
      return result;
    } catch (e) {
      errorMessage = ErrorHandler.getMessage(e);
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
  
  Future<bool> resendOtp(String phone) async {
    // Triển khai gửi lại OTP
    return true;
  }
}

// View (màn hình nhập OTP)
```

### Bước 3: Xây dựng màn hình Home và Navigation

#### Main App

```dart
// main_app.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainApp extends StatelessWidget {
  final GoRouter router;
  
  const MainApp({Key? key, required this.router}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'PCCC App',
      theme: ThemeData(
        primarySwatch: Colors.red,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
        ),
      ),
      routerDelegate: router.routerDelegate,
      routeInformationParser: router.routeInformationParser,
      routeInformationProvider: router.routeInformationProvider,
    );
  }
}
```

#### Router Configuration

```dart
// app_router.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../pages/auth/login/view/login_page.dart';
import '../pages/auth/register/view/register_page.dart';
import '../pages/auth/otp/view/otp_page.dart';
import '../pages/home/view/home_page.dart';
import '../pages/news/view/news_page.dart';
import '../pages/news/view/news_detail_page.dart';
// Import các màn hình khác

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => HomePage(),
        routes: [
          GoRoute(
            path: 'news',
            builder: (context, state) => NewsPage(),
            routes: [
              GoRoute(
                path: ':id',
                builder: (context, state) => NewsDetailPage(
                  id: state.params['id']!,
                ),
              ),
            ],
          ),
          GoRoute(
            path: 'community-guide',
            builder: (context, state) => CommunityGuidePage(),
          ),
          GoRoute(
            path: 'legal-documents',
            builder: (context, state) => LegalDocumentsPage(),
          ),
          // Các route khác
        ],
      ),
      GoRoute(
        path: '/auth',
        builder: (context, state) => LoginPage(),
        routes: [
          GoRoute(
            path: 'register',
            builder: (context, state) => RegisterPage(),
          ),
          GoRoute(
            path: 'otp',
            builder: (context, state) => OtpPage(),
          ),
        ],
      ),
    ],
  );
}
```

#### Home Page

```dart
// home_page.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  
  static final List<Widget> _pages = [
    HomeMainContent(),
    NewsPage(),
    SearchPage(),
    ProfilePage(),
  ];
  
  @override
  Widget build(BuildContext context) {
    return VNLScaffold(
      headers: [
        VNLAppBar(
          title: Text('PCCC App'),
          trailing: [
            VNLButton(
              style: ButtonStyle.ghost(density: ButtonDensity.icon),
              onPressed: () {
                // Xử lý thông báo
              },
              child: Icon(RadixIcons.bell),
            ),
          ],
        ),
      ],
      child: _pages[_selectedIndex],
      footers: [
        VNLNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: [
          NavigationItem(
            child: Icon(RadixIcons.home),
            label: Text('Trang chủ'),
          ),
          NavigationItem(
            child: Icon(RadixIcons.newspaper),
            label: Text('Tin tức'),
          ),
          NavigationItem(
            child: Icon(RadixIcons.magnifyingGlass),
            label: Text('Tra cứu'),
          ),
          NavigationItem(
            child: Icon(RadixIcons.person),
            label: Text('Cá nhân'),
          ),
        ],
      ),
    );
  }
}

class HomeMainContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Banner quảng cáo
          CarouselSlider(
            items: [
              // Các banner
            ],
            options: CarouselOptions(
              height: 180,
              autoPlay: true,
            ),
          ),
          
          // Danh mục chính
          GridView.count(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            crossAxisCount: 3,
            children: [
              CategoryItem(
                icon: Icons.article,
                title: 'Tin tức PCCC',
                onTap: () => context.go('/news'),
              ),
              CategoryItem(
                icon: Icons.people,
                title: 'Hướng dẫn cộng đồng',
                onTap: () => context.go('/community-guide'),
              ),
              CategoryItem(
                icon: Icons.gavel,
                title: 'Văn bản pháp quy',
                onTap: () => context.go('/legal-documents'),
              ),
              CategoryItem(
                icon: Icons.assignment,
                title: 'Thủ tục hành chính',
                onTap: () => context.go('/admin-procedures'),
              ),
              CategoryItem(
                icon: Icons.book,
                title: 'Nghiên cứu - Trao đổi',
                onTap: () => context.go('/research'),
              ),
              CategoryItem(
                icon: Icons.video_library,
                title: 'Video kỹ năng',
                onTap: () => context.go('/skill-videos'),
              ),
              CategoryItem(
                icon: Icons.shopping_cart,
                title: 'Mua bán thiết bị',
                onTap: () => context.go('/equipment-market'),
              ),
              CategoryItem(
                icon: Icons.chat,
                title: 'Tư vấn',
                onTap: () => context.go('/consultation'),
              ),
              CategoryItem(
                icon: Icons.calculate,
                title: 'Công cụ tính toán',
                onTap: () => context.go('/calculation-tools'),
              ),
            ],
          ),
          
          // Tin tức nổi bật
          SectionTitle(title: 'Tin tức nổi bật'),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: 3,
            itemBuilder: (context, index) {
              return NewsItem(
                // Dummy data
                title: 'Tin tức ${index + 1}',
                date: '31/05/2025',
                imageUrl: 'assets/images/news_${index + 1}.jpg',
                onTap: () => context.go('/news/$index'),
              );
            },
          ),
        ],
      ),
    );
  }
}

// Widget CategoryItem, SectionTitle, NewsItem
```

### Bước 4: Xây dựng Repository Pattern

#### AuthRepository

```dart
class AuthRepository {
  Future<bool> login(String username, String password) async {
    // Giả lập API call
    await Future.delayed(Duration(seconds: 1));
    
    // Dummy check
    if (username == 'admin' && password == 'password') {
      // Lưu token vào SharedPreferences
      await CacheHelper.saveData(key: 'token', value: 'dummy_token');
      return true;
    }
    
    throw Exception('Sai tên đăng nhập hoặc mật khẩu');
  }
  
  Future<bool> register(RegisterModel model) async {
    // Giả lập API call
    await Future.delayed(Duration(seconds: 1));
    
    // Dummy check
    return true;
  }
  
  Future<bool> verifyOtp(String phone, String otp) async {
    // Giả lập API call
    await Future.delayed(Duration(seconds: 1));
    
    // Dummy check
    if (otp == '123456') {
      return true;
    }
    
    throw Exception('Mã OTP không đúng');
  }
}
```

#### NewsRepository

```dart
class NewsRepository {
  Future<List<NewsModel>> getNews() async {
    // Giả lập API call
    await Future.delayed(Duration(seconds: 1));
    
    // Dummy data
    final dummyData = [
      {
        'id': '1',
        'title': 'Hướng dẫn phòng cháy cho chung cư',
        'content': 'Nội dung bài viết...',
        'imageUrl': 'assets/images/news1.jpg',
        'date': '2025-05-30'
      },
      {
        'id': '2',
        'title': 'Diễn tập PCCC tại các trường học',
        'content': 'Nội dung bài viết...',
        'imageUrl': 'assets/images/news2.jpg',
        'date': '2025-05-29'
      },
      // Thêm các mục khác
    ];
    
    return dummyData.map((e) => NewsModel.fromJson(e)).toList();
  }
  
  Future<NewsModel> getNewsDetail(String id) async {
    // Giả lập API call
    await Future.delayed(Duration(seconds: 1));
    
    // Dummy data
    final dummyData = {
      'id': id,
      'title': 'Hướng dẫn phòng cháy cho chung cư',
      'content': 'Nội dung chi tiết bài viết...',
      'imageUrl': 'assets/images/news1.jpg',
      'date': '2025-05-30'
    };
    
    return NewsModel.fromJson(dummyData);
  }
}
```

## Các màn hình chức năng

### 1. Tin tức PCCC

#### Model

```dart
class NewsModel {
  final String id;
  final String title;
  final String content;
  final String imageUrl;
  final String date;
  
  NewsModel({
    required this.id,
    required this.title,
    required this.content,
    required this.imageUrl,
    required this.date,
  });
  
  factory NewsModel.fromJson(Map<String, dynamic> json) {
    return NewsModel(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      imageUrl: json['imageUrl'],
      date: json['date'],
    );
  }
}
```

#### ViewModel

```dart
class NewsViewModel extends ChangeNotifier {
  final _repository = NewsRepository();
  List<NewsModel> news = [];
  bool isLoading = false;
  String? errorMessage;
  
  Future<void> fetchNews() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    
    try {
      news = await _repository.getNews();
    } catch (e) {
      errorMessage = ErrorHandler.getMessage(e);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
```

#### View

```dart
class NewsPage extends StatefulWidget {
  @override
  _NewsPageState createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  final _viewModel = NewsViewModel();
  
  @override
  void initState() {
    super.initState();
    _viewModel.fetchNews();
  }
  
  @override
  Widget build(BuildContext context) {
    return VNLScaffold(
      headers: [
        VNLAppBar(title: Text('Tin tức PCCC')),
      ],
      child: ChangeNotifierProvider.value(
        value: _viewModel,
        child: Consumer<NewsViewModel>(
          builder: (context, model, child) {
            if (model.isLoading) {
              return Center(child: VNLProgressIndicator());
            }
            
            if (model.errorMessage != null) {
              return Center(child: Text(model.errorMessage!));
            }
            
            if (model.news.isEmpty) {
              return Center(child: Text('Không có tin tức nào'));
            }
            
            return ListView.builder(
              itemCount: model.news.length,
              itemBuilder: (context, index) {
                final item = model.news[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: InkWell(
                    onTap: () => context.go('/news/${item.id}'),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset(
                          item.imageUrl,
                          height: 180,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.title,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                item.date,
                                style: TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
```

### 2. Hướng dẫn cộng đồng

Tương tự như tính năng Tin tức, tạo model, repository, view model và view phù hợp.

### 3. Văn bản pháp quy

#### Model

```dart
class LegalDocumentModel {
  final String id;
  final String title;
  final String documentNumber;
  final String issueDate;
  final String issueBy;
  final String content;
  final String? fileUrl;
  final String category;
  
  LegalDocumentModel({
    required this.id,
    required this.title,
    required this.documentNumber,
    required this.issueDate,
    required this.issueBy,
    required this.content,
    this.fileUrl,
    required this.category,
  });
  
  factory LegalDocumentModel.fromJson(Map<String, dynamic> json) {
    return LegalDocumentModel(
      id: json['id'],
      title: json['title'],
      documentNumber: json['documentNumber'],
      issueDate: json['issueDate'],
      issueBy: json['issueBy'],
      content: json['content'],
      fileUrl: json['fileUrl'],
      category: json['category'],
    );
  }
}
```

#### Repository

```dart
class LegalDocumentRepository {
  Future<List<LegalDocumentModel>> getLegalDocuments() async {
    // Giả lập API call
    await Future.delayed(Duration(seconds: 1));
    
    // Dummy data
    final dummyData = [
      {
        'id': '1',
        'title': 'Luật Phòng cháy và chữa cháy',
        'documentNumber': '40/2013/QH13',
        'issueDate': '2013-11-22',
        'issueBy': 'Quốc hội',
        'content': 'Nội dung...',
        'fileUrl': 'assets/files/law.pdf',
        'category': 'Luật',
      },
      {
        'id': '2',
        'title': 'Nghị định quy định xử phạt vi phạm hành chính về PCCC',
        'documentNumber': '144/2021/NĐ-CP',
        'issueDate': '2021-12-31',
        'issueBy': 'Chính phủ',
        'content': 'Nội dung...',
        'fileUrl': 'assets/files/decree.pdf',
        'category': 'Nghị định',
      },
      // Thêm các mục khác
    ];
    
    return dummyData.map((e) => LegalDocumentModel.fromJson(e)).toList();
  }
  
  Future<List<LegalDocumentModel>> filterLegalDocuments({
    String? keyword,
    String? category,
    String? fromDate,
    String? toDate,
  }) async {
    // Giả lập API call với bộ lọc
    await Future.delayed(Duration(seconds: 1));
    
    final allDocuments = await getLegalDocuments();
    
    // Thực hiện lọc
    return allDocuments.where((doc) {
      bool match = true;
      
      if (keyword != null && keyword.isNotEmpty) {
        match = match && (doc.title.toLowerCase().contains(keyword.toLowerCase()) ||
                         doc.content.toLowerCase().contains(keyword.toLowerCase()));
      }
      
      if (category != null && category.isNotEmpty) {
        match = match && doc.category == category;
      }
      
      // Xử lý lọc theo ngày
      
      return match;
    }).toList();
  }
}
```

#### ViewModel

```dart
class LegalDocumentViewModel extends ChangeNotifier {
  final _repository = LegalDocumentRepository();
  List<LegalDocumentModel> documents = [];
  bool isLoading = false;
  String? errorMessage;
  
  // Filters
  String? keyword;
  String? selectedCategory;
  String? fromDate;
  String? toDate;
  
  Future<void> fetchDocuments() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    
    try {
      documents = await _repository.filterLegalDocuments(
        keyword: keyword,
        category: selectedCategory,
        fromDate: fromDate,
        toDate: toDate,
      );
    } catch (e) {
      errorMessage = ErrorHandler.getMessage(e);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
  
  void setKeyword(String value) {
    keyword = value;
    notifyListeners();
  }
  
  void setCategory(String value) {
    selectedCategory = value;
    notifyListeners();
  }
  
  void clearFilters() {
    keyword = null;
    selectedCategory = null;
    fromDate = null;
    toDate = null;
    notifyListeners();
  }
}
```

### 4. Tư vấn chat

```dart
class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;
  
  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
  });
}

class ChatViewModel extends ChangeNotifier {
  List<ChatMessage> messages = [];
  bool isLoading = false;
  
  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;
    
    // Thêm tin nhắn của người dùng
    final userMessage = ChatMessage(
      text: text,
      isUser: true,
      timestamp: DateTime.now(),
    );
    
    messages.add(userMessage);
    notifyListeners();
    
    // Giả lập đang xử lý tin nhắn
    isLoading = true;
    notifyListeners();
    
    await Future.delayed(Duration(seconds: 1));
    
    // Giả lập trả lời từ AI hoặc admin
    final botResponse = ChatMessage(
      text: 'Cảm ơn bạn đã liên hệ. Đây là phản hồi tự động.',
      isUser: false,
      timestamp: DateTime.now(),
    );
    
    messages.add(botResponse);
    isLoading = false;
    notifyListeners();
  }
}
```

### 5. Công cụ tính toán

```dart
class CalculationTool {
  final String id;
  final String name;
  final String description;
  final String category;
  final bool isBuiltIn;
  final String? externalUrl;
  
  CalculationTool({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.isBuiltIn,
    this.externalUrl,
  });
  
  factory CalculationTool.fromJson(Map<String, dynamic> json) {
    return CalculationTool(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      category: json['category'],
      isBuiltIn: json['isBuiltIn'],
      externalUrl: json['externalUrl'],
    );
  }
}

class CalculationToolsRepository {
  Future<List<CalculationTool>> getTools() async {
    // Giả lập API call
    await Future.delayed(Duration(seconds: 1));
    
    // Dummy data
    final dummyData = [
      {
        'id': '1',
        'name': 'Tính toán bơm chữa cháy',
        'description': 'Công cụ tính toán lưu lượng và áp suất bơm chữa cháy',
        'category': 'Hệ thống chữa cháy',
        'isBuiltIn': true,
        'externalUrl': null,
      },
      {
        'id': '2',
        'name': 'Tính toán hệ thống chữa cháy tự động',
        'description': 'Tính toán hệ thống sprinkler',
        'category': 'Hệ thống chữa cháy',
        'isBuiltIn': true,
        'externalUrl': null,
      },
      {
        'id': '3',
        'name': 'Phần mềm mô phỏng đám cháy',
        'description': 'Công cụ bên thứ 3 mô phỏng đám cháy',
        'category': 'Mô phỏng',
        'isBuiltIn': false,
        'externalUrl': 'https://example.com/fire-simulation',
      },
      // Thêm các mục khác
    ];
    
    return dummyData.map((e) => CalculationTool.fromJson(e)).toList();
  }
}
```

## Dummy data

Các dữ liệu giả cho ứng dụng sẽ được tạo và lưu trữ trong các file JSON trong thư mục `assets/data/`. Để quản lý, ta sẽ cần tạo các file:

- `assets/data/auth_data.json`: Dữ liệu người dùng
- `assets/data/news.json`: Tin tức PCCC
- `assets/data/community_guides.json`: Hướng dẫn cộng đồng
- `assets/data/legal_documents.json`: Văn bản pháp quy
- `assets/data/admin_procedures.json`: Thủ tục hành chính
- `assets/data/research_articles.json`: Bài viết nghiên cứu
- `assets/data/skill_videos.json`: Video kỹ năng
- `assets/data/equipments.json`: Thiết bị PCCC
- `assets/data/calculation_tools.json`: Công cụ tính toán

Ví dụ về cấu trúc file news.json:

```json
[
  {
    "id": "1",
    "title": "Hướng dẫn phòng cháy cho chung cư",
    "content": "Nội dung bài viết...",
    "imageUrl": "assets/images/news1.jpg",
    "date": "2025-05-30"
  },
  {
    "id": "2",
    "title": "Diễn tập PCCC tại các trường học",
    "content": "Nội dung bài viết...",
    "imageUrl": "assets/images/news2.jpg",
    "date": "2025-05-29"
  },
  {
    "id": "3",
    "title": "Mua sắm thiết bị PCCC: Những điều cần biết",
    "content": "Nội dung bài viết...",
    "imageUrl": "assets/images/news3.jpg",
    "date": "2025-05-28"
  }
]
```

## Quy trình phát triển

1. **Cài đặt và cấu hình ban đầu**
   - Tạo dự án Flutter
   - Cấu hình pubspec.yaml
   - Thiết lập cấu trúc thư mục
   - Cấu hình theme và router

2. **Xây dựng hệ thống xác thực**
   - Đăng nhập / Đăng ký / OTP / Google
   - Quản lý phiên đăng nhập

3. **Xây dựng màn hình chính**
   - Trang chủ với danh mục
   - Bottom navigation
   - Banner quảng cáo

4. **Phát triển các tính năng chức năng**
   - Từng tính năng theo thứ tự ưu tiên
   - Tin tức PCCC
   - Hướng dẫn cộng đồng
   - Văn bản pháp quy
   - Các tính năng khác

5. **Test và debug**
   - Kiểm tra giao diện trên các kích thước màn hình
   - Kiểm tra luồng hoạt động
   - Xử lý các trường hợp lỗi

6. **Hoàn thiện và chuẩn bị release**
   - Tối ưu hóa hiệu suất
   - Cấu hình các thông tin app

## Kết luận

Việc xây dựng ứng dụng PCCC với Flutter cần tuân thủ kiến trúc MVVM và Repository Pattern đã được định nghĩa. Ứng dụng được thiết kế để cung cấp nhiều tính năng hỗ trợ người dùng trong việc tìm hiểu và thực hiện các biện pháp phòng cháy chữa cháy.

Trong giai đoạn đầu, chúng ta sẽ sử dụng dữ liệu giả lập để xây dựng và thử nghiệm prototype. Sau đó, có thể tiếp tục phát triển backend và kết nối API thật để có được ứng dụng hoàn chỉnh.

Hiện tại, tài liệu này đã cung cấp các chi tiết triển khai cần thiết để xây dựng prototype của ứng dụng PCCC với đầy đủ các tính năng yêu cầu.
```
