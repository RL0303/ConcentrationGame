//
//  Card.swift
//  ConcentrationGame
//
//  Created by 林辰澤 on 2022/8/4.
//

import Foundation
import UIKit

struct Card {
    var cardName:String?
    var cardImage:UIImage?
    var flipped:Bool? = false
}

var cards = [
    
    Card(cardName: "0", cardImage: UIImage(named: "0")),
    Card(cardName: "1", cardImage: UIImage(named: "1")),
    Card(cardName: "2", cardImage: UIImage(named: "2")),
    Card(cardName: "3", cardImage: UIImage(named: "3")),
    Card(cardName: "4", cardImage: UIImage(named: "4")),
    Card(cardName: "5", cardImage: UIImage(named: "5")),
    
    Card(cardName: "0", cardImage: UIImage(named: "0")),
    Card(cardName: "1", cardImage: UIImage(named: "1")),
    Card(cardName: "2", cardImage: UIImage(named: "2")),
    Card(cardName: "3", cardImage: UIImage(named: "3")),
    Card(cardName: "4", cardImage: UIImage(named: "4")),
    Card(cardName: "5", cardImage: UIImage(named: "5"))
    
]
