//
//  AccuraOCRSDK.swift
//  AccuraSDK
//


import Foundation
import AccuraQatar
import Firebase
public class AccuraQatarSDK: NSObject {
    
    
   public static func configure() -> Void{
    
        var accuraCameraWrapper: AccuraCameraWrapper? = nil
        accuraCameraWrapper = AccuraCameraWrapper.init()
        accuraCameraWrapper?.showLogFile(true) // Set true to print log from Qatar SDK
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            
            accuraCameraWrapper?.accuraSDK()
//            Liveness.accuraLiveness()
            
        }

        FirebaseApp.configure()
    }
}
