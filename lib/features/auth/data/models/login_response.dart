class LoginResponse {
  final String token;
  final String userId;
  final String email;
  final String? refreshToken;
  final int? expiresIn;

  LoginResponse({
    required this.token,
    required this.userId,
    required this.email,
    this.refreshToken,
    this.expiresIn,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      token: json['token'] as String,
      userId: json['userId'] as String? ?? json['user_id'] as String? ?? '',
      email: json['email'] as String,
      refreshToken: json['refreshToken'] as String? ?? json['refresh_token'] as String?,
      expiresIn: json['expiresIn'] as int? ?? json['expires_in'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'userId': userId,
      'email': email,
      'refreshToken': refreshToken,
      'expiresIn': expiresIn,
    };
  }
}

