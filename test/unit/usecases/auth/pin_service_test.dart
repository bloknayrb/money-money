import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:patrimonium/data/local/secure_storage/secure_storage_service.dart';
import 'package:patrimonium/domain/usecases/auth/pin_service.dart';

class MockSecureStorage extends Mock implements SecureStorageService {}

void main() {
  late MockSecureStorage mockStorage;
  late PinService pinService;

  setUp(() {
    mockStorage = MockSecureStorage();
    pinService = PinService(mockStorage);
  });

  group('PinService', () {
    test('hasPin returns true when pin hash exists', () async {
      when(() => mockStorage.hasPin()).thenAnswer((_) async => true);
      final result = await pinService.hasPin();
      expect(result, isTrue);
      verify(() => mockStorage.hasPin()).called(1);
    });

    test('hasPin returns false when pin hash does not exist', () async {
      when(() => mockStorage.hasPin()).thenAnswer((_) async => false);
      final result = await pinService.hasPin();
      expect(result, isFalse);
      verify(() => mockStorage.hasPin()).called(1);
    });

    test('setupPin generates salt, hashes pin and stores them', () async {
      when(() => mockStorage.setPinHash(any(), any())).thenAnswer((_) async {});
      
      await pinService.setupPin('1234');
      
      verify(() => mockStorage.setPinHash(any(), any())).called(1);
    });

    test('verifyPin returns true for correct pin', () async {
      String? savedHash;
      String? savedSalt;
      
      when(() => mockStorage.setPinHash(any(), any())).thenAnswer((invocation) async {
        savedHash = invocation.positionalArguments[0] as String;
        savedSalt = invocation.positionalArguments[1] as String;
      });
      
      await pinService.setupPin('1234');
      
      when(() => mockStorage.getPinHash()).thenAnswer((_) async => savedHash);
      when(() => mockStorage.getPinSalt()).thenAnswer((_) async => savedSalt);
      
      final result = await pinService.verifyPin('1234');
      expect(result, isTrue);
    });

    test('verifyPin returns false for incorrect pin', () async {
      String? savedHash;
      String? savedSalt;
      
      when(() => mockStorage.setPinHash(any(), any())).thenAnswer((invocation) async {
        savedHash = invocation.positionalArguments[0] as String;
        savedSalt = invocation.positionalArguments[1] as String;
      });
      
      await pinService.setupPin('1234');
      
      when(() => mockStorage.getPinHash()).thenAnswer((_) async => savedHash);
      when(() => mockStorage.getPinSalt()).thenAnswer((_) async => savedSalt);
      
      final result = await pinService.verifyPin('0000');
      expect(result, isFalse);
    });

    test('verifyPin returns false when no hash or salt is stored', () async {
      when(() => mockStorage.getPinHash()).thenAnswer((_) async => null);
      when(() => mockStorage.getPinSalt()).thenAnswer((_) async => null);
      
      final result = await pinService.verifyPin('1234');
      expect(result, isFalse);
    });

    test('changePin updates pin when old pin is correct', () async {
      String? savedHash;
      String? savedSalt;
      
      when(() => mockStorage.setPinHash(any(), any())).thenAnswer((invocation) async {
        savedHash = invocation.positionalArguments[0] as String;
        savedSalt = invocation.positionalArguments[1] as String;
      });
      
      await pinService.setupPin('1234');
      
      when(() => mockStorage.getPinHash()).thenAnswer((_) async => savedHash);
      when(() => mockStorage.getPinSalt()).thenAnswer((_) async => savedSalt);
      
      final result = await pinService.changePin('1234', '5678');
      expect(result, isTrue);
      
      verify(() => mockStorage.setPinHash(any(), any())).called(2);
    });

    test('changePin returns false when old pin is incorrect', () async {
      String? savedHash;
      String? savedSalt;
      
      when(() => mockStorage.setPinHash(any(), any())).thenAnswer((invocation) async {
        savedHash = invocation.positionalArguments[0] as String;
        savedSalt = invocation.positionalArguments[1] as String;
      });
      
      await pinService.setupPin('1234');
      
      when(() => mockStorage.getPinHash()).thenAnswer((_) async => savedHash);
      when(() => mockStorage.getPinSalt()).thenAnswer((_) async => savedSalt);
      
      final result = await pinService.changePin('0000', '5678');
      expect(result, isFalse);
      
      verify(() => mockStorage.setPinHash(any(), any())).called(1); // Only setup was called
    });

    test('clearPin removes pin hash and salt', () async {
      when(() => mockStorage.clearPin()).thenAnswer((_) async {});
      await pinService.clearPin();
      verify(() => mockStorage.clearPin()).called(1);
    });
  });
}