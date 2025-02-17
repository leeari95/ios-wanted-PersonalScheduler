//
//  NSObject+extension.swift
//  PersonalScheduler
//
//  Created by Ari on 2023/01/11.
//

import Foundation

extension NSObject {

    var className: String {
        return String(describing: type(of: self))
    }

    class var className: String {
        return String(describing: self)
    }

}
