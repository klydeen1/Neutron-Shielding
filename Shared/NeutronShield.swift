//
//  NeutronShield.swift
//  Neutron-Shielding
//
//  Created by Katelyn Lydeen on 2/11/22.
//

import Foundation

class NeutronShield: NSObject, ObservableObject {
    @MainActor @Published var insideData = [(xPoint: Double, yPoint: Double)]()
    @MainActor @Published var outsideData = [(xPoint: Double, yPoint: Double)]()
    @MainActor @Published var singleParticleData = [(xPoint: Double, yPoint: Double)]()
    @Published var energyLossString = ""
    @Published var particleCountString = ""
    @Published var percentEscapedString = ""
    @Published var enableButton = true
    
    var energyLoss = 0.0
    var particleCount = 1
    var percentEscaped = 0.0
    var wallLength = 5.0
    var meanFreePath = 1.0
    
    @MainActor init(withData data: Bool) {
        super.init()
        insideData = []
        outsideData = []
        singleParticleData = []
    }
    
    func RandomWalk() async {
        var numberEscaped = 0
        var angle: Double
        
        var newInsidePoints : [(xPoint: Double, yPoint: Double)] = []
        var newOutsidePoints : [(xPoint: Double, yPoint: Double)] = []
        var newSingleParticlePoints : [(xPoint: Double, yPoint: Double)] = []
        
        for count in stride(from: 1, through: particleCount, by: 1) {
            var position = (xPoint: meanFreePath, yPoint: 4.0)
            
            // Record the initial position of the first particle
            if count == 1 {
                newSingleParticlePoints.append(position)
            }
            
            var energy = 100.0
            while energy > 0.0 {
                // Get a random angle
                angle = Double.random(in: 0.0...2*Double.pi)
                // Travel one mean free path in the direction of the angle, then lose energy
                position.xPoint += meanFreePath * cos(angle)
                position.yPoint += meanFreePath * sin(angle)
                energy -= energyLoss
                
                // Record the current position of the first particle
                if count == 1 {
                    newSingleParticlePoints.append(position)
                }
                
                if (position.xPoint > wallLength || position.yPoint > wallLength || position.xPoint < 0.0 || position.yPoint < 0.0) {
                    // Particle has escaped the box
                    // This is its final destination
                    numberEscaped += 1
                    newOutsidePoints.append(position)
                    break
                }
                else {
                    // Particle is inside the box
                    if energy <= 0.0 {
                        // Particle has reached its final destination
                        newInsidePoints.append(position)
                    }
                }
            }
        }
        percentEscaped = Double(numberEscaped) / Double(particleCount) * 100
        
        //Append the points to the arrays needed for the displays
        //Don't attempt to draw more than 150,000 points to keep the display updating speed reasonable.
        var plotInsidePoints = newInsidePoints
        var plotOutsidePoints = newOutsidePoints
            
        if (newInsidePoints.count > 750001) {
            plotInsidePoints.removeSubrange(750001..<newInsidePoints.count)
        }
        
        if (newOutsidePoints.count > 750001){
            plotOutsidePoints.removeSubrange(750001..<newOutsidePoints.count)
        }
            
        await updateData(insidePoints: plotInsidePoints, outsidePoints: plotOutsidePoints, singleParticlePoints: newSingleParticlePoints)
        await updatePercentEscapedString(text: "\(percentEscaped)")
    }
    
    /// updateData
    /// The function runs on the main thread so it can update the GUI
    /// - Parameters:
    ///   - insidePoints: points inside the circle of the given radius
    ///   - outsidePoints: points outside the circle of the given radius
    @MainActor func updateData(insidePoints: [(xPoint: Double, yPoint: Double)], outsidePoints: [(xPoint: Double, yPoint: Double)], singleParticlePoints: [(xPoint: Double, yPoint: Double)]){
        insideData.append(contentsOf: insidePoints)
        outsideData.append(contentsOf: outsidePoints)
        singleParticleData.append(contentsOf: singleParticlePoints)
    }
    
    /// updatePercentEscapedString
    /// The function runs on the main thread so it can update the GUI
    /// - Parameter text: contains the string containing the current value of the percent of particles that escaped
    @MainActor func updatePercentEscapedString(text:String){
        self.percentEscapedString = text
    }
    
    /// setButtonEnable
    /// Toggles the state of the Enable Button on the Main Thread
    /// - Parameter state: Boolean describing whether the button should be enabled.
    @MainActor func setButtonEnable(state: Bool){
        if state {
            Task.init {
                await MainActor.run {
                    self.enableButton = true
                }
            }
        }
        else{
            Task.init {
                await MainActor.run {
                    self.enableButton = false
                }
            }
        }
    }
}
