//
//  BlackJackMobileTests.swift
//  BlackJackMobileTests
//
//  Created by Alex da Franca on 27.02.22.
//

import XCTest
@testable import BlackJackMobile

class BlackJackMobileTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testBlackJack() throws {
        measure {
            let sut = BlackJack(playerNames: ["Player 1", "Player 2"])
            if !sut.ended {
                XCTAssertEqual(2, sut.dealerHand.count)
                XCTAssertGreaterThan(sut.computeDealerScore(), 2)
                XCTAssertEqual(2, sut.hand(of: sut.players[0]).count)
                XCTAssertEqual(2, sut.hand(of: sut.players[1]).count)
                XCTAssertEqual("Player 1", sut.currentPlayer?.name)
                sut.stand()
                sut.changeTurn()
                XCTAssertEqual("Player 2", sut.currentPlayer?.name)
                sut.stand()
                XCTAssertTrue(sut.ended)
            } else {
                let blackjack = sut.players.first { $0.currentStatus == .blackjack }
                if blackjack == nil {
                    XCTAssertEqual(21, sut.computeDealerScore())
                } else {
                    XCTAssertEqual(21, blackjack?.computeScore())
                }
            }
        }
    }

    func testMockedBlackJack() {
        let mockedDeck = MockedDeck()
        mockedDeck.cards = [
            Card(value: 3, suit: .diamonds),
            Card(value: 4, suit: .diamonds),
            Card(value: 2, suit: .diamonds),
            Card(value: 3, suit: .diamonds),
            Card(value: 4, suit: .diamonds),
            Card(value: 2, suit: .diamonds),
            Card(value: 12, suit: .diamonds),
            Card(value: 1, suit: .diamonds),
            Card(value: 1, suit: .diamonds),
            Card(value: 3, suit: .diamonds)
        ]
        let sut = BlackJack(
            playerNames: ["Player 1", "Player 2"],
            deck: mockedDeck
        )
        XCTAssertEqual(6, sut.players[0].computeScore())
        sut.hit()
        sut.changeTurn()
        XCTAssertEqual(8, sut.players[1].computeScore())
        sut.hit()
        sut.changeTurn()
        XCTAssertEqual("Score: 16", sut.players[0].result)
        sut.stand()
        XCTAssertEqual("Score: 19", sut.players[1].result)
        sut.stand()
        XCTAssertEqual(18, sut.computeDealerScore())
        XCTAssertTrue(sut.ended)
        let status = sut.status(of: sut.players[1])
        XCTAssertEqual("Won!", status.text)
    }
}

class MockedDeck: CardDeck {
    var cards = [Card]()

    func pickCard() -> Card {
        return cards.remove(at: 0)
    }
}
