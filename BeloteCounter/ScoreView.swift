//
//  ScoringView.swift
//  BeloteCounter
//
//  Created by Peter Szots on 07/07/2022.
//

import SwiftUI

struct ScoreView: View {
    let belote: Belote
    
    @Environment(\.managedObjectContext) var moc
    @Environment(\.dismiss) var dismiss
    
    @State private var score = 0
    @State private var contract = 82
    @State private var teamA = false
    @State private var teamB = false
 
    @State private var isGotBelote = false
    @State private var isTeamABelote = false
    @State private var isTeamBBelote = false
    @State private var isLastRound = false
    @State private var isCapot = false
    
    @State private var scaleA = 1.0
    @State private var scaleB = 1.0
    
    @FocusState private var amountIsFocused: Bool
    
    var hasValidEntry: Bool {
        if teamA == false && teamB == false {
            return false
        }
        if (score > 162) && (score != 252) {
            return false
        }
        if isGotBelote == true {
            if isTeamABelote == false && isTeamBBelote == false {
                return false
            }
        }
        return true
    }
    
    let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()
    
    var body: some View {
        VStack {
            Text("Qui a demandé un contrat?")
            HStack {
                Button {
                    teamA.toggle()
                    teamB = false
                    withAnimation(.easeOut) {
                        if teamA == true {
                            scaleA = 1.2
                            scaleB = 1.0
                        } else {
                            scaleA = 1.0
                        }
                    }
                } label: {
                    Text(belote.teamA ?? "Nous")
                }
                .foregroundColor(teamA ? Color.blue : Color.black)
                .font(.title)
                .padding(13)
                .background(teamA ? .blue.opacity(0.2) : .white)
                .border(Color.blue, width: teamA ? 5 : 2)
                .padding(.horizontal, 10)
                .scaleEffect(scaleA)
                
                Button {
                    teamB.toggle()
                    teamA = false
                    withAnimation(.easeOut) {
                        if teamB == true {
                            scaleB = 1.2
                            scaleA = 1.0
                        } else {
                            scaleB = 1.0
                        }
                    }
                } label: {
                    Text(belote.teamB ?? "Eux")
                }
                .foregroundColor(teamB ? Color.red : Color.black)
                .font(.title)
                .padding(13)
                .background(teamB ? .red.opacity(0.2) : .white)
                .border(Color.red, width: teamB ? 5 : 2)
                .padding(.horizontal, 10)
                .scaleEffect(scaleB)
            }
            .padding(20)
            
            HStack {
                TextField("Score", value: $score, formatter: formatter)
                    .font(.largeTitle)
                    .textFieldStyle(.roundedBorder)
                    .keyboardType(.decimalPad)
                    .submitLabel(.next)
                    .focused($amountIsFocused)
//                    .toolbar {
//                        ToolbarItemGroup(placement: .keyboard) {
//                            Button("Done") {
//                                amountIsFocused = false
//                            }
//                        }
//                    }
                    
                Button {
                    amountIsFocused = false
                } label: {
                    Image(systemName: "checkmark.circle")
                        .font(.largeTitle)
                }
            }
            .padding(.horizontal, 60)
            
                       
            Text("Floating score: \(belote.scoreEqual ? (81 + score) : score)")
                .padding(10)
                .font(.footnote)
            
            VStack {
                Toggle("Capote?", isOn: $isCapot)
                Divider()
                Toggle("BELOTE?", isOn: $isGotBelote)
                    .disabled(isCapot == true)
                
                HStack {
                    Toggle(belote.teamA ?? "Nous", isOn: $isTeamABelote)
                        .foregroundColor(isTeamABelote ? Color.primary : Color.primary.opacity(0.4))
                        .disabled(isTeamBBelote == true)
                    Toggle(belote.teamB ?? "Eux", isOn: $isTeamBBelote)
                        .foregroundColor(isTeamBBelote ? Color.primary : Color.primary.opacity(0.4))
                        .disabled(isTeamABelote == true)
                }
                .disabled(isGotBelote == false || isCapot == true)
                
                Divider()
                
                Toggle("10 de der?", isOn: $isLastRound)
                    .disabled(isCapot == true)
            }
            .padding(20)
            
            VStack {
                Button("Nouveau Tour") {
                    changePlayerNumber()
                    if moc.hasChanges {
                        try? moc.save()
                    }
                    dismiss()
                }
            }
            .padding(.horizontal, 20)
            
            HStack {
                Button("OK") {
                    changePlayerNumber()
                    
                    if teamA == true {
                        if isCapot == true {
                            belote.scoreTeamA += 252
                        } else {
                            if isGotBelote == true {
                                contract = 92
                                if isTeamABelote == true {
                                    if score < contract {
                                            belote.scoreTeamA += 20
                                    } else {
                                        score += 20
                                    }
                                }
                            }
                            if isLastRound == true {
                                score += 10
                            }
                            if score >= contract {
                                if belote.scoreEqual == true {
                                    belote.scoreEqual = false
                                    belote.scoreTeamA += Int16(score + 81)
                                    belote.scoreTeamB += Int16(162 - score)
                                } else {
                                    belote.scoreTeamA += Int16(score)
                                    belote.scoreTeamB += Int16(162 - score)
                                }
                            } else if score == 81 {
                                belote.scoreEqual = true
                            } else if score == 252 {
                                belote.scoreTeamA += 252
                            } else {
                                belote.scoreTeamB += 162
                            }
                        }
                    } else if teamB == true {
                        if isCapot == true {
                            belote.scoreTeamB += 252
                        } else {
                            if isGotBelote == true {
                                contract = 92
                                if isTeamBBelote == true {
                                    if score < contract {
                                            belote.scoreTeamB += 20
                                    } else {
                                        score += 20
                                    }
                                }
                            }
                            if isLastRound == true {
                                score += 10
                            }
                            if score >= contract {
                                if belote.scoreEqual == true {
                                    belote.scoreEqual = false
                                    belote.scoreTeamB += Int16(score + 81)
                                    belote.scoreTeamA += Int16(162 - score)
                                } else {
                                    belote.scoreTeamB += Int16(score)
                                    belote.scoreTeamA += Int16(162 - score)
                                }
                            } else if score == 81 {
                                belote.scoreEqual = true
                            } else if score == 252 {
                                belote.scoreTeamB += 252
                            } else {
                                belote.scoreTeamA += 162
                            }
                        }
                    }
                    
                    if moc.hasChanges {
                        try? moc.save()
                    }
                    dismiss()
                }
                .disabled(hasValidEntry == false)
                .padding(.horizontal, 10)
                
                
                Button("Cancel") {
                    dismiss()
                }
                .padding(.horizontal, 10)
            }
            .frame(maxWidth: .infinity, maxHeight: 100)
            .padding(20)
            
        }
        .padding(20)

        Spacer()
    }
    
    func changePlayerNumber() {
        if belote.number == 3 {
            belote.number = 0
        } else {
            belote.number += 1
        }
    }
}

//struct ScoringView_Previews: PreviewProvider {
//    static var previews: some View {
//        ScoreView()
//    }
//}
