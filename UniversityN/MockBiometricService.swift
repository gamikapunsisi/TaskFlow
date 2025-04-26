//  MockBiometricService.swift
//  UniversityN

class MockBiometricService: BiometricService {
    var shouldSucceed = true
    var testMessage: String?

    func authenticate(completion: @escaping (Bool, String?) -> Void) {
        completion(shouldSucceed, testMessage)
    }
}
