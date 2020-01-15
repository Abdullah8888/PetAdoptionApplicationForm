//
//  PAExtensions.swift
//  PetAdoptionApplicationForm
//
//  Created by Jimoh Babatunde  on 11/01/2020.
//  Copyright © 2020 Jimoh Babatunde. All rights reserved.
//

import Foundation


//MARK: Notification Message Identifiers
extension Notification.Name {
    static let didFillFirstPage = Notification.Name("didFillFirstPage")
    static let didFillFirstPageFailed = Notification.Name("didFillFirstPageFailed")
    static let didEndPage = Notification.Name("didEndPage")
    static let noPreviousPage = Notification.Name("noPreviousPage")
    static let didValidationFailed = Notification.Name("didValidationFailed")
    static let didValidationSuccess = Notification.Name("didValidationSuccess")
    static let phoneNumberFailed = Notification.Name("phoneNumberFailed")
}
