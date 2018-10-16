//
//  Parser.swift
//  Isometry
//
//  Created by Jeffrey Rosenbluth on 10/15/18.
//  Copyright © 2018 Applause Code. All rights reserved.
//

import Foundation

enum Iso {
    case translation(CGPoint)
    case rotation1(CGFloat)
    case reflection1(CGFloat)
    case rotation2((CGPoint, CGFloat))
    case reflection2((CGFloat, CGFloat))
    case glide((CGPoint, CGFloat))
    case none
}

//func parseIso(_ toks: Array<Token>) -> (Iso, Array<Token>) {
//    guard let tok = toks.first else { return (.none, []) }
//    switch tok {
//    case .tToken:
//        
//    default:
//        <#code#>
//    }
//    return (.rotation1(1.5), toks)
//}
