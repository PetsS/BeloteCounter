//
//  DetailView.swift
//  BeloteCounter
//
//  Created by Peter Szots on 07/07/2022.
//

import SwiftUI

struct DetailView: View {
    let belote: Belote
    
    @Environment(\.managedObjectContext) var moc
    @Environment(\.dismiss) var dismiss
    
    @State private var showingAddScreen = false
    @State private var showingAddScreenEditView = false
    
    @State private var selectedPlayer = 0
    
    var body: some View {
        ScrollView {
            VStack (alignment: .center, spacing: 10){
                Text("Score")
            }
            HStack {
                VStack {
                    Text("\(belote.teamA ?? "Nous")")
                        .font(.title)
                    Text("\(belote.player1 ?? "player1"), \(belote.player2 ?? "player2")")
                        .font(.caption)
                    Rectangle()
                        .frame(height: 1, alignment: .center)
                    Text("\(belote.scoreTeamA)")
                        .font(.largeTitle)
                        .padding(.vertical, 20)
                }
                .padding(10)
                .border(.black, width: 1)
                .background(.blue.opacity(0.1))
                Spacer()
                VStack {
                    Text("\(belote.teamB ?? "Eux") ")
                        .font(.title)
                    Text("\(belote.player3 ?? "player3"), \(belote.player4 ?? "player4")")
                        .font(.caption)
                    Rectangle()
                        .frame(height: 1, alignment: .center)
                    Text("\(belote.scoreTeamB)")
                        .font(.largeTitle)
                        .padding(.vertical, 20)
                }
                .padding(10)
                .border(.black, width: 1)
                .background(.red.opacity(0.1))
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.horizontal, 20)
            
            Text(endOfParty() ? "The game will end at \(belote.score) points." : declareWinner())
                .padding()
                .font(.body)
            Button {
                showingAddScreen.toggle()
            } label: {
                Image(systemName: endOfParty() ? "plus.circle.fill" : "x.circle")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(endOfParty() ? Color.black : Color.black.opacity(0.5))
                    .frame(width:60, height:60)
                    .shadow(radius: 1)
            }
            .disabled(endOfParty() == false)
            .padding(20)
            .sheet(isPresented: $showingAddScreen) {
                ScoringView(belote: belote)
            }
            
            Text(endOfParty() ? "DISTRIBUTEUR" : "")
                .padding(10)
                .font(.title2)
            Text(endOfParty() ? playerOrder(number: belote.number) : "Game Over")
                .font(.largeTitle.bold())
                .padding(10)
                .border(.black, width: 2)
            Spacer()
            
//            Picker("Joueur", selection: $selectedPlayer) {
//                ForEach(0..<4, id: \.self) { number in
//                    switch number {
//                    case 0:
//                        Text(belote.player1 ?? "player1")
//                    case 1:
//                        Text(belote.player3 ?? "player3")
//                    case 2:
//                        Text(belote.player2 ?? "player2")
//                    default:
//                        Text(belote.player4 ?? "player4")
//                    }
//                }
//            }
            
            
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingAddScreenEditView.toggle()
                    }label:{
                        Image(systemName: "square.and.pencil")
                    }
                }
            }
            .sheet(isPresented: $showingAddScreenEditView) {
                EditView(belote: belote)
            }
            .onAppear { UIApplication.shared.isIdleTimerDisabled = true }
        }
    }
    
    func endOfParty() -> Bool {
        if (belote.scoreTeamA >= belote.score) || (belote.scoreTeamB >= belote.score) {
            return false
        }
        return true
    }
    
    func declareWinner() -> String {
        var winner = ""
        if belote.scoreTeamA >= belote.score {
            winner = "The WINNER is \(belote.teamA ?? "Nous") (\(belote.player1 ?? "player1"), \(belote.player2 ?? "player2")) with \(belote.scoreTeamA) points."
        } else if belote.scoreTeamB >= belote.score {
            winner = "The WINNER is \(belote.teamB ?? "Eux") (\(belote.player3 ?? "player3"), \(belote.player4 ?? "player4")) with \(belote.scoreTeamB) points."
        }
        return winner
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

//struct DetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        DetailView()
//    }
//}
