//
//  Extensions.swift
//  SilentPushTest
//
//  Created by Daniel Hjärtström on 2019-11-27.
//  Copyright © 2019 Daniel Hjärtström. All rights reserved.
//

import UIKit
import CoreData

extension NSManagedObject {
    static var identifier: String {
        return String(describing: self)
    }
}

extension Data {
    func decode<T: Decodable>() -> T? {
        let decoder = JSONDecoder()
        do {
            let result = try decoder.decode(T.self, from: self)
            return result
        } catch let error {
            print(error.localizedDescription)
        }
        return nil
    }
}

extension UIImage {
    func asTemplate() -> UIImage? {
        return self.withRenderingMode(.alwaysTemplate)
    }
}

extension UIApplication {
    
    static func setbadgeNumberTo(_ count: Int) {
        DispatchQueue.main {
            UIApplication.shared.applicationIconBadgeNumber = count
        }
    }
    
    static func increaseBadgeNumberBy(_ count: Int) {
        DispatchQueue.main {
            UIApplication.shared.applicationIconBadgeNumber += count
        }
    }
    
    static func decreaseBadgeNumberBy(_ count: Int) {
        DispatchQueue.main {
            UIApplication.shared.applicationIconBadgeNumber -= count
        }
    }
}

extension DispatchQueue {
    static func main(completion: @escaping () -> ()) {
        DispatchQueue.main.async {
            completion()
        }
    }
}
