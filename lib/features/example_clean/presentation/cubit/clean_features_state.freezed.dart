// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'clean_features_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$CleanFeaturesState {
  List<CleanFeatureEntity> get features => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;

  /// Create a copy of CleanFeaturesState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CleanFeaturesStateCopyWith<CleanFeaturesState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CleanFeaturesStateCopyWith<$Res> {
  factory $CleanFeaturesStateCopyWith(
    CleanFeaturesState value,
    $Res Function(CleanFeaturesState) then,
  ) = _$CleanFeaturesStateCopyWithImpl<$Res, CleanFeaturesState>;
  @useResult
  $Res call({
    List<CleanFeatureEntity> features,
    bool isLoading,
    String? errorMessage,
  });
}

/// @nodoc
class _$CleanFeaturesStateCopyWithImpl<$Res, $Val extends CleanFeaturesState>
    implements $CleanFeaturesStateCopyWith<$Res> {
  _$CleanFeaturesStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CleanFeaturesState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? features = null,
    Object? isLoading = null,
    Object? errorMessage = freezed,
  }) {
    return _then(
      _value.copyWith(
            features: null == features
                ? _value.features
                : features // ignore: cast_nullable_to_non_nullable
                      as List<CleanFeatureEntity>,
            isLoading: null == isLoading
                ? _value.isLoading
                : isLoading // ignore: cast_nullable_to_non_nullable
                      as bool,
            errorMessage: freezed == errorMessage
                ? _value.errorMessage
                : errorMessage // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CleanFeaturesStateImplCopyWith<$Res>
    implements $CleanFeaturesStateCopyWith<$Res> {
  factory _$$CleanFeaturesStateImplCopyWith(
    _$CleanFeaturesStateImpl value,
    $Res Function(_$CleanFeaturesStateImpl) then,
  ) = __$$CleanFeaturesStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    List<CleanFeatureEntity> features,
    bool isLoading,
    String? errorMessage,
  });
}

/// @nodoc
class __$$CleanFeaturesStateImplCopyWithImpl<$Res>
    extends _$CleanFeaturesStateCopyWithImpl<$Res, _$CleanFeaturesStateImpl>
    implements _$$CleanFeaturesStateImplCopyWith<$Res> {
  __$$CleanFeaturesStateImplCopyWithImpl(
    _$CleanFeaturesStateImpl _value,
    $Res Function(_$CleanFeaturesStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CleanFeaturesState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? features = null,
    Object? isLoading = null,
    Object? errorMessage = freezed,
  }) {
    return _then(
      _$CleanFeaturesStateImpl(
        features: null == features
            ? _value._features
            : features // ignore: cast_nullable_to_non_nullable
                  as List<CleanFeatureEntity>,
        isLoading: null == isLoading
            ? _value.isLoading
            : isLoading // ignore: cast_nullable_to_non_nullable
                  as bool,
        errorMessage: freezed == errorMessage
            ? _value.errorMessage
            : errorMessage // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$CleanFeaturesStateImpl implements _CleanFeaturesState {
  const _$CleanFeaturesStateImpl({
    final List<CleanFeatureEntity> features = const [],
    this.isLoading = false,
    this.errorMessage,
  }) : _features = features;

  final List<CleanFeatureEntity> _features;
  @override
  @JsonKey()
  List<CleanFeatureEntity> get features {
    if (_features is EqualUnmodifiableListView) return _features;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_features);
  }

  @override
  @JsonKey()
  final bool isLoading;
  @override
  final String? errorMessage;

  @override
  String toString() {
    return 'CleanFeaturesState(features: $features, isLoading: $isLoading, errorMessage: $errorMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CleanFeaturesStateImpl &&
            const DeepCollectionEquality().equals(other._features, _features) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_features),
    isLoading,
    errorMessage,
  );

  /// Create a copy of CleanFeaturesState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CleanFeaturesStateImplCopyWith<_$CleanFeaturesStateImpl> get copyWith =>
      __$$CleanFeaturesStateImplCopyWithImpl<_$CleanFeaturesStateImpl>(
        this,
        _$identity,
      );
}

abstract class _CleanFeaturesState implements CleanFeaturesState {
  const factory _CleanFeaturesState({
    final List<CleanFeatureEntity> features,
    final bool isLoading,
    final String? errorMessage,
  }) = _$CleanFeaturesStateImpl;

  @override
  List<CleanFeatureEntity> get features;
  @override
  bool get isLoading;
  @override
  String? get errorMessage;

  /// Create a copy of CleanFeaturesState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CleanFeaturesStateImplCopyWith<_$CleanFeaturesStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
