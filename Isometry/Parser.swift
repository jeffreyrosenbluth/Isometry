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
}
