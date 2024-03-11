//
//  ListOfNotesProtocol.swift
//  ShiftTestTask
//
//  Created by Александр Федоткин on 11.03.2024.
//

import Foundation
import UIKit

protocol ListOfNotesProtocol : UIViewController {
    var goToAddNote: (() -> Void)? { get set }
    var goToNote: (() -> Void)? { get set }
}
