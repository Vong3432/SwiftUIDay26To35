//
//  Project6ChallengeAppView.swift
//  SwiftUIDay26To35
//
//  Created by Vong Nyuksoon on 24/12/2021.
//

import SwiftUI

struct RoundedCorner: Shape {
    
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}

struct Project6ChallengeAppView: View {
    @StateObject private var vm = Project6ViewModel()
    
    private var border: some View {
        Capsule().stroke(lineWidth: 2).fill(.secondary)
    }
    
    private var columns: [GridItem] = Array(repeating: .init(.flexible()), count: 2)
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .top) {
                
                Color.green.opacity(0.8)
                    .frame(height: UIScreen.main.bounds.height * 0.4)
                    .cornerRadius(40, corners: [.bottomLeft, .bottomRight])
                    .ignoresSafeArea()
                
                VStack(alignment: .leading, spacing: 10) {
                    questionSnippetSection
                    
                    Spacer()
                    
                    HStack {
                        Text("Score")
                            .padding(.horizontal)
                        Spacer()
                        Text("\(vm.score)")
                            .fontWeight(.bold)
                            .foregroundColor(.green)
                    }
                    .padding()
                    .background(.white)
                    .cornerRadius(18)
                    .padding(.horizontal)
                    .shadow(color: .gray.opacity(0.15), radius: 20, x: 0, y: 30)
                    
                    Spacer()
                    
                    Text("Pick the correct answer")
                        .font(.title3)
                        .fontWeight(.bold)
                        .padding(.horizontal)
                    LazyVGrid(columns: columns, spacing: 0) {
                        ForEach(Array(vm.possibleAnswers), id: \.self) { ans in
                            Button {
                                vm.answer = ans
                                vm.checkAns()
                            } label: {
                                Text("\(ans)")
                                    .font(.title3)
                                    .fontWeight(.bold)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .padding()
                                    .foregroundColor( ans == vm.answer ? .white : .secondary)
                                    .background( ans == vm.answer ? .green : .white)
//                                    .animation(.spring(), value: vm.answer)
                                    .cornerRadius(18)
                                    .shadow(color: .gray.opacity(0.2), radius: 20, x: 0, y: 20)
                            }.padding(10)
                        }
                    }.padding()
                    
                    Spacer()
                    Spacer()
                }
                
            }
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Button("Done") {
                        // more
                        vm.checkAns()
                        
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to:nil, from:nil, for:nil)
                    }
                }
                
                ToolbarItem {
                    Button {
                        vm.showSheet.toggle()
                    } label: {
                        Image(systemName: "ellipsis.circle.fill")
                            .renderingMode(.original)
                            .resizable()
                            .foregroundColor(Color(red: 0, green: 0, blue: 0))
                            .frame(width: 32, height: 32)
                    }
                }
            }
            .onAppear {
                vm.generateQuestion()
            }
            .alert(vm.msg, isPresented: $vm.showMsg, actions: {
                Button("OK") {
                    vm.generateQuestion()
                }
            }, message: {
                Text(vm.desc)
            })
            .navigationBarTitleDisplayMode(.inline)
        }.sheet(isPresented: $vm.showSheet) {
            LazyVStack {
                multiplicationSection
                howManyQuestionSection
            }.padding()
            
            Spacer()
        }
    }
    
}

struct Project6ChallengeAppView_Previews: PreviewProvider {
    static var previews: some View {
        Project6ChallengeAppView()
            .previewInterfaceOrientation(.portrait)
    }
}

extension Project6ChallengeAppView {
    private var pickAnswerSection: some View {
        VStack {
            Button(
                action: {
                    
                }, label: {
                    Text("500")
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.white)
                        .padding()
                        .background(.green.opacity(1))
                        .cornerRadius(18)
                })
        }
    }
    
    private var questionSnippetSection: some View {
        ZStack(alignment: .top) {
            Color.white.opacity(0.3)
                .frame(maxWidth: .infinity, maxHeight: UIScreen.main.bounds.height * 0.2, alignment: .center)
                .cornerRadius(50)
                .padding()
                .offset(x: 0, y: 45)
            
            
            VStack(alignment: .center, spacing: 20) {
                Text(vm.currentQuestion == 0 ? "Finished" : "Q\(vm.currentQuestion)")
                    .font(.title)
                
                Text("\(vm.question?.question ?? "")")
                    .font(.system(size: 50))
                    .fontWeight(.bold)
            }
            .frame(maxWidth: .infinity, minHeight: UIScreen.main.bounds.height * 0.2, alignment: .center)
            .padding()
            .background(.regularMaterial)
            .cornerRadius(30)
            .shadow(color: .green, radius: 100, x: 4, y: 4)
            .padding()
        }
    }
    
    private var howManyQuestionSection: some View {
        VStack(alignment: .leading) {
            Text("How many questions?")
            HStack(spacing: 18) {
                ForEach(vm.questionCounts, id: \.self) { (idx) in
                    
                    Button(
                        action: {
                            vm.changeHowManyQuestion(max: idx)
                            vm.showSheet = false
                        }, label: {
                            Text("\(idx)")
                                .frame(maxWidth: .infinity)
                                .foregroundColor(vm.howManyQuestions == idx ? .white : .secondary)
                                .animation(nil, value: vm.howManyQuestions)
                                .padding()
                                .background(.green.opacity(vm.howManyQuestions == idx ? 1 : 0.1))
                                .cornerRadius(18)
                        })
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }.padding()
    }
    
    private var multiplicationSection: some View {
        VStack(alignment: .leading) {
            Text("Multiply by:")
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 16) {
                    ForEach(2..<13, id: \.self) { (idx) in
                        Circle()
                            .fill(.green.opacity(vm.multiplication == idx ? 1 : 0.1))
                            .frame(width: 50, height: 50)
                            .overlay {
                                Text("\(idx)")
                                    .font(.body)
                                    .bold()
                                    .foregroundColor(vm.multiplication == idx ? .white : .secondary)
                            }
                            .onTapGesture {
                                vm.changeMultiply(of: idx)
                                vm.showSheet = false
                            }
                    }
                }
                
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .background(.white)
            .clipShape(Capsule())
        }.padding()
    }
}
