//
//  WordScrambleAppViewModel.swift
//  SwiftUIDay26To35
//
//  Created by Vong Nyuksoon on 24/12/2021.
//

import Foundation
import UIKit
import SwiftUI

class WordScrambleAppViewModel: ObservableObject {
    
    @Published var usedWords = [String]()
    @Published var rootWord = ""
    @Published var newWord = ""
    @Published var errorTitle = ""
    @Published var errorMessage = ""
    @Published var showingError = false
    @Published var score = 0
    
    func startGame() {
        if let startWordFileUrl = Bundle.main.url(forResource: "start", withExtension: "txt") {
            // load file to string
            if let startWords = try? String(contentsOf: startWordFileUrl) {
                let allWords = startWords.components(separatedBy: .newlines)
                
                rootWord = allWords.randomElement() ?? "alpacca"
                
                return
            }
        }
        
        fatalError("Could not load start.txt from bundle") // terminate App if cant load
    }
    
    func addNewWord() {
        // prevent duplication with difference case
        let answer = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        
        // if is empty, exit
        guard answer.count > 0 else { return }
        
        guard isTooShort(word: answer) else {
            wordError(title: "Too short", message: "Min. length is 3")
            return
        }
        
        guard isOriginal(word: answer) else {
            wordError(title: "Word used already", message: "Be more original")
            return
        }
        
        guard isPossible(word: answer) else {
            wordError(title: "Word not possible", message: "You can't spell that word from '\(rootWord)'!")
            return
        }
        
        guard isReal(word: answer) else {
            wordError(title: "Word not recognized", message: "You can't just make them up, you know!")
            return
        }
        
        withAnimation {
            usedWords.insert(answer, at: 0)
        }
        
        verifyAns(word: answer)
        
        newWord = ""
    }
    
    func isOriginal(word: String) -> Bool {
        return !usedWords.contains(word)
    }
    
    func isPossible(word: String) -> Bool {
        var tempWord = word
        
        for letter in word {
            if let pos = tempWord.firstIndex(of: letter) {
                tempWord.remove(at: pos)
            } else {
                return false
            }
        }
        
        return true
    }
    
    func isReal(word: String) -> Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let mispelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        
        return mispelledRange.location == NSNotFound
    }
    
    func isTooShort(word: String) -> Bool {
        return word.count > 3
    }
    
    func verifyAns(word: String) {
        guard word == rootWord else { return }
        
        if word.count > 0 && word.count < 3 {
            score += 10
        } else if word.count > 3 && word.count < 5 {
            score += 20
        } else if word.count > 5 {
            score += 50
        }
    }
    
    func wordError(title: String, message: String) {
        errorTitle = title
        errorMessage = message
        showingError = true
    }
    
}
