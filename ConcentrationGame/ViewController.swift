//
//  ViewController.swift
//  ConcentrationGame
//
//  Created by 林辰澤 on 2022/8/4.
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet weak var timeView: UIView!
    
    @IBOutlet weak var countDownLabel: UILabel!
    
    @IBOutlet weak var pairLabel: UILabel!
    
    @IBOutlet var cardBtns: [UIButton]!
    
    @IBOutlet weak var playButton: UIButton!
    
    var time:Timer?
    var cards = [Card]()
    var pickedCard = [Int]()
    var pair : Int!
    var seeTime : Int!
    var gameTime : Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        gameInit()
        
    }

    func gameInit()->Void{
        
        pair = 0
        seeTime = 5
        gameTime = 60
        
        countDownLabel.text = String(seeTime)
        pairLabel.text = String(pair)
        
        cards = [
            
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
        cards.shuffle() //原地洗牌
        displayCards()

    }
    
    func displayCards() {
        for (i,_) in cards.enumerated(){
            cardBtns[i].setImage(cards[i].cardImage, for: .normal)
            cards[i].flipped = true
        }
        if time == nil {
            time = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countDown), userInfo: nil, repeats: true)
        }
    }
    
    @objc func countDown() {
        //記憶卡牌時間倒數
        seeTime -= 1
        //當記憶卡牌時間歸零時，停止倒數並使用迴圈將UIView.transition將牌翻到背面
        if seeTime == 0 {
            time?.invalidate()
            time = nil
            for (i,_) in cards.enumerated() {
                cardBtns[i].setImage(UIImage(named: "question"), for: .normal)
                UIView.transition(with: cardBtns[i], duration: 0.5, options: .transitionFlipFromRight, animations: nil, completion: nil)
                cards[i].flipped = false
                
            }
            // 0.3秒後執行以下動作
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                UIView.transition(with: self.timeView, duration: 0.3, options: .transitionFlipFromRight, animations: nil, completion: nil)
                self.countDownLabel.text=String(self.gameTime)
                self.time = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.gameTimeCountDown), userInfo: nil, repeats: true)
                
            }
        }
        countDownLabel.text = String(seeTime) //update UI
                
    }
    
    //控制卡牌判斷正反面，正面時，翻背面/背面時，翻正面
    func flip(index:Int) {
        if cards[index].flipped == false {
            cardBtns[index].setImage(cards[index].cardImage, for: .normal)
            UIView.transition(with: cardBtns[index], duration: 0.5, options: .transitionFlipFromLeft, animations: nil, completion: nil)
            cards[index].flipped = true
        }else{
            cardBtns[index].setImage(UIImage(named: "question"), for: .normal)
            UIView.transition(with: cardBtns[index], duration: 0.5, options: .transitionFlipFromRight, animations: nil, completion: nil)
            cards[index].flipped = false
        }
    }
    
    @objc func gameTimeCountDown() {
        gameTime -= 1
        countDownLabel.text = String(gameTime)
        if gameTime == 0 {
            time?.invalidate()
            time = nil
            let timeOutAlert = UIAlertController(title: "Time Out", message: "Try Again!", preferredStyle: .alert)
            let timeOutAction = UIAlertAction(title: "Restart", style: .default) { (_) in
                self.restart()
            }
            timeOutAlert.addAction(timeOutAction)
            present(timeOutAlert, animated: true, completion: nil)
        }
    }
    
    func restart() {
//        seeTime = 3
//        gameTime = 60
//        pair = 0
        
        pickedCard.removeAll()
        for i in cardBtns{
            i.isEnabled = true
        }
        gameInit()
        
    }
    
    @IBAction func play(_ sender: Any) {
        playButton.isHidden = true
        for i in cardBtns{
            i.isHidden = false
        }
        gameInit()
    
    }
    
    @IBAction func flipCard(_ sender: UIButton) {
        //設cardNumber為sender，將sender函數加入pickedCard
        if let cardNumber = cardBtns.firstIndex(of: sender){
            pickedCard.append(cardNumber)
            flip(index: cardNumber)
            print(pickedCard)
            
            //當pickedCard為兩個數，判斷兩卡牌圖片是否相同
            if pickedCard.count == 2 {
                //如兩組牌相同
                if cards[pickedCard[0]].cardName==cards[pickedCard[1]].cardName {
                    print("相同")
                    //0.6秒後執行: pair+1, enabled=false並翻牌
                    DispatchQueue.main.asyncAfter(deadline: .now()+0.6) {
                        self.pair += 1
                        self.pairLabel.text = String(self.pair * 10) //score
                        for i in self.pickedCard{
                            self.cardBtns[i].isEnabled = false
                            UIView.transition(with: self.cardBtns[i], duration: 0.5, options: .transitionFlipFromTop, animations: nil, completion: nil)
                        }
                        //如組卡牌都配對成功，跳出alert: GameComplete。
                        if self.pair == 6 {
                            self.time?.invalidate() //時間暫停，否則時間將在背後持續運行。
                            self.time = nil
                            let gameCompleteAlert = UIAlertController(title: "Game Complete", message: "Well Done!", preferredStyle: .alert)
                            let gameCompleteAction = UIAlertAction(title: "Restart", style: .default) { (_) in
                                self.restart()
                            }
                            gameCompleteAlert.addAction(gameCompleteAction)
                            self.present(gameCompleteAlert, animated: true, completion: nil)
                        }
                        //pickedCard內容清除
                        self.pickedCard.removeAll()
                    }
                //如兩組牌不相同：牌翻回背面
                }else{
                    print("不同")
                    //0.6秒後執行翻牌回背面
                    DispatchQueue.main.asyncAfter(deadline: .now()+0.6) {
                        for i in self.pickedCard {
                            self.flip(index: i)
                            
                        }
                        //pickedCard內容清除
                        self.pickedCard.removeAll()
                    }
                    
                }
                
            }
        }
  
    }
    
    
}


//after restart 
