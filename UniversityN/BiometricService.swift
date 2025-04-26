//
//  BiometricService.swift
//  UniversityN
//
//  Created by Gamika Punsisi on 2025-04-25.
//

import LocalAuthentication

protocol BiometricService {
    func authenticate(completion: @escaping (Bool, String?) -> Void)
}
