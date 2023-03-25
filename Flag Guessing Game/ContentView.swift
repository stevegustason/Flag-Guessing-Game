//
//  ContentView.swift
//  Flag Guessing Game
//
//  Created by Steven Gustason on 3/21/23.
//

import SwiftUI

// Custom FlagImage view to style our flags
struct FlagImage: View {
    var country = ""
    
    var body: some View {
        Image(country)
        // Rendering mode original makes it so the button will keep the original image rather than being styled like a button
            .renderingMode(.original)
        // ClipShape changes the shape of our flags to capsules
            .clipShape(Capsule())
        // Add a shadow to our flags
            .shadow(radius: 5)
    }
}

struct ContentView: View {
    // Randomly shuffled array of countries to guess
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    // Randomly decides which flag is going to be the correct answer
    @State private var correctAnswer = Int.random(in: 0...2)
    // Variable to store whether the alert is showing or not
    @State private var showingScore = false
    // Variable to store the title to be shown in the alert
    @State private var scoreTitle = ""
    // Variable to track the user's score
    @State private var score = 0
    // Variable to track the number of questions so far
    @State private var numQuestions = 0
    
    // When you click a flag this function will run, compare the number of the flag you selected to the correct answer, and then set the scoreTitle and trigger the showingScore alert (and increment the score if you were correct)
    func flagTapped(_ number: Int) {
        if numQuestions == 8 {
            scoreTitle = "You've completed this round - would you like to restart?"
        } else if number == correctAnswer {
            scoreTitle = "Correct!"
            score += 1
        } else {
            scoreTitle = "Wrong, that's the flag of \(countries[number])!"
        }
        
        numQuestions += 1
        
        showingScore = true
    }
    
    // This function will re-shuffle our country array and select a new correct answer
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
    
    // This function sets our number of questions asked and score back to zero, then calls askQuestion to shuffle the countries and se
    func restart() {
        numQuestions = 0
        score = 0
        askQuestion()
    }
    
    var body: some View {
        ZStack {
            // Adds a radial gradiant background behind our entire outer VStack - identical stops make it so the color switches directly from one to the next
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3),
            ], center: .top, startRadius: 200, endRadius: 400)
            .ignoresSafeArea()
            
            VStack {
                // We use a few spacers here to separate our content nicely
                Spacer()
                // Adds a large bold white title
                Text("Guess the Flag")
                        .font(.largeTitle.bold())
                        .foregroundColor(.white)
                Spacer()
                Spacer()
                // Shows our score with an unbolded white title
                Text("Score: \(score)/8")
                    .foregroundColor(.white)
                    .font(.title.bold())
                
                Spacer()
                // Outer VStack is needed because we have two views inside and if they were outside this VStack, the body would be trying to return two views instead of just one
                VStack(spacing: 15) {
                    VStack {
                        // Here we add some generic selection text, bolded, with a secondary color, and with a sub headline style
                        Text("Tap the flag of")
                            .foregroundColor(.secondary)
                            .font(.subheadline.weight(.heavy))
                        
                        // And here we display which of the three flags is the one to be chosen by picking one of the first three countries in the randomly shuffled array, with a large title sized font, semi-bolded
                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                    }
                    
                    // Draw three flag buttons from the first three of our randomly shuffled array
                    ForEach(0..<3) {number in
                        Button {
                            // When you click the button, we call our flagTapped function to check if it was the correct answer and show an alert
                            flagTapped(number)
                        } label: {
                            // Here we grab the image of the first three randomly shuffled countries in our array, and use our FlagImage view to style the flags
                            FlagImage(country: countries[number])
                        }
                    }
                }
                // Adds a frame to highlight the center of our app that takes up the full width, has 20 vertical padding from the top and bottom items in the VStack, a regular material background, and a rounded rectangle shape
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
            }
            .padding()
        }
        // This shows our alert when showingScore is true, which is set to true when a button is pressed - it shows our scoreTitle set by our flagTapped function
        .alert(scoreTitle, isPresented: $showingScore) {
            // If it's the final question, the alert will have a button asking if you want to restart and will call the restart function
            if numQuestions == 8 {
                Button("Restart?", action: restart)
            } else {
                // If it's not the final question, the alert will have a button that says continue, which will call askQuestion to re-shuffle our flags and the correct answer
                Button("Continue", action: askQuestion)
            }
            // The alert will also display your score
        } message: {
            // If it's the final question, we display a different message
            if numQuestions == 8 {
                Text("Your final score is \(score)/8")
            } else {
                Text("Your score is \(score)/8")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
