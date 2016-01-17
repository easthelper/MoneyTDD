//
//  Money.swift
//  MoneyTDD
//
//  Created by 손동우 on 2016. 1. 17..
//  Copyright © 2016년 easthelper. All rights reserved.
//

import Foundation


class Money: Expression {
    var amount: Int
    private(set) var currency: String
    
    init(_ amount:Int, currency: String) {
        self.currency = currency
        self.amount = amount;
    }
    
    static func dollar(amount: Int) -> Money {
        return Money(amount, currency: "USD")
    }
    
    static func franc(amount: Int) -> Money {
        return Money(amount, currency: "CHF")
    }
    
    func times(multiplier: Int) -> Money {
        return Money(amount * multiplier, currency: currency)
    }
    
    func plus(added: Money) -> Expression {
        return Sum(aug: self, add: added)
    }
    
    func reduce(bank: Bank, to: String) -> Money {
        let rate = bank.rate(currency, to:to)
        return Money(self.amount / rate, currency: to)
    }
}

extension Money: Equatable {}

func ==(lhs: Money, rhs: Money) -> Bool {
    return lhs.amount == rhs.amount
        && lhs.currency == rhs.currency
}

protocol Expression {
    func reduce(bank: Bank, to: String) -> Money
}

class Bank {
    var rates = [Pair:Int]()
    
    func rate(from: String, to: String) -> Int {
        if (from == to) {
            return 1;
        }
        return rates[Pair(from: from, to: to)]!
    }
    
    func addRate(from: String, to: String, rate: Int) {
        rates[Pair(from: from, to: to)] = rate
    }
    
    func reduce(exp: Expression, to: String) -> Money {
        return exp.reduce(self, to:to)
    }
}

class Sum: Expression {
    let augend: Money
    let addend: Money
    
    init(aug: Money, add: Money) {
        augend = aug
        addend = add
    }
    
    func reduce(bank: Bank, to: String) -> Money {
        let amount = augend.reduce(bank, to: to).amount
            + addend.reduce(bank, to: to).amount
        return Money(amount, currency: to)
    }
}

struct Pair {
    let from: String
    let to: String
    
    var hashValue: Int {
        return 0
    }
}

extension Pair: Equatable { }

func ==(lhs: Pair, rhs: Pair) -> Bool {
    return lhs.from == rhs.from
        && lhs.to == rhs.to
}

extension Pair: Hashable { }