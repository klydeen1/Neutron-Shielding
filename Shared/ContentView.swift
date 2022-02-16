//
//  ContentView.swift
//  Shared
//
//  Created by Katelyn Lydeen on 2/11/22.
//

import SwiftUI

struct ContentView: View {
    @State var energyLossString = "10"
    @State var particleCountString = "100"
    @State var percentEscapedString = "0.0"
    @State var isChecked:Bool = false
    
    // Setup the GUI to monitor the data from the Monte Carlo Integral Calculator
    @ObservedObject var neutronShield = NeutronShield(withData: true)
    
    var body: some View {
        HStack{
            VStack{
                VStack(alignment: .center) {
                    Text("Energy Loss (%)")
                        .font(.callout)
                        .bold()
                    TextField("# Energy Loss (%)", text: $energyLossString)
                        .padding()
                }
                .padding(.top, 5.0)
                
                VStack(alignment: .center) {
                    Text("Total Particle Count")
                        .font(.callout)
                        .bold()
                    TextField("# Total Particle Count", text: $particleCountString)
                        .padding()
                }
                
                VStack(alignment: .center) {
                    Text("Percent of Particles Escaped (%)")
                        .font(.callout)
                        .bold()
                    TextField("# Percent of Particles Escaped (%)", text: $percentEscapedString)
                        .padding()
                }
                
                Button("Cycle Calculation", action: {Task.init{await self.calculateWalks()}})
                    .padding()
                    .disabled(neutronShield.enableButton == false)
                
                if (!neutronShield.enableButton){
                    
                    ProgressView()
                }
                Toggle(isOn: $isChecked) {
                            Text("Plot Single Particle")
                        }
                .padding()
            }
            .padding()
            //DrawingField
            drawingView(redLayer:$neutronShield.insideData, blueLayer:$neutronShield.outsideData, singleParticleLayer:$neutronShield.singleParticleData, checked:$isChecked)
                .padding()
                .aspectRatio(1, contentMode: .fit)
                .drawingGroup()
            // Stop the window shrinking to zero.
            Spacer()
            
        }
    }
    
    func calculateWalks() async {
        await self.clearPlot()
        
        // Take user input for the energy loss and particle count
        neutronShield.energyLoss = Double(energyLossString)!
        neutronShield.particleCount = Int(particleCountString)!
        
        // Disable the calculate button
        neutronShield.setButtonEnable(state: false)
        
        // Get results for the random walk process
        await neutronShield.RandomWalk()
        percentEscapedString =  neutronShield.percentEscapedString
        
        // Enable the calculate button
        neutronShield.setButtonEnable(state: true)
    }
    
    @MainActor func clearPlot() async {
        neutronShield.insideData = []
        neutronShield.outsideData = []
        neutronShield.singleParticleData = []
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
