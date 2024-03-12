//
//  Router.swift
//  ShiftTestTask
//
//  Created by Александр Федоткин on 11.03.2024.
//

import Foundation
import UIKit

final class Router {
    private var controller: UIViewController?
    private var targetControllerFirst: UIViewController?
    private var targetControllerSecond: UIViewController?
    
    func setRootController(controller: UIViewController) {
        self.controller = controller
    }
    
    func setTargetControllers(targetControllerFirst: UIViewController, targetControllerSecond: UIViewController) {
        self.targetControllerFirst = targetControllerFirst
        self.targetControllerSecond = targetControllerSecond
    }
    
    func toAddNote() {
        guard let targetController = targetControllerFirst else { return }
        self.controller?.navigationController?.pushViewController(targetController, animated: true)
    }
    
    func toCurrentCell(_ indexPath: IndexPath) {
        guard let targetControllerSecond = targetControllerSecond as? CurrentNote else { return }
        targetControllerSecond.indexPath = indexPath
        self.controller?.navigationController?.pushViewController(targetControllerSecond, animated: true)
    }
    
}
