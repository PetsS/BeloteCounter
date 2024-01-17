//
//  AddPartyView.swift
//  BeloteCounter
//
//  Created by Peter Szots on 07/07/2022.
//

import SwiftUI

struct AddView: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.dismiss) var dismiss
    
    @State private var player1 = ""
    @State private var player2 = ""
    @State private var player3 = ""
    @State private var player4 = ""
    @State private var score = 1000
//    @State private var scoreTeamB = 0
    @State private var date = Date.now
    @State private var teamA = "Nous"
    @State private var teamB = "Eux"
    
    var hasValidEntry: Bool { // checks if the properties are empty and this bool will be added to the desabled modifier
        if player1.isEmpty || player2.isEmpty || player3.isEmpty || player4.isEmpty {
            return false
        }
        return true
    }
    
    let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()
    
    var body: some View {
        NavigationView {
            Form {
                TextField("TeamA name", text: $teamA)
                    .onChange(of: teamA) { newValue in  //this limits the number of characters entered into TextField
                        teamA = String(newValue.prefix(8))
                    }
                Section("Team A (\(teamA))") {
                    TextField("Player 1", text: $player1)
                        .onChange(of: player1) { newValue in
                            player1 = String(newValue.prefix(8))
                        }
                    TextField("Player 2", text: $player2)
                        .onChange(of: player2) { newValue in
                            player2 = String(newValue.prefix(8))
                        }
                }
                TextField("TeamB name", text: $teamB)
                    .onChange(of: teamB) { newValue in
                        teamB = String(newValue.prefix(8))
                    }
                Section("Team B (\(teamB))") {
                    TextField("Player 3", text: $player3)
                        .onChange(of: player3) { newValue in
                            player3 = String(newValue.prefix(8))
                        }
                    TextField("Player 4", text: $player4)
//                        .onReceive(player4.publisher.collect()) {
//                            player4 = String($0.prefix(8))
//                        }
                        .onChange(of: player4) { newValue in
                            player4 = String(newValue.prefix(8))
                        }
                }
                Section("Set maximum SCORE") {
                    HStack {
//                        Text("Maximum score: ")
                        TextField("", value: $score, formatter: formatter)
                    }
                    
                }
                
                Section {
                    Button("Save") {
                        let newParty = Belote(context: moc)
                        newParty.id = UUID()
                        newParty.player1 = player1
                        newParty.player2 = player2
                        newParty.player3 = player3
                        newParty.player4 = player4
                        newParty.score = Int16(score)
//                        newParty.scoreTeamA = Int16(scoreTeamA)
//                        newParty.scoreTeamB = Int16(scoreTeamB)
                        newParty.date = date
                        newParty.teamA = teamA
                        newParty.teamB = teamB
                        
                        
                        if moc.hasChanges {
                            try? moc.save()
                        }
                        dismiss()
                    }
                    .disabled(hasValidEntry == false)
                }
            }
            .navigationTitle("Add Party")
            .onAppear { UIApplication.shared.isIdleTimerDisabled = true }
        }
    }
}

struct AddPartyView_Previews: PreviewProvider {
    static var previews: some View {
        AddView()
    }
}
