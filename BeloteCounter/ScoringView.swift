//
//  ScoringView.swift
//  BeloteCounter
//
//  Created by Peter Szots on 11/08/2022.
//

import SwiftUI

struct ScoringView: View {
    let belote: Belote
    
    @Environment(\.managedObjectContext) var moc
    @Environment(\.dismiss) var dismiss
    
    @State private var scoreTeamA = 0
    @State private var scoreTeamB = 0
    @State private var contract = 82
    
    @State private var teamA = false
    @State private var teamB = false
    @State private var isCapotA = false
    @State private var isCapotB = false
    @State private var isBeloteA = false
    @State private var isBeloteB = false
    @State private var isLastRoundA = false
    @State private var isLastRoundB = false
    
    @FocusState private var amountIsFocused: Bool
    
    var scoringA: Int {
        var scoreA: Int
        scoreA = 162 - scoreTeamB
        return scoreA
    }
    
    let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()
    
    var body: some View {
        ScrollView {
            HStack {
                VStack {
                    Text(belote.teamA ?? "teamA")
                        .font(.title)
                        .foregroundColor(.blue)
                    Text("\(belote.player1 ?? "player1"), \(belote.player2 ?? "player2")")
                        .font(.caption)
                    Rectangle()
                        .frame(height: 1, alignment: .center)
                        .opacity(0.3)
                    
                    Text("\(belote.scoreTeamA)")
                    
                    HStack {
                        TextField("", value: $scoreTeamA, formatter: formatter)
                            .font(.largeTitle)
                            .textFieldStyle(.roundedBorder)
                            .keyboardType(.decimalPad)
//                            .submitLabel(.next)
                            .focused($amountIsFocused)
//                            .toolbar {
//                                ToolbarItemGroup(placement: .keyboard) {
//                                    Button("Done") {
//                                        amountIsFocused = false
//                                    }
//                                }
//                            }
                            
                        Button("OK") {
                            amountIsFocused = false
                            scoreTeamB = 162 - scoreTeamA
                        }
                    }
                    .padding(15)
                    
                    Button("Capote") {
                        isCapotA.toggle()
                        withAnimation(.easeOut) {
                            if isCapotA == true {
                                scoreTeamA += 252
                            } else {
                                scoreTeamA -= 252
                            }
                        }
                    }
                    .foregroundColor(isCapotA ? Color.blue : (isCapotB || isBeloteA || isBeloteB || isLastRoundA || isLastRoundB ? Color.black.opacity(0.4) : Color.black))
                    .font(.title3)
                    .frame(maxWidth: 85, maxHeight: .infinity)
                    .padding(10)
                    .background(isCapotA ? .blue.opacity(0.2) : .white)
                    .border(isCapotA ? Color.blue : (isCapotB || isBeloteA || isBeloteB || isLastRoundA || isLastRoundB ? Color.blue.opacity(0.4) : Color.blue), width: isCapotA ? 5 : 2)
                    .disabled(isCapotB || isBeloteB || isBeloteA || isLastRoundB || isLastRoundA)
                    
                    Button("Belote") {
                        isBeloteA.toggle()
                        withAnimation(.easeOut) {
                            if isBeloteA == true {
                                scoreTeamA += 20
                            } else {
                                scoreTeamA -= 20
                            }
                        }
                    }
                    .foregroundColor(isBeloteA ? Color.blue : (isBeloteB || isCapotB ? Color.black.opacity(0.4) : Color.black))
                    .font(.title3)
                    .frame(maxWidth: 85, maxHeight: .infinity)
                    .padding(10)
                    .background(isBeloteA ? .blue.opacity(0.2) : .white)
                    .border(isBeloteA ? Color.blue : (isBeloteB || isCapotB ? Color.blue.opacity(0.4) : Color.blue), width: isBeloteA ? 5 : 2)
                    .disabled(isBeloteB || isCapotB)
                    
                    Button("10 de der") {
                        isLastRoundA.toggle()
                        withAnimation(.easeOut) {
                            if isLastRoundA == true {
                                scoreTeamA += 10
                            } else {
                                scoreTeamA -= 10
                            }
                        }
                    }
                    .foregroundColor(isLastRoundA ? Color.blue : (isLastRoundB || isCapotB || isCapotA ? Color.black.opacity(0.4) : Color.black))
                    .font(.title3)
                    .frame(maxWidth: 85, maxHeight: .infinity)
                    .padding(10)
                    .background(isLastRoundA ? .blue.opacity(0.2) : .white)
                    .border(isLastRoundA ? Color.blue : (isLastRoundB || isCapotB || isCapotA ? Color.blue.opacity(0.4) : Color.blue), width: isLastRoundA ? 5 : 2)
                    .disabled(isLastRoundB || isCapotB || isCapotA)
                    
                    Button {
                        scoreTeamA = 0
                        isCapotA = false
                        isBeloteA = false
                        isLastRoundA = false
                    }label:{
                        Image(systemName: "trash")
                    }
                    .font(.title2)
                    .foregroundColor(.blue)
                    .padding(15)
                }
                
                Rectangle()
                    .frame(width: 1, alignment: .center)
                    .opacity(0.3)
                
                VStack {
                    Text(belote.teamB ?? "teamB")
                        .font(.title)
                        .foregroundColor(.red)
                    Text("\(belote.player3 ?? "player3"), \(belote.player4 ?? "player4")")
                        .font(.caption)
                    Rectangle()
                        .frame(height: 1, alignment: .center)
                        .opacity(0.3)
                    
                    Text("\(belote.scoreTeamB)")
                    
                    HStack {
                        TextField("", value: $scoreTeamB, formatter: formatter)
                            .font(.largeTitle)
                            .textFieldStyle(.roundedBorder)
                            .keyboardType(.decimalPad)
//                            .submitLabel(.next)
                            .focused($amountIsFocused)
//                            .toolbar {
//                                ToolbarItemGroup(placement: .keyboard) {
//                                    Button("Done") {
//                                        amountIsFocused = false
//                                    }
//                                }
//                            }
                            
                        Button("OK") {
                            amountIsFocused = false
                            scoreTeamA = 162 - scoreTeamB
                        }
                    }
                    .padding(15)
                    
                    Button("Capote") {
                        isCapotB.toggle()
                        withAnimation(.easeOut) {
                            if isCapotB == true {
                                scoreTeamB += 252
                            } else {
                                scoreTeamB -= 252
                            }
                        }
                    }
                    .foregroundColor(isCapotB ? Color.red : (isCapotA || isBeloteA || isBeloteB || isLastRoundA || isLastRoundB ? Color.black.opacity(0.4) : Color.black))
                    .font(.title3)
                    .frame(maxWidth: 85, maxHeight: .infinity)
                    .padding(10)
                    .background(isCapotB ? .red.opacity(0.2) : .white)
                    .border(isCapotB ? Color.red : (isCapotA || isBeloteA || isBeloteB || isLastRoundA || isLastRoundB ? Color.red.opacity(0.4) : Color.red), width: isCapotB ? 5 : 2)
                    .disabled(isCapotA || isBeloteB || isBeloteA || isLastRoundB || isLastRoundA)
                    
                    Button("Belote") {
                        isBeloteB.toggle()
                        withAnimation(.easeOut) {
                            if isBeloteB == true {
                                scoreTeamB += 20
                            } else {
                                scoreTeamB -= 20
                            }
                        }
                    }
                    .foregroundColor(isBeloteB ? Color.red : (isBeloteA || isCapotA ? Color.black.opacity(0.4) : Color.black))
                    .font(.title3)
                    .frame(maxWidth: 85, maxHeight: .infinity)
                    .padding(10)
                    .background(isBeloteB ? .red.opacity(0.2) : .white)
                    .border(isBeloteB ? Color.red : (isBeloteA || isCapotA ? Color.red.opacity(0.4) : Color.red), width: isBeloteB ? 5 : 2)
                    .disabled(isBeloteA || isCapotA)
                    
                    Button("10 de der") {
                        isLastRoundB.toggle()
                        withAnimation(.easeOut) {
                            if isLastRoundB == true {
                                scoreTeamB += 10
                            } else {
                                scoreTeamB -= 10
                            }
                        }
                    }
                    .foregroundColor(isLastRoundB ? Color.red : (isLastRoundA || isCapotA || isCapotB ? Color.black.opacity(0.4) : Color.black))
                    .font(.title3)
                    .frame(maxWidth: 85, maxHeight: .infinity)
                    .padding(10)
                    .background(isLastRoundB ? .red.opacity(0.2) : .white)
                    .border(isLastRoundB ? Color.red : (isLastRoundA || isCapotA || isCapotB ? Color.red.opacity(0.4) : Color.red), width: isLastRoundB ? 5 : 2)
                    .disabled(isLastRoundA || isCapotA || isCapotB)
                    
                    Button {
                        scoreTeamB = 0
                        isCapotB = false
                        isBeloteB = false
                        isLastRoundB = false
                    }label:{
                        Image(systemName: "trash")
                    }
                    .font(.title2)
                    .foregroundColor(.red)
                    .padding(15)
                }
            }
            .padding()
            
            HStack {
                Button("Done") {
                    changePlayerNumber()
                    
                    belote.scoreTeamA += Int16(scoreTeamA)
                    belote.scoreTeamB += Int16(scoreTeamB)
                    
                    if moc.hasChanges {
                        try? moc.save()
                    }
                    dismiss()
                }
                .padding(.horizontal, 10)
                
                Button("Cancel") {
                    dismiss()
                }
                .padding(.horizontal, 10)
            }
            .frame(maxWidth: .infinity, maxHeight: 100)
            .padding(20)
            
            HStack{
                Text("Speaker: ")
                Text(playerOrder(number: (belote.number + 1)))
                    .font(.title3.bold())
            }
            .font(.title3)
            .padding(10)
            .border(.black, width: 2)
            Spacer()
        }
        .onAppear { UIApplication.shared.isIdleTimerDisabled = true }
    }
    
    func changePlayerNumber() {
        if belote.number >= 3 {
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
        case 3:
            players = belote.player4 ?? "player4"
        default:
            players = belote.player1 ?? "player1"
        }
          
        return players
    }
}

//struct ScoringView_Previews: PreviewProvider {
//    static var previews: some View {
//        ScoringView()
//    }
//}
