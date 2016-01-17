//
//  MoneyTDDTests.swift
//  MoneyTDDTests
//
//  Created by 손동우 on 2016. 1. 17..
//  Copyright © 2016년 easthelper. All rights reserved.
//

import XCTest
import Quick
import Nimble

@testable import MoneyTDD

class MoneyTDDTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testMultiplication() {
        let five: Money = Money.dollar(5)
        XCTAssertEqual(Money.dollar(10), five.times(2))
        XCTAssertEqual(Money.dollar(15), five.times(3))
    }
    
    func testEquality() {
        XCTAssertTrue(Money.dollar(5) == Money.dollar(5))
        XCTAssertFalse(Money.dollar(5) == Money.dollar(6))
        XCTAssertFalse(Money.dollar(5) == Money.franc(5))
    }
    
    func testCurrency() {
        XCTAssertEqual("USD", Money.dollar(1).currency)
        XCTAssertEqual("CHF", Money.franc(1).currency)
    }
    
    func testSimpleAddition() {
        let five: Money = Money.dollar(5)
        let sum: Expression = five.plus(five)
        let bank = Bank()
        let reduced: Money = bank.reduce(sum, to: "USD")
        XCTAssertEqual(Money.dollar(10), reduced)
    }
    
    func testPlusReturnSum() {
        let five: Money = Money.dollar(5)
        let result: Expression = five.plus(five)
        let sum: Sum = result as! Sum
        XCTAssertEqual(sum.augend, five)
        XCTAssertEqual(sum.addend, five)
    }
    
    func testReduceSum() {
        let sum = Sum(aug: Money.dollar(3), add: Money.dollar(4))
        let bank = Bank()
        let result = bank.reduce(sum, to: "USD")
        XCTAssertEqual(result, Money.dollar(7))
    }
    
    func testReduceMoney() {
        let bank = Bank()
        let result = bank.reduce(Money.dollar(1), to: "USD")
        XCTAssertEqual(result, Money.dollar(1))
    }
    
    func testReduceDifferentCurrency() {
        let bank = Bank()
        bank.addRate("CHF", to: "USD", rate: 2)
        let result = bank.reduce(Money.franc(4), to: "USD")
        XCTAssertEqual(result, Money.dollar(2))
    }
    
    func testIdentityRate() {
        XCTAssertEqual(1, Bank().rate("USD", to: "USD"))
    }
    
    func testMixedAddition() {
        let fiveBucks: Money = Money.dollar(5)
        let tenFrancs: Money = Money.franc(10)
        let bank = Bank()
        bank.addRate("CHF", to: "USD", rate: 2)
        
        let result: Money = bank.reduce(fiveBucks.plus(tenFrancs), to: "USD")
        XCTAssertEqual(Money.dollar(10), result)
    }
    
    func testExpressionEquatable() {
        let five: Money = Money.dollar(5)
        let result: Expression = five.plus(five)
//        let five: Money = Money.dollar(5)
//        let result: Expression = five.plus(five)
    }
}