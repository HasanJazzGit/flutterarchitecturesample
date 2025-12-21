/// Use case parameters - Example for Clean Architecture
/// Simple example with 2 params: title and content
/// This params object is passed through all layers (UseCase → Repository → DataSource)
class CreateFeatureParams {
  final String title;
  final String content;

  CreateFeatureParams({required this.title, required this.content});
}
