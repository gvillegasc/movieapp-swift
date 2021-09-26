//
//  StringExtension.swift
//  MovieApp
//
//  Created by Gerardo Villegas on 19/09/21.
//

import Foundation

extension String {
    
    var convertReleaseDate: String {
        let arrStr = Array(self)
        let year = String(arrStr[0..<4])
        let monthNumber = Int(String(arrStr[5..<7]))
        let day = String(arrStr[8..<10])
        let fmt = DateFormatter()
        fmt.dateFormat = "MM"
        let month = fmt.monthSymbols[monthNumber! - 1]
        return "\(month) \(day), \(year)"
    }
}
