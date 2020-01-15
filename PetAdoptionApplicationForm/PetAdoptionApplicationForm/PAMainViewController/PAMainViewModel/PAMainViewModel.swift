//
//  PAMainViewControllerModel.swift
//  PetAdoptionApplicationForm
//
//  Created by Jimoh Babatunde  on 11/01/2020.
//  Copyright © 2020 Jimoh Babatunde. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON


//protocol PAMainViewDelegate {
//    <#requirements#>
//}
class PAMainViewModel {
    
    public func getApplicationDetails() -> JSON {
        let path = Bundle.main.path(forResource: "pet_adoption", ofType: "json")!
        let jsonString = try? String(contentsOfFile: path, encoding: String.Encoding.utf8)
        let applicationDetails = JSON(parseJSON: jsonString!)
        return applicationDetails
    }
}
