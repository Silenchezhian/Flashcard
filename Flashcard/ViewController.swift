//
//  ViewController.swift
//  Flashcard
//
//
//  Copyright © 2020 Sahana Ilenchezhian. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var backLabel: UILabel!
    @IBOutlet weak var frontLabel: UILabel!
    @IBOutlet weak var card: UIView!
    
    @IBOutlet weak var btn1: UIButton!
    @IBOutlet weak var btn2: UIButton!
    @IBOutlet weak var btn3: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //rounded corners
        card.layer.cornerRadius = 20.0
        
        backLabel.layer.cornerRadius = 20.0
        backLabel.clipsToBounds = true
        
        frontLabel.layer.cornerRadius = 20.0
        frontLabel.clipsToBounds = true
        
        
        //shadows
        card.layer.shadowRadius = 15.0
        card.layer.shadowOpacity = 0.2
        
        //layout for buttons
        btn1.layer.borderWidth = 3.0
        btn1.layer.borderColor = #colorLiteral(red: 0.5323996126, green: 1, blue: 0.6806098388, alpha: 1)
        btn1.layer.cornerRadius = 20.0
        btn1.clipsToBounds = true
        
        btn2.layer.borderWidth = 3.0
        btn2.layer.borderColor = #colorLiteral(red: 0.5323996126, green: 1, blue: 0.6806098388, alpha: 1)
        btn2.layer.cornerRadius = 20.0
        btn2.clipsToBounds = true
        
        btn3.layer.borderWidth = 3.0
        btn3.layer.borderColor = #colorLiteral(red: 0.5323996126, green: 1, blue: 0.6806098388, alpha: 1)
        btn3.layer.cornerRadius = 20.0
        btn3.clipsToBounds = true
    }


    @IBAction func didTapOnFlashcard(_ sender: Any) {
        
        
        if(frontLabel.isHidden){
            frontLabel.isHidden = false
        }
        else{
            frontLabel.isHidden = true
        }
        
    }
    
    func updateFlashcard(question: String, answer: String, extraAnswer1: String, extraAnswer2: String){
        
        frontLabel.text = question
        backLabel.text = answer
        
        btn2.setTitle(answer, for: UIControl.State.normal)
        btn1.setTitle(extraAnswer1, for: UIControl.State.normal)
        btn3.setTitle(extraAnswer2, for: UIControl.State.normal)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let navigationController = segue.destination as! UINavigationController
        
        let creationController = navigationController.topViewController as! CreationViewController
        
    creationController.flashcardsController = self
        
        if segue.identifier == "EditSegue"{
        creationController.initialQuestion = frontLabel.text
        creationController.initialAnswer = backLabel.text
        creationController.initialExtraAnswer1 = btn1.currentTitle
        creationController.initialExtraAnswer2 = btn3.currentTitle
            
            
        }
    }
    
    @IBAction func didTapBtnOne(_ sender: Any) {
        btn1.isHidden = true
    }
    
    @IBAction func didTapBtnTwo(_ sender: Any) {
        self.frontLabel.isHidden = true
    }
    
    @IBAction func didTapBtnThree(_ sender: Any) {
        btn3.isHidden = true
    }
}

