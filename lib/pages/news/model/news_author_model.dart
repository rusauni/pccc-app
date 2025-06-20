class NewsAuthorModel {
  final String id;
  final String name;
  final String? avatarUrl;
  final String? title;
  final String? email;

  NewsAuthorModel({
    required this.id,
    required this.name,
    this.avatarUrl,
    this.title,
    this.email,
  });

  factory NewsAuthorModel.fromJson(Map<String, dynamic> json) {
    return NewsAuthorModel(
      id: json['id'].toString(),
      name: json['name'] ?? '',
      avatarUrl: json['avatar_url'],
      title: json['title'],
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'avatar_url': avatarUrl,
      'title': title,
      'email': email,
    };
  }

  static List<NewsAuthorModel> getDummyAuthors() {
    return [
      NewsAuthorModel(
        id: '1',
        name: 'Nguyễn Văn A',
        avatarUrl: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=100&h=100&fit=crop&crop=face',
        title: 'Phóng viên PCCC',
      ),
      NewsAuthorModel(
        id: '2',
        name: 'Trần Thị B',
        avatarUrl: 'https://images.unsplash.com/photo-1494790108755-2616b612b786?w=100&h=100&fit=crop&crop=face',
        title: 'Chuyên gia PCCC',
      ),
      NewsAuthorModel(
        id: '3',
        name: 'Lê Minh C',
        avatarUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100&h=100&fit=crop&crop=face',
        title: 'Biên tập viên',
      ),
    ];
  }
} 