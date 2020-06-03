//
//  ViewController.swift
//  SimpleOATHUIKit
//
//  Created by Jens Utbult on 2020-06-03.
//  Copyright © 2020 Jens Utbult. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        YubiKitManager.shared.nfcSession.startIso7816Session()
        // Do any additional setup after loading the view.
    }


}

