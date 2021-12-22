//
//  BetterRestAppView.swift
//  SwiftUIDay26To35
//
//  Created by Vong Nyuksoon on 22/12/2021.
//
import CoreML
import SwiftUI


struct BetterRestAppView: View {
    
    private static var defaultWakeUpTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date.now
    }
    
    private var idealBedTime: Date {
        do {
            let config = MLModelConfiguration()
            let model = try SleepCalulator(configuration: config)
            
            let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
            
            // convert hour and minute to seconds because the data in .csv file is seconds unit, hence need to convert wakeUp (hours, minute) to seconds.
            let hourInSeconds = (components.hour ?? 0) * 60 * 60
            let minuteInSeconds = (components.minute ?? 0) * 60
            
            let prediction = try model.prediction(
                wake: Double(hourInSeconds + minuteInSeconds),
                estimatedSleep: sleepAmount,
                coffee: Double(coffeeAmount + 1)
            )
            
            let sleepTime = wakeUp - prediction.actualSleep
            
            return sleepTime
        } catch {
            return Date.now
        }
    }
    
    @State private var sleepAmount = 8.0
    @State private var wakeUp = defaultWakeUpTime
    @State private var coffeeAmount = 1
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    HStack(spacing: 18) {
                        Image(systemName: "bed.double")
                            .resizable()
                            .frame(width: 32, height: 32)
                            .foregroundStyle(.teal)
                        
                        Text(idealBedTime.formatted(date: .omitted, time: .shortened))
                            .font(.title2)
                            .fontWeight(.heavy)
                        
                    }.padding(.vertical)
                        .padding(.horizontal, 8)
                } header: {
                    Text("Your ideal bedtime")
                        .font(.subheadline)
                }
                
                Section {
                    DatePicker(
                        "Select time",
                        selection: $wakeUp,
                        displayedComponents: .hourAndMinute
                    )
                } header: {
                    Text("When do you want to wake up?")
                        .font(.subheadline)
                }
                
                Section {
                    Stepper(
                        "\(sleepAmount.formatted()) hours",
                        value: $sleepAmount, in: 4...12
                    )
                } header: {
                    Text("Desired amount of sleep")
                        .font(.subheadline)
                }
                
                Section {
                    Picker(
                        (coffeeAmount + 1) == 1 ? "1 cup" : "\(coffeeAmount + 1) cups",
                        selection: $coffeeAmount) {
                            ForEach(1..<21) {
                                Text( $0 == 1 ? "1 cup" : "\($0) cups")
                            }
                        }
                } header: {
                    Text("Daily coffee intake")
                        .font(.subheadline)
                }
                
            }
            .navigationTitle("BetterRest")
        }
    }
    
}

struct BetterRestAppView_Previews: PreviewProvider {
    static var previews: some View {
        BetterRestAppView()
    }
}


