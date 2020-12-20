//
//  ContentView.swift
//  BetterRest
//
//  Created by Nicolas Papegaey on 19/12/2020.
//

import SwiftUI

struct ContentView: View {
    
    @State private var wakeUp = defaultWakeTime
    @State private var sleepAmount = 8.0
    @State private var coffeeAmount = 1
    
    
    static var defaultWakeTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date()
    }
    
    
    private var idealBedtime: String {
        let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
        let hour = (components.hour ?? 0) * 60 * 60
        let minute = (components.minute ?? 0) * 60
        let model = SleepCalculator()
        var bedTime = ""
        
        
        do {
            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
            let sleepTime = wakeUp - prediction.actualSleep
            
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            
            bedTime = formatter.string(from: sleepTime)
        } catch {
            bedTime = "Désolé, un problème est survenu durant le calcul de l'heure de coucher."
        }
        return bedTime
    }

    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("A quelle heure voulez-vous vous reveiller ?").font(.subheadline)) {
                    DatePicker("Please enter a time", selection: $wakeUp, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                        .datePickerStyle(WheelDatePickerStyle())
                }
                
                Section(header: Text("Combien de temps souhaitez-vous dormir ?").font(.subheadline)) {
                    Stepper(value: $sleepAmount, in: 4...12, step: 0.25){
                        Text("\(sleepAmount, specifier: "%g") heures")
                    }
                }
                
                Section(header: Text("Tasse(s) de café bu(s) dans la journée").font(.subheadline)) {
                    Stepper(value: $coffeeAmount, in: 1...20) {
                        let libelle = coffeeAmount==1 ? "tasse" : "tasses"
                        Text("\(coffeeAmount)" + " " + libelle)
                    }
                }
                
                Section(header: Text("Votre heure de couché idéale est...").font(.subheadline)) {
                     Text(idealBedtime)
                        .font(.largeTitle)
                        .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                }
            }
            .navigationBarTitle("Bien Reposé")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
