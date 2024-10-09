//
//  Extensions.swift
//  Spy
//
//  Created by Александр Печинкин on 09.10.2024.
//

import Foundation

let amountFormatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.zeroSymbol = ""
    formatter.allowsFloats = false // Разрешить ввод дробей
    formatter.maximumFractionDigits = 0 // Максимальное количество знаков после запятой
    return formatter
}()
