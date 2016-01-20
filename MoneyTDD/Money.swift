//
//  Money.swift
//  MoneyTDD
//
//  Created by 손동우 on 2016. 1. 17..
//  Copyright © 2016년 easthelper. All rights reserved.
//

import Foundation


struct Money: Expression {
    let amount: Int
    let currency: String
    
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
    
    func reduce(bank: Bank, to: String) -> Money {
        let rate = bank.rate(currency, to:to)
        return Money(self.amount / rate, currency: to)
    }
}

func ==(lhs: Money, rhs: Money) -> Bool {
    return lhs.amount == rhs.amount
        && lhs.currency == rhs.currency
}

protocol Expression: Equatable {
    func reduce(bank: Bank, to: String) -> Money
    func plus<T: Expression>(added: T) -> Sum<Self, T>
    func times(multiplier: Int) -> Self
}

extension Expression {
    func plus<T: Expression>(added: T) -> Sum<Self, T> {
        return self + added
    }
}

func +<A: Expression, B:Expression>(augend:A, addend: B) -> Sum<A, B> {
    return Sum(aug: augend, add: addend)
}

func *<A: Expression>(lhs:A, rhs: Int) -> A {
    return lhs.times(rhs)
}

class Bank {
    var rates = [Pair:Int]()
    
    func rate(from: String, to: String) -> Int {
        if (from == to) {
            return 1;
        }
        return rates[Pair(from: from, to: to)]!
    }
    
    func addRate(from from: String, to: String, rate: Int) {
        rates[Pair(from: from, to: to)] = rate
    }
    
    func reduce<T: Expression>(exp: T, to: String) -> Money {
        return exp.reduce(self, to:to)
    }
}

struct Sum<A:Expression, B:Expression>: Expression {
    let augend: A
    let addend: B
    
    init(aug: A, add: B) {
        augend = aug
        addend = add
    }
    
    func reduce(bank: Bank, to: String) -> Money {
        let amount = augend.reduce(bank, to: to).amount
            + addend.reduce(bank, to: to).amount
        return Money(amount, currency: to)
    }
    
    func times(multiplier: Int) -> Sum<A, B> {
        return Sum<A, B>(aug: augend.times(multiplier), add: addend.times(multiplier))
    }
}

func ==<A, B>(lhs: Sum<A, B>, rhs: Sum<A, B>) -> Bool {
    return lhs.augend == rhs.augend
        && lhs.addend == rhs.addend
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