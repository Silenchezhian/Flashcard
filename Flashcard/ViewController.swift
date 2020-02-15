//
//  ViewController.swift
//  Flashcard
//
//  Created by Chelian Pandian on 2/14/20.
//  Copyright © 2020 Sahana Ilenchezhian. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var backLabel: UILabel!
    @IBOutlet weak var frontLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


    @IBAction func didTapOnFlashcard(_ sender: Any) {
        self.frontLabel.isHidden = true
    }
}

