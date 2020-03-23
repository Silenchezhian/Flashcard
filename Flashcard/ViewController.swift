//
//  ViewController.swift
//  Flashcard
//
//
//  Copyright © 2020 Sahana Ilenchezhian. All rights reserved.
//

import UIKit

struct Flashcard {
    var question: String
    var answer: String
    var extraAnswer1: String
    var extraAnswer2: String
}

class ViewController: UIViewController {

    @IBOutlet weak var backLabel: UILabel!
    @IBOutlet weak var frontLabel: UILabel!
    @IBOutlet weak var card: UIView!
    
    @IBOutlet weak var btn1: UIButton!
    @IBOutlet weak var btn2: UIButton!
    @IBOutlet weak var btn3: UIButton!
    
    
    @IBOutlet weak var prevButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    var flashcards = [Flashcard]()
    
    var currentIndex = 0
    
    //remembers correct answer
    var correctAnswerButton: UIButton!
    var extraAnswerOneButton: UIButton!
    var extraAnswerTwoButton: UIButton!
    
    override func viewWillAppear(_ animated: Bool){
         super.viewWillAppear(animated)
         
        
         //main flashcard
         card.alpha = 0.0
         card.transform = CGAffineTransform.identity.scaledBy(x: 0.75, y: 0.75)
         
         //multiple choice answers
         btn1.alpha = 0.0
         btn1.transform = CGAffineTransform.identity.scaledBy(x: 0.75, y: 0.75)
         btn2.alpha = 0.0
         btn2.transform = CGAffineTransform.identity.scaledBy(x: 0.75, y: 0.75)
         btn3.alpha = 0.0
         btn3.transform = CGAffineTransform.identity.scaledBy(x: 0.75, y: 0.75)
         
         
         UIView.animate(withDuration: 0.6, delay: 0.5, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [], animations: {
             
             //card
             self.card.alpha = 1.0
             self.card.transform = CGAffineTransform.identity
             
            //buttons
            self.btn1.alpha = 1.0
            self.btn1.transform = CGAffineTransform.identity
            self.btn2.alpha = 1.0
            self.btn2.transform = CGAffineTransform.identity
            self.btn3.alpha = 1.0
            self.btn3.transform = CGAffineTransform.identity
         })
     }
    
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
        btn1.layer.borderColor = #colorLiteral(red: 0.281324178, green: 0.836773634, blue: 0.900480926, alpha: 1)
        btn1.layer.cornerRadius = 20.0
        btn1.clipsToBounds = true
        
        btn2.layer.borderWidth = 3.0
        btn2.layer.borderColor = #colorLiteral(red: 0.281324178, green: 0.836773634, blue: 0.900480926, alpha: 1)
        btn2.layer.cornerRadius = 20.0
        btn2.clipsToBounds = true
        
        btn3.layer.borderWidth = 3.0
        btn3.layer.borderColor = #colorLiteral(red: 0.281324178, green: 0.836773634, blue: 0.900480926, alpha: 1)
        btn3.layer.cornerRadius = 20.0
        btn3.clipsToBounds = true
        
        //reads saved Flashcards
        readSavedFlashcards()
        
