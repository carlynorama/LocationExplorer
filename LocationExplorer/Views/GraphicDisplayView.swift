//
//  GraphicDisplayView.swift
//  SimpleServiceModel
//
//  Created by Labtanza on 9/4/22.
// https://www.evl.uic.edu/pape/data/Earth/
// 

import SwiftUI

struct GraphicDisplayView: View {
   @StateObject var displayVM = GraphicDisplayVM()
   
    
//    func translatedRect(rect:CGRect, size:CGSize) -> CGRect {
//        CGRect(origin: displayVM.displayGenerator.epicenter, size:CGSize(width: 12.0, height: 12.0))
//    }
    
    let markSize = CGSize(width: 12.0, height: 12.0)
    
    
    var body: some View {
        ZStack {
            Image("WorldMap").resizable()
            TimelineView(.animation) { timeline in
                Canvas { context, size in
                    _ = timeline.date.timeIntervalSinceReferenceDate
                    displayVM.displayGenerator.updateSize(to: size)
                    let mark = context.resolve(Image(systemName: displayVM.imageName))
                    let rect = CGRect(origin: displayVM.displayGenerator.epicenter, size:markSize)
                    context.translateBy(x: -markSize.width/2, y: -markSize.height/2)
                    context.draw(mark, in: rect)
                }
                
            }
        }.border(.background)
            .task {
                await displayVM.watchForLocations()
            }
//        .onReceive(displayVM.locationService.locationPublisher) { location in
//            displayVM.updateDisplayPoint(location)
//            displayVM.updateSymbol(location)
//        }
    }
}
struct GraphicDisplayView_Previews: PreviewProvider {
    static var previews: some View {
        GraphicDisplayView()
    }
}
