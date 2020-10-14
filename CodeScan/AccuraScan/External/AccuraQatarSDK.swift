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
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            
            accuraCameraWrapper?.accuraSDK()
//            Liveness.accuraLiveness()
            
        }

        FirebaseApp.configure()
    }
}
