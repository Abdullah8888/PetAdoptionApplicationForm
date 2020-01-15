//
//  GenericViews.swift
//  PetAdoptionApplicationForm
//
//  Created by Jimoh Babatunde  on 13/01/2020.
//  Copyright © 2020 Jimoh Babatunde. All rights reserved.
//

import Foundation
import UIKit

class BaseViews: UIViewController {
    let ss = 0
    
    public func createViews(type: String) -> Any {
        var uiView: UIView?
        if type == "text" {
            uiView = UITextField()
        }
        else if type == "embeddedphoto" {
            uiView = UIImageView()
        }
        else if type == "yesno" {
            uiView = UIButton()
        }
        else if type == "formattednumeric" {
            uiView = UITextField()
        }
        else if type == "datetime" {
            uiView = UIDatePicker()
        }
    
        
        return uiView!
        
    }
    
}
