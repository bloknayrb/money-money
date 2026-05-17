/// Payee-name normalization for consistent matching across the
/// auto-categorization system.
///
/// Extracted as a top-level function so it can be used from contexts
/// that don't have an `AutoCategorizeService` instance — e.g. the
/// suggested-rule prompt logic in the transaction edit screen and (in
/// Phase 3) the `RuleSuggestionService`.
library;

/// Known POS terminal prefixes to strip from payee names.
final _posPrefixes = [
  'SQ *',
  'TST* ',
  'TST*',
  'PAYPAL *',
  'SP * ',
  'SP *',
  'CKE*',
  'DD *',
  'GOOGLE *',
  'APL*',
];

/// Patterns that should be replaced entirely with a canonical name.
final _canonicalReplacements = [
  (RegExp(r'^AMZN MKTP US\b.*', caseSensitive: false), 'AMAZON'),
  (RegExp(r'^AMAZON\.COM\b.*', caseSensitive: false), 'AMAZON'),
  (RegExp(r'^AMZN\b.*', caseSensitive: false), 'AMAZON'),
];

/// Trailing noise patterns to strip.
final _trailingNoise = RegExp(
  r'\s*#\d+$' // trailing reference numbers
  r'|\s+[A-Z]{2}\s+\d{5}(-\d{4})?$' // state + zip
  r'|\s+\d{3}-\d{3}-\d{4}$', // phone numbers
);

/// Trailing store/location identifiers.
final _trailingStoreId = RegExp(
  r'\s+(S\d+|ST\d+|T\d+|STORE\s*\d+|LOC\s*\d+|UNIT\s*\d+)$',
);

/// Trailing transaction/reference IDs (6+ chars, must contain both letters
/// and digits to avoid stripping real words like SUPERCENTER).
final _trailingRefId =
    RegExp(r'\s+(?=[A-Z0-9]*[0-9])(?=[A-Z0-9]*[A-Z])[A-Z0-9]{6,}$');

/// Trailing date-like patterns (MM/DD).
final _trailingDate = RegExp(r'\s+\d{2}/\d{2}$');

/// Normalize a raw payee string for consistent matching.
///
/// Steps (order matters):
/// 1. Trim + uppercase
/// 2. Canonical replacement (e.g. AMZN MKTP US → AMAZON)
/// 3. POS prefix stripping (SQ *, TST*, PAYPAL *, ...)
/// 4. Trailing noise stripping (state+zip, phone, ref#)
/// 5. Trailing date stripping (exposes store/ref IDs underneath)
/// 6. Trailing store-ID stripping (S123, ST456, LOC 2)
/// 7. Trailing transaction-ID stripping (6+ alphanumeric, mixed)
/// 8. Whitespace collapse
String normalizePayee(String raw) {
  var s = raw.trim().toUpperCase();

  for (final (pattern, replacement) in _canonicalReplacements) {
    if (pattern.hasMatch(s)) return replacement;
  }

  for (final prefix in _posPrefixes) {
    if (s.startsWith(prefix.toUpperCase())) {
      s = s.substring(prefix.length);
      break;
    }
  }

  s = s.replaceAll(_trailingNoise, '');
  s = s.replaceAll(_trailingDate, '');
  s = s.replaceAll(_trailingStoreId, '');
  s = s.replaceAll(_trailingRefId, '');

  s = s.replaceAll(RegExp(r'\s+'), ' ').trim();

  return s;
}
