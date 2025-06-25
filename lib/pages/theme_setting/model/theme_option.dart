class ThemeOption {
  final String name;
  final String displayName;
  final String description;
  final bool isLight;

  const ThemeOption({
    required this.name,
    required this.displayName,
    required this.description,
    required this.isLight,
  });

  static const lightRed = ThemeOption(
    name: 'lightRed',
    displayName: 'Giao diện sáng',
    description: 'Theme đỏ sáng, phù hợp sử dụng ban ngày',
    isLight: true,
  );

  static const darkRed = ThemeOption(
    name: 'darkRed',
    displayName: 'Giao diện tối',
    description: 'Theme đỏ tối, phù hợp sử dụng ban đêm',
    isLight: false,
  );

  static const List<ThemeOption> allOptions = [lightRed, darkRed];
} 