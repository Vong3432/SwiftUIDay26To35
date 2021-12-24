//
//  WordScrambleAppView.swift
//  SwiftUIDay26To35
//
//  Created by Vong Nyuksoon on 24/12/2021.
//

import SwiftUI

struct WordScrambleAppView: View {
    
    @StateObject private var vm: WordScrambleAppViewModel = WordScrambleAppViewModel()
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    TextField("Enter your word", text: $vm.newWord)
                        .textInputAutocapitalization(.never) // disable auto capitalise
                }
                
                Section {
                    HStack {
                        Text("Your score")
                        Spacer()
                        Text("\(vm.score)")
                            .fontWeight(.bold)
                    }
                }
                
                Section {
                    ForEach(vm.usedWords, id: \.self) { word in
                        HStack {
                            Image(systemName: "\(word.count).circle")
                            Text(word)
                        }
                    }
                }
            }
            .toolbar {
                ToolbarItemGroup {
                    Button("Restart") {
                        vm.startGame()
                    }
                }
            }
            .navigationTitle(vm.rootWord)
            .onSubmit {
                vm.addNewWord()
            }
            .onAppear(perform: vm.startGame)
            .alert(vm.errorTitle, isPresented: $vm.showingError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(vm.errorMessage)
            }
        }
    }

}

struct WordScrambleAppView_Previews: PreviewProvider {
    static var previews: some View {
        WordScrambleAppView()
    }
}
