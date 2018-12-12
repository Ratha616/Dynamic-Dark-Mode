//
//  SetupStep.swift
//  Dynamic Dark Mode
//
//  Created by Apollo Zhu on 12/11/18.
//  Copyright © 2018 Dynamic Dark Mode. All rights reserved.
//

import Cocoa

var presentors = [NSViewController]()

func releasePresentors() {
    while case let presentor? = presentors.popLast() {
        presentor.presentedViewControllers?.forEach {
            presentor.dismiss($0)
        }
    }
}

protocol SetupStep: AnyObject {
    func showNext()
}

extension SetupStep where Self: NSViewController {
    func showNext() {
        presentors.append(self)
        DispatchQueue.main.async { [weak self] in
            self?.performSegue(withIdentifier: "next", sender: nil)
        }
    }
}

protocol LastSetupStep: SetupStep { }

extension LastSetupStep where Self: NSViewController {
    func showNext() {
        preferences.hasLaunchedBefore = true
        Preferences.setup()
        Welcome.close()
        releasePresentors()
        startUpdating {
            DispatchQueue.main.async {
                SettingsViewController.show()
            }
        }
    }
}
