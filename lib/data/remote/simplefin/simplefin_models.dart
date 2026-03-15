/// Parsed SimpleFIN access URL containing credentials and endpoint.
class SimplefinAccessUrl {
  final String scheme;
  final String username;
  final String password;
  final String host;
  final String path;

  const SimplefinAccessUrl({
    required this.scheme,
    required this.username,
    required this.password,
    required this.host,
    required this.path,
  });

  /// Base URL for API calls (without credentials).
  String get baseUrl => '$scheme://$host$path';

  /// Full URL including credentials (for storage).
  @override
  String toString() => '$scheme://$username:$password@$host$path';

  /// Parse from a full access URL string.
  factory SimplefinAccessUrl.parse(String url) {
    final uri = Uri.parse(url);
    return SimplefinAccessUrl(
      scheme: uri.scheme,
      username: uri.userInfo.split(':').first,
      password: uri.userInfo.contains(':')
          ? uri.userInfo.substring(uri.userInfo.indexOf(':') + 1)
          : '',
      host: uri.host + (uri.hasPort ? ':${uri.port}' : ''),
      path: uri.path,
    );
  }
}

/// A single account returned by SimpleFIN.
class SimplefinAccount {
  final String id;
  final String name;
  final String? orgName;
  final String? orgDomain;
  final String currency;
  final int balanceCents;
  final int? availableBalanceCents;
  final int balanceDateUnix;
  final int? lastUpdatedUnix;
  final List<SimplefinTransaction> transactions;

  const SimplefinAccount({
    required this.id,
    required this.name,
    this.orgName,
    this.orgDomain,
    required this.currency,
    required this.balanceCents,
    this.availableBalanceCents,
    required this.balanceDateUnix,
    this.lastUpdatedUnix,
    this.transactions = const [],
  });

  /// Parse from SimpleFIN JSON response.
  factory SimplefinAccount.fromJson(Map<String, dynamic> json) {
    final org = json['org'] as Map<String, dynamic>?;
    final extra = json['extra'] as Map<String, dynamic>?;
    return SimplefinAccount(
      id: json['id'] as String,
      name: json['name'] as String,
      orgName: org?['name'] as String?,
      orgDomain: org?['domain'] as String?,
      currency: (json['currency'] as String?) ?? 'USD',
      balanceCents: _amountToCents(json['balance'] as String),
      availableBalanceCents: json['available'] != null
          ? _amountToCents(json['available'] as String)
          : null,
      balanceDateUnix: json['balance-date'] as int,
      lastUpdatedUnix: extra?['last-updated'] as int?,
      transactions: (json['transactions'] as List<dynamic>?)
              ?.map((t) =>
                  SimplefinTransaction.fromJson(t as Map<String, dynamic>))
              .toList() ??
          const [],
    );
  }
}

/// A single transaction returned by SimpleFIN.
class SimplefinTransaction {
  final String id;
  final int postedUnix;
  final int amountCents;
  final String description;
  final int? transactedAtUnix;
  final bool isPending;

  const SimplefinTransaction({
    required this.id,
    required this.postedUnix,
    required this.amountCents,
    required this.description,
    this.transactedAtUnix,
    this.isPending = false,
  });

  /// Parse from SimpleFIN JSON response.
  factory SimplefinTransaction.fromJson(Map<String, dynamic> json) {
    return SimplefinTransaction(
      id: json['id'] as String,
      postedUnix: json['posted'] as int,
      amountCents: _amountToCents(json['amount'] as String),
      description: json['description'] as String? ?? '',
      transactedAtUnix: json['transacted_at'] as int?,
      isPending: json['pending'] as bool? ?? false,
    );
  }
}

/// Top-level response from GET /accounts.
class SimplefinAccountsResponse {
  final List<String> errors;
  final List<SimplefinAccount> accounts;

  const SimplefinAccountsResponse({
    this.errors = const [],
    this.accounts = const [],
  });

  /// Parse from SimpleFIN JSON response.
  factory SimplefinAccountsResponse.fromJson(Map<String, dynamic> json) {
    return SimplefinAccountsResponse(
      errors: (json['errors'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      accounts: (json['accounts'] as List<dynamic>?)
              ?.map(
                  (a) => SimplefinAccount.fromJson(a as Map<String, dynamic>))
              .toList() ??
          const [],
    );
  }
}

/// Exception thrown by SimpleFIN API calls.
class SimplefinApiException implements Exception {
  final int statusCode;
  final String message;

  const SimplefinApiException({
    required this.statusCode,
    required this.message,
  });

  @override
  String toString() => 'SimplefinApiException($statusCode): $message';
}

/// Parse a SimpleFIN amount string (e.g., "-123.45") to integer cents.
int _amountToCents(String amount) {
  return (double.parse(amount) * 100).round();
}
