//
//  ContentView.swift
//  BeloteCounter
//
//  Created by Peter Szots on 07/07/2022.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: []) var belotes: FetchedResults<Belote>
    
    @State private var showingAddScreen = false
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .short
        return formatter
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(belotes) { belote in
                    NavigationLink {
                        DetailView(belote: belote)
                    } label: {
                        HStack {
                            VStack(alignment: .leading) {
                                Text(belote.date ?? Date.now, formatter: dateFormatter)
                                Text("\(belote.teamA ?? "Nous") (\(belote.player1 ?? "player1") and \(belote.player2 ?? "player2")) scored \(belote.scoreTeamA) points")
                                    .font(.caption)
                                Text("\(belote.teamB ?? "Eux") (\(belote.player3 ?? "player3") and \(belote.player4 ?? "player4")) scored \(belote.scoreTeamB) points")
                                    .font(.caption)
                            }
                        }
                    }
                    .listRowBackground(belote.scoreTeamA > belote.scoreTeamB ? Color.blue.opacity(0.2) : Color.red.opacity(0.2))
                }
                .onDelete(perform: deleteEntry)
            }
            .navigationTitle("Belote Counter")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingAddScreen.toggle()
                        
                    } label: {
                        Label("Add Party", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddScreen) {
                AddView()
            }
        }
        .preferredColorScheme(.light)
        .onAppear { UIApplication.shared.isIdleTimerDisabled = true }
    }
    
    func deleteEntry (at offsets: IndexSet) {
        for offset in offsets {
            let entry = belotes[offset]
            moc.delete(entry)
        }
        
        try? moc.save()
    }
}


//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