        if flashcards.count == 0 {
            updateFlashcard(question: "What's the capital of Australia?", answer: "Canberra", extraAnswer1: "Melbourne", extraAnswer2: "Sydney", isExisting: false)
            //currentIndex = currentIndex + 1
        } else {
            updateLabels()
            updateNextPrevButtons()
        }
    }

 

    @IBAction func didTapOnFlashcard(_ sender: Any) {
        flipFlashcard()
    }
    
    func flipFlashcard(){
        UIView.transition(with: card, duration: 0.3, options: .transitionFlipFromRight, animations: {
            if(self.frontLabel.isHidden){
                self.frontLabel.isHidden = false
                }
                else{
                self.frontLabel.isHidden = true
                }
            })
    }
    
    @IBAction func didTapOnDelete(_ sender: Any) {
        let alert = UIAlertController(title: "Delete flashcard", message:"Are you sure you want to delete it?", preferredStyle: .actionSheet)
        present(alert, animated: true)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) {action in self.deleteCurrentFlashcard()}
        alert.addAction(deleteAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(cancelAction)
        
    }
    
    func deleteCurrentFlashcard(){
        
        //delete current, if not the only flashcard in set
        if flashcards.count != 1 {
            flashcards.remove(at: currentIndex)
        }
        
        else if flashcards.count == 1 {
            let alert = UIAlertController(title: "Flashcard cannot be deleted", message: "You cannot delete the last flashcard in the deck", preferredStyle:UIAlertController.Style.alert)
            present(alert, animated: true)
            
            let okAction = UIAlertAction(title: "Ok", style: .default)
            alert.addAction(okAction)
        }
        //checks if last card was deleted
        if currentIndex > flashcards.count - 1{
            currentIndex = flashcards.count - 1
        }
        
        updateNextPrevButtons()
        updateLabels()
        saveAllFlashcardsToDisk()
    }
    @IBAction func didTapOnNext(_ sender: Any) {
        //update currentIndex
        currentIndex = currentIndex + 1
        
        //update labels
        updateLabels()
        
        //update buttons
        updateNextPrevButtons()
        
        //animate
        animateCardRightOut()
    }
    
    
    @IBAction func didTapOnPrev(_ sender: Any) {
        //update currentIndex
        currentIndex = currentIndex - 1
        
        //update labels
        updateLabels()
        
        //update buttons
        updateNextPrevButtons()
        
        //animate
        animateCardLeftOut()
    }
    
    func updateLabels(){
        //get current flashcard
        let currentFlashcard = flashcards[currentIndex]
        
        //update labels
        frontLabel.text = currentFlashcard.question
        backLabel.text = currentFlashcard.answer
        
        //update buttons
        //btn2.setTitle(currentFlashcard.answer, for: UIControl.State.normal)
        //btn1.setTitle(currentFlashcard.extraAnswer1, for: UIControl.State.normal)
        //btn3.setTitle(currentFlashcard.extraAnswer2, for: UIControl.State.normal)
        
        //shuffle
        let buttons = [btn1, btn2, btn3].shuffled()
        let answers = [currentFlashcard.answer, currentFlashcard.extraAnswer1, currentFlashcard.extraAnswer2].shuffled()
        
        for(button, answer) in zip(buttons, answers){
            button?.setTitle(answer, for: .normal)
            
            //if this button is correct
            if answer == currentFlashcard.answer {
                correctAnswerButton = button
            }
            if answer == currentFlashcard.extraAnswer1{
                extraAnswerOneButton = button
            }
            if answer == currentFlashcard.extraAnswer2{
                extraAnswerTwoButton = button
            }
            
        }
        
        btn1.isEnabled = true
        btn2.isEnabled = true
        btn3.isEnabled = true
        frontLabel.isHidden = false
    }
    
    func updateFlashcard(question: String, answer: String, extraAnswer1: String, extraAnswer2: String, isExisting: Bool){
        let flashcard = Flashcard(question: question, answer: answer, extraAnswer1: extraAnswer1, extraAnswer2: extraAnswer2)
        if isExisting{
            //replace existing flashcard
            print(currentIndex)
            print(flashcards.count)
            flashcards[currentIndex] = flashcard
        } else {
            //Adding flashcards in the flashcard array
            flashcards.append(flashcard)
            
            //Logging to the console
            print("added new flashcard!")
            print("we now have \(flashcards.count) flashcards")
            
            //update current index
            currentIndex = flashcards.count - 1
            print("Our current index is \(currentIndex)")
        }
            
        //update buttons
        updateNextPrevButtons()
        
        //update labels
        updateLabels()
        
        saveAllFlashcardsToDisk()
    }
    
    func updateNextPrevButtons(){
        
        //Disables next button if at the end
        if currentIndex == flashcards.count - 1{
            nextButton.isEnabled = false
        } else {
            nextButton.isEnabled = true
        }
        
        //Disable prev button if at the beggining
        if currentIndex == 0{
            prevButton.isEnabled = false
        } else {
            prevButton.isEnabled = true
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let navigationController = segue.destination as! UINavigationController
        
        let creationController = navigationController.topViewController as! CreationViewController
        
    creationController.flashcardsController = self
        
        if segue.identifier == "EditSegue"{
        creationController.initialQuestion = frontLabel.text
        creationController.initialAnswer = backLabel.text
        creationController.initialExtraAnswer1 = extraAnswerOneButton.currentTitle
        creationController.initialExtraAnswer2 = extraAnswerTwoButton.currentTitle
            
            
        }
    }
    
    @IBAction func didTapBtnOne(_ sender: Any) {
        //btn1.isHidden = true
        if btn1 == correctAnswerButton{
            flipFlashcard()
        }
        else{
            frontLabel.isHidden = false
            btn1.isEnabled = false
            
        }
    }
    
    @IBAction func didTapBtnTwo(_ sender: Any) {
        //self.frontLabel.isHidden = true
        
        if btn2 == correctAnswerButton{
            flipFlashcard()
        }
        else{
            frontLabel.isHidden = false
            btn2.isEnabled = false
            
        }
    }
    
    @IBAction func didTapBtnThree(_ sender: Any) {
        //btn3.isHidden = true
        if btn3 == correctAnswerButton{
            flipFlashcard()
        }
        else{
            frontLabel.isHidden = false
            btn3.isEnabled = false
            
        }
    }
    
    //functions to animate right button
    func animateCardRightOut(){
        UIView.animate(withDuration: 0.1, animations: {
            self.card.transform = CGAffineTransform.identity.translatedBy(x: -300.0, y: 0.0)
        }, completion: { finished in
            
            //update labels
            self.updateLabels()
            
            //run other animations
            self.animateCardRightIn()
        })
    }
    
    func animateCardRightIn(){
        
        card.transform = CGAffineTransform.identity.translatedBy(x: 300.0, y: 0.0)
        
        UIView.animate(withDuration: 0.1){
            self.card.transform = CGAffineTransform.identity
        }
    }
    
    //functions to animate prev button
    func animateCardLeftOut(){
        UIView.animate(withDuration: 0.1, animations: {
            self.card.transform = CGAffineTransform.identity.translatedBy(x: 300.0, y: 0.0)
        }, completion: { finished in
            
            //update labels
            self.updateLabels()
            
            //run other animations
            self.animateCardLeftIn()
        })
    }
    
    func animateCardLeftIn(){
        
        card.transform = CGAffineTransform.identity.translatedBy(x: -300.0, y: 0.0)
        
        UIView.animate(withDuration: 0.1){
            self.card.transform = CGAffineTransform.identity
        }
    }
    func saveAllFlashcardsToDisk(){
        
        //from flashcard array to dictionary array
        let dictionaryArray = flashcards.map { (card) -> [String: String] in return ["question": card.question, "answer": card.answer, "extraAnswer1": card.extraAnswer1, "extraAnswer2":card.extraAnswer2]
        
        }
        //saves array using UserDefaults
        UserDefaults.standard.set(dictionaryArray, forKey: "flashcards")
        
        //logs it
        print("Flashcards saved to UserDefaults")
    }
    
    func readSavedFlashcards(){
        if let dictionaryArray = UserDefaults.standard.array(forKey: "flashcards") as? [[String:String]]{
            
            let savedCards = dictionaryArray.map{dictionary -> Flashcard in return Flashcard(question: dictionary["question"]!, answer:dictionary["answer"]!, extraAnswer1: dictionary["extraAnswer1"]!, extraAnswer2: dictionary["extraAnswer2"]!)}
            
            flashcards.append(contentsOf: savedCards)
        }
        
    }
}

