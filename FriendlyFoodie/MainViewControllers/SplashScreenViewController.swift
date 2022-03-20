//
//  SplashScreenViewController.swift
//  FriendlyFoodie
//
//  Created by BumSu Park on 2022/03/15.
//

import UIKit

// UIView for Splash Screen
class SplashScreenViewController: UIViewController {

    @IBOutlet weak var StartButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Adding action to the Button so the view could be dismissed
        StartButton.addTarget(self, action: #selector(handleClickButton), for: .touchDown)
        
    }
    
    @objc func handleClickButton() {
        dismiss(animated: true)
    }
}
