//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Y K on 28.04.2023.
//

import SwiftUI



struct ContentView: View {
    private static let numberOfFlags = 3
    @State private var questionCounter = 1
    
    @State private var Score = 0
    
    @State private var showingScore = false
    @State private var showingResults = false
    @State private var scoreTitle = ""
    
    @State private var countries = allCountries.shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    
    static let allCountries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"]
    
    let labels = [
        "Estonia": "Flag with three horizontal stripes of equal size. Top stripe blue, middle stripe black, bottom stripe white",
        "France": "Flag with three vertical stripes of equal size. Left stripe blue, middle stripe white, right stripe red",
        "Germany": "Flag with three horizontal stripes of equal size. Top stripe black, middle stripe red, bottom stripe gold",
        "Ireland": "Flag with three vertical stripes of equal size. Left stripe green, middle stripe white, right stripe orange",
        "Italy": "Flag with three vertical stripes of equal size. Left stripe green, middle stripe white, right stripe red",
        "Nigeria": "Flag with three vertical stripes of equal size. Left stripe green, middle stripe white, right stripe green",
        "Poland": "Flag with two horizontal stripes of equal size. Top stripe white, bottom stripe red",
        "Russia": "Flag with three horizontal stripes of equal size. Top stripe white, middle stripe blue, bottom stripe red",
        "Spain": "Flag with three horizontal stripes. Top thin stripe red, middle thick stripe gold with a crest on the left, bottom thin stripe red",
        "UK": "Flag with overlapping red and white crosses, both straight and diagonally, on a blue background",
        "US": "Flag with red and white stripes of equal size, with white stars on a blue background in the top-left corner"
    ]
    
    @State private var rotationAmount = [Double](repeating: 0.0, count: numberOfFlags)
    @State private var opacityAmount = [Double](repeating: 1.0, count: numberOfFlags)
    @State private var scaleAmount = [Double](repeating: 1.0, count: numberOfFlags)
    
    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.4), location: 0.3),
                .init(color: Color(red: 0.8, green: 0.1, blue: 0.2), location: 0.3)
            ], center: .top, startRadius: 150, endRadius: 700)
            .ignoresSafeArea()
            VStack {
                Spacer()
                
                Text("Guess the Flag")
                    .font(.largeTitle.weight(.bold))
                    .foregroundColor(.white)
                VStack(spacing: 15) {
                    VStack {
                        Text("Tap the floag of")
                            .foregroundColor(.secondary)
                            .font(.subheadline.weight(.heavy))
                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                    }
                    ForEach(0..<3) { number in
                        Button(action: {
                            self.flagTapped(number)
                            withAnimation {
                                rotationAmount[number] += 360
                                for _number in 0 ..< ContentView.numberOfFlags where _number != number {
                                    opacityAmount[_number] = 0.75
                                    scaleAmount[_number] *= 0.75
                                }
                            }
                        }) {
                            flagImage(name: self.countries[number])
                        }
                 
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .opacity(opacityAmount[number])
                .scaleEffect(scaleAmount[number])
                .rotation3DEffect(.degrees(rotationAmount[number]),
                                  axis: (x: 0, y: 1, z: 0))
                .accessibilityLabel(labels[countries[number], default: "Unknown flag"])
                    }
                }
                Spacer()
                Spacer()
                
                Text("Score \(Score)")
                    .foregroundColor(.white)
                    .font(.title.bold())
                
                Spacer()
            }
            .padding()
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue", action: askQuestion)
        } message: {
            Text("Your score is \(Score)")
        }
        .alert("Game Over!", isPresented: $showingResults) {
            Button("Start Again!", action: newGame)
        } message: {
            Text("Your final score was \(Score)")
        }
    }
    
    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            scoreTitle = "Correct"
            Score += 1
        } else {
            let needsThe = ["UK", "US"]
            let theirAnswer = countries[number]
            
            if needsThe.contains(theirAnswer) {
                scoreTitle = "Wrong! That`s is the flag of the \(theirAnswer)"
            } else {
                
                scoreTitle = "Wrong! That`s is the flag of \(theirAnswer)"
            }
            if Score > 0 {
                Score -= 1
            }
        }
        if questionCounter == 8 {
            showingResults = true
        } else {
            showingScore = true
        }
    }
    
    func askQuestion() {
        countries.remove(at: correctAnswer)
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        questionCounter += 1
        rotationAmount = [Double](repeating: 0.0, count: ContentView.numberOfFlags)
        withAnimation {
            opacityAmount = [Double](repeating: 1.0, count: ContentView.numberOfFlags)
            scaleAmount = [Double](repeating: 1.0, count: ContentView.numberOfFlags)
        }
    }
    
    func newGame() {
        questionCounter = 0
        Score = 0
        countries = Self.allCountries
        askQuestion()
    }
}


















struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
