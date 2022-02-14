//
//  DrawingView.swift
//  Monte-Carlo-e-x-dx
//
//  Created by Katelyn Lydeen on 2/10/22.
//

//
//  DrawingView.swift
//  Monte Carlo Integration
//
//  Created by Jeff Terry on 12/31/20.
//
import SwiftUI

struct drawingView: View {
    
    @Binding var redLayer : [(xPoint: Double, yPoint: Double)]
    @Binding var blueLayer : [(xPoint: Double, yPoint: Double)]
    
    var body: some View {
    
        
        ZStack{
            /*
            Rectangle()
                .strokeBorder(Color.black, lineWidth: 5)
                .frame(width: 150, height: 150)
             */
             

            drawIntegral(drawingPoints: redLayer )
                .stroke(Color.red)
            
            drawIntegral(drawingPoints: blueLayer )
                .stroke(Color.blue)
        }
        .background(Color.white)
        //.aspectRatio(1, contentMode: .fill)
        .frame(width:700,height:700)
        
    }
}

struct DrawingView_Previews: PreviewProvider {
    
    @State static var redLayer : [(xPoint: Double, yPoint: Double)] = [(-0.5, 0.5), (0.5, 0.5), (0.0, 0.0), (0.0, 1.0)]
    @State static var blueLayer : [(xPoint: Double, yPoint: Double)] = [(-0.5, -0.5), (0.5, -0.5), (0.9, 0.0)]
    
    static var previews: some View {
       
        drawingView(redLayer: $redLayer, blueLayer: $blueLayer)
            .aspectRatio(1, contentMode: .fill)
            //.drawingGroup()
           
    }
}

struct drawIntegral: Shape {
   
    let smoothness : CGFloat = 1.0
    var drawingPoints: [(xPoint: Double, yPoint: Double)]  ///Array of tuples
    
    func path(in rect: CGRect) -> Path {
        
        // draw from the center of our rectangle
        // let center = CGPoint(x: rect.width / 2, y: rect.height / 2)
        // var scale = rect.width
        
        let center = CGPoint(x: 350.0, y: 350.0) // width/2, height/2
        let scale = 100.0 // width/7
        

        // Create the Path for the display
        var path = Path()
        
        for item in drawingPoints {
            
            path.addRect(CGRect(x: item.xPoint*scale+center.x/3.5, y: 600.0-item.yPoint*scale, width: 1.0, height: 1.0))
            
        }
        
        path.addRect(CGRect(x: 1*scale, y: 1*scale, width: 500.0, height: 500.0))
        
        return (path)
    }
}
