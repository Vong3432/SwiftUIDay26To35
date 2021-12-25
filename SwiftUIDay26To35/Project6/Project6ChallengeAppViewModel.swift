//
//  Project6ChallengeAppViewModel.swift
//  SwiftUIDay26To35
//
//  Created by Vong Nyuksoon on 24/12/2021.
//

import Foundation
import SwiftUI

class Project6ViewModel: ObservableObject {
    @Published var multiplication: Int = 2
    @Published var howManyQuestions: Int = 5
    @Published var answer: Int? = nil {
        didSet {
            self.msg = ""
            self.desc = ""
        }
    }
    @Published var currentQuestion: Int = 0
    
    @Published var question: Question? = nil
    
    // Use sets to store possible answer so that no need worry duplication
    @Published var possibleAnswers = Set<Int>()
    
    @Published var msg: String = ""
    @Published var desc: String = ""
    @Published var showMsg: Bool = false
    
    @Published var score: Int = 0
    
    @Published var showSheet: Bool = false
    
    @Published var ansIsCorrect: Bool? = nil
    
    let questionCounts = [5, 10, 20]
    
    func generateQuestion() {
        currentQuestion += 1
        
        possibleAnswers.removeAll()
        answer = nil
        ansIsCorrect = nil
        
        let randNumber = Int.random(in: 1...12)
        let correctAns = randNumber * multiplication
        
        let generatedQuestion = Question(question: "\(randNumber) * \(multiplication) = ?", answer: correctAns)
        
        // insert correct ans to set
        possibleAnswers.insert(correctAns)
        
        while possibleAnswers.count != 4 {
            possibleAnswers.insert(Int.random(in: 1...12) * multiplication)
        }
        
        question = generatedQuestion
    }
    
    func changeMultiply(of: Int) {
        withAnimation(.spring()) {
            multiplication = of
        }
        
        reset()
        generateQuestion()
    }
    
    func changeHowManyQuestion(max: Int) {
        withAnimation(.spring()) {
            howManyQuestions = max
        }
        
        reset()
        generateQuestion()
    }
    
    func checkAns() {
        
        self.msg = ""
        self.desc = ""
        
        guard question != nil, let q = question else { return }
        
        if q.answer == answer {
            setMsg(
                msgTitle: "Correct answer",
                desc: howManyQuestions - currentQuestion == 1 ? "Keep it up! You have 1 question left." :  "Keep it up! You have \(howManyQuestions - currentQuestion) questions left.")
            score += 1
            ansIsCorrect = true
        } else {
            setMsg(msgTitle: "Incorrect answer", desc: "The correct answer is \(q.answer)")
            ansIsCorrect = false
        }
        
        self.showMsg = true
        
        if currentQuestion == howManyQuestions {
            setMsg(msgTitle: "Congratz, you have finished.", desc: "Score: \(score)")
            self.showMsg = true
            reset()
            return
        }
        
    }
    
    func setMsg(msgTitle: String, desc: String) {
        self.msg = msgTitle
        self.desc = desc
    }
    
    func reset() {
        score = 0
        currentQuestion = 0
    }
}
