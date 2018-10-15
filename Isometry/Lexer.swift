//
//  Lexer.swift
//  Isometry
//
//  Created by Jeffrey Rosenbluth on 10/13/18.
//  Copyright © 2018 Applause Code. All rights reserved.
//

import Foundation

enum Token {
    case tToken
    case rToken
    case fToken
    case gToken
    case leftParen
    case rightParen
    case comma
    case number(Double)
}

func tokenize(_ str: String) -> Array<Token> {
    var result: Array<Token> = []
    let chars = Array(str)
    var buffer: Array<Character> = []
    func digits(ds: Array<Character>) {
        if ds == [] { return }
        if let x = Double(String(ds)) {
            result.append(.number(x))
        }
        buffer = []
    }
    for c in chars {
        switch c {
        case "t":
            digits(ds: buffer)
            result.append(.tToken)
        case "r":
            digits(ds: buffer)
            result.append(.rToken)
        case "f":
            digits(ds: buffer)
            result.append(.fToken)
        case "g":
            digits(ds: buffer)
            result.append(.gToken)
        case "(":
            digits(ds: buffer)
            result.append(.leftParen)
        case ")":
            digits(ds: buffer)
            result.append(.rightParen)
        case ",":
            digits(ds: buffer)
            result.append(.comma)
        case ".", "-", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9":
           buffer.append(c)
        case " ": continue
        default: return []
        }
    }
    return result
}
