//
//  ViewControllersFactory.swift
//  ShoppingApp
//
//  Created by Sireesha Neelapu on 28/07/21.
//

import Foundation
import UIKit

enum StoryBoardName: String {
    case main = "Main"
}

class ViewControllersFactory {
    static func viewController<T: UIViewController>(name: StoryBoardName = .main, identifier: String? = nil) -> T {
        return vcWithId(name, identifier ?? T.debugDescription().components(separatedBy: ".").last!) as! T
    }

    private static func vcWithId(_ name: StoryBoardName, _ id: String) -> UIViewController {
        return storyBoard(name: name.rawValue).instantiateViewController(withIdentifier: id)
    }

    fileprivate static func storyBoard(name: String) -> UIStoryboard {
        return UIStoryboard(name: name, bundle: nil)
    }
}
