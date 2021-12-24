//
//  WordScrambleLearningAppView.swift
//  SwiftUIDay26To35
//
//  Created by Vong Nyuksoon on 24/12/2021.
//

import SwiftUI

/*
 String
 ------------
 let input = "a b c"
 let letters = input.components(separatedBy: " ")
 
 let input = """
             a
             b
             c
             """
 let letters = input.components(separatedBy: "\n")
 let letter = letters.randomElement()
 let trimmed = letter?.trimmingCharacters(in: .whitespacesAndNewlines)
*/

struct WordScrambleLearningAppView: View {
    
    // Check mispelled words
    private var word = "swift"
    private var checker = UITextChecker()
    private var range: NSRange {
        // UTF-16 is what’s called a character encoding – a way of storing letters in a string. We use it here so that Objective-C can understand how Swift’s strings are stored; it’s a nice bridging format for us to connect the two.
        NSRange(location: 0, length: word.utf16.count)
    }
    
    private var mispelledRange: NSRange {
        // wrap: true to continue checking from the beginning of range if no misspelled word is found between startingOffset and the end of range. Specify false to have spell-checking end at the end of range.
        checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
    }
    
    private var allGood: Bool {
        mispelledRange.location == NSNotFound
    }
    
    var body: some View {
        List {
            Section("Header") {
                Text("Static row")
                Text("Static row")
            }
            
            Section("Dynamic") {
                ForEach(0..<5) {
                    Text("Dynamic row #\($0)")
                }
            }
            
            Section("Footer") {
                Text("Static row")
                Text("Static row")
                Text("Static row")
            }
            
            // load resource
            if let fileUrl = Bundle.main.url(forResource: "some-file", withExtension: "txt") {
                if let fileContent = try? String(contentsOf: fileUrl) {
                    // load fileContent if file exist
                    Text("File \"some-file.txt\" exist! \(fileContent)")
                }
            }
            
        }.listStyle(.grouped)
    }
}

struct WordScrambleLearningAppView_Previews: PreviewProvider {
    static var previews: some View {
        WordScrambleLearningAppView()
    }
}
