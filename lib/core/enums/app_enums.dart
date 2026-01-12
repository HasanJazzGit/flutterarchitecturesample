//example
enum CustomAppEnum {
  test1(1, "Feed"),
  test2(2, "Following"),
  test3(3, "Community");

  final int value;
  final String title;
  const CustomAppEnum(this.value, this.title);
}