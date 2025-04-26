//
//  RealBiometricService.swift
//  UniversityN
//
//  Created by Gamika Punsisi on 2025-04-25.
//

import Foundation
import LocalAuthentication

class RealBiometricService: BiometricService {
    func authenticate(completion: @escaping (Bool, String?) -> Void) {
        let context = LAContext()
        var error: NSError?

        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Authenticate to continue") { success, authError in
                DispatchQueue.main.async {
                    if success {
                        completion(true, nil)
                    } else {
                        completion(false, authError?.localizedDescription)
                    }
                }
            }
        } else {
            completion(false, "Biometric authentication not available.")
        }
    }
}

