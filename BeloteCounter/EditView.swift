//
//  EditView.swift
//  BeloteCounter
//
//  Created by Peter Szots on 10/08/2022.
//

import SwiftUI

struct EditView: View {
    let belote: Belote
    
    @Environment(\.managedObjectContext) var moc
    @Environment(\.dismiss) var dismiss
    
    @State private var player1 = ""
    @State private var player2 = ""
    @State private var player3 = ""
    @State private var player4 = ""
    
    @State private var showAlert = false
    
    var body: some View {
        NavigationView {
            List {
                Section(belote.teamA ?? "TeamA") {
                    HStack {
                        TextField(belote.player1 ?? "player1", text: $player1)
                            .onChange(of: player1) { newValue in
                                player1 = String(newValue.prefix(8))
                                belote.player1 = player1
                            }
                        Button ("Distributeur") {
                            belote.number = 0
                            if moc.hasChanges {
                                try? moc.save()
                            }
                            dismiss()
                        }
                    }
                    HStack {
                        TextField(belote.player2 ?? "player2", text: $player2)
                            .onChange(of: player2) { newValue in
                                player2 = String(newValue.prefix(8))
                                belote.player2 = player2
                            }
                        Button ("Distributeur") {
                            belote.number = 2
                            if moc.hasChanges {
                                try? moc.save()
                            }
                            dismiss()
                        }
                    }
                }
                Section(belote.teamB ?? "TeamB") {
                    HStack {
                        TextField(belote.player3 ?? "player 3", text: $player3)
                            .onChange(of: player3) { newValue in
                                player3 = String(newValue.prefix(8))
                                belote.player3 = player3
                            }
                        Button ("Distributeur") {
                            belote.number = 1
                            if moc.hasChanges {
                                try? moc.save()
                            }
                            dismiss()
                        }
                    }
                    HStack {
                        TextField(belote.player4 ?? "player 4", text: $player4)
                            .onChange(of: player4) { newValue in
                                player4 = String(newValue.prefix(8))
                                belote.player4 = player4
                            }
                        Button ("Distributeur") {
                            belote.number = 3
                            if moc.hasChanges {
                                try? moc.save()
                            }
                            dismiss()
                        }
                    }
                }
                
                Section {
                    Button("Reset Score") {
                        showAlert = true
                    }
                    .alert("Reset Score?", isPresented: $showAlert) {
                        Button("Ok") {
                            belote.scoreTeamA = 0
                            belote.scoreTeamB = 0
                            if moc.hasChanges {
                                try? moc.save()
                            }
                            dismiss()
                        }
                        Button("Cancel", role: .cancel) { }
                    }
                }
                
                Section {
                    Button("Save") {
                        if moc.hasChanges {
                            try? moc.save()
                        }
                        dismiss()
                    }
                    Button("Cancel") {                        
                        dismiss()
                    }
                }
            }
            .navigationTitle("Modifier les joueurs")
            .onAppear { UIApplication.shared.isIdleTimerDisabled = true }
        }
    }
    
    func changePlayerNumber() {
        if belote.number == 3 {
            belote.number = 0
        } else {
            belote.number += 1
        }
    }
    
    func playerOrder(number: Int16) -> String {
        var players = ""
        
        switch number {
        case 0:
            players = belote.player1 ?? "player1"
        case 1:
            players = belote.player3 ?? "player2"
        case 2:
            players = belote.player2 ?? "player3"
        default:
            players = belote.player4 ?? "player4"
        }
          
        return players
    }
}

//struct EditView_Previews: PreviewProvider {
//    static var previews: some View {
//        EditView()
//    }
//}
