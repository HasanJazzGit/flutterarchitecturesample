import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/clean_feature_model.dart';
import 'clean_feature_local_data_source.dart';

/// Local data source implementation - Example for Clean Architecture
/// Implements local storage using SharedPreferences
/// This is a sample implementation for understanding Clean Architecture structure
class CleanFeatureLocalDataSourceImpl implements CleanFeatureLocalDataSource {
  final SharedPreferences sharedPreferences;
  static const String _key = 'clean_features';

  CleanFeatureLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<List<CleanFeatureModel>> getFeatures() async {
    try {
      final jsonString = sharedPreferences.getString(_key);
      if (jsonString == null) return [];

      final decoded = jsonDecode(jsonString) as List;
      return decoded
          .map(
            (json) => CleanFeatureModel.fromJson(json as Map<String, dynamic>),
          )
          .toList();
    } catch (e) {
      throw Exception('Failed to get features from local storage: $e');
    }
  }

  @override
  Future<CleanFeatureModel?> getFeatureById(String id) async {
    try {
      final features = await getFeatures();
      return features.firstWhere(
        (feature) => feature.id == id,
        orElse: () => throw Exception('Feature not found'),
      );
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> saveFeature(CleanFeatureModel feature) async {
    try {
      final features = await getFeatures();
      final index = features.indexWhere((f) => f.id == feature.id);

      if (index >= 0) {
        features[index] = feature;
      } else {
        features.add(feature);
      }

      await saveFeatures(features);
    } catch (e) {
      throw Exception('Failed to save feature to local storage: $e');
    }
  }

  @override
  Future<void> saveFeatures(List<CleanFeatureModel> features) async {
    try {
      final jsonString = jsonEncode(
        features.map((feature) => feature.toJson()).toList(),
      );
      await sharedPreferences.setString(_key, jsonString);
    } catch (e) {
      throw Exception('Failed to save features to local storage: $e');
    }
  }
}
