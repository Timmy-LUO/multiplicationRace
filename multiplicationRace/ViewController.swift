//
//  ViewController.swift
//  multiplicationRace
//
//  Created by 羅承志 on 2021/6/25.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var rabbitView: UIView!
    @IBOutlet weak var rabbitLabel: UILabel!
    @IBOutlet weak var tortoiseLabel: UILabel!
    @IBOutlet var rabbitButton: [UIButton]!
    @IBOutlet var tortoiseButton: [UIButton]!
    @IBOutlet weak var rabbitImageView: UIImageView!
    @IBOutlet weak var tortoiseImageView: UIImageView!
    
    var leftNumbers = [Int]()
    var rightNumbers = [Int]()
    var answers = [Int]()
    var rabbitIndex = 0
    var tortoiseIndex = 0
    var rabbitCorrectIndex = 0
    var tortoiseCorrectIndex = 0
    
    func makeQuestion() {
        var leftNumber = 0
        var rightNumber = 0
        var answer = 0
        for i in 0...19 {
            leftNumber = Int.random(in: 1...9)
            rightNumber = Int.random(in: 1...9)
            leftNumbers.append(leftNumber)
            rightNumbers.append(rightNumber)
            //如果題目重複，會重新出題
            if i > 0 && i < 20 {
                while leftNumbers[i] == leftNumbers[i-1] && rightNumbers[i] == rightNumbers[i-1] {
                    leftNumbers.removeLast()
                    rightNumbers.removeLast()
                    leftNumber = Int.random(in: 1...9)
                    rightNumber = Int.random(in: 1...9)
                    leftNumbers.append(leftNumber)
                    rightNumbers.append(rightNumber)
                }
            }
            answer = leftNumber * rightNumber
            answers.append(answer)
        }
    }
    
    func rabbitQuestion() {
        rabbitLabel.text = "\(leftNumbers[rabbitIndex]) × \(rightNumbers[rabbitIndex])"
        var options = [answers[rabbitIndex], answers[rabbitIndex] + 1, answers[rabbitIndex] - 1, answers[rabbitIndex] + 10]
        options.shuffle()
        for i in 0...3 {
            rabbitButton[i].setTitle("\(options[i])", for: .normal)
        }
    }
    
    func tortoiseQuestion() {
        tortoiseLabel.text = "\(leftNumbers[tortoiseIndex]) Ｘ \(rightNumbers[tortoiseIndex])"
        var options = [answers[tortoiseIndex], answers[tortoiseIndex] + 1, answers[tortoiseIndex] - 1, answers[tortoiseIndex] + 10]
        options.shuffle()
        for i in 0...3 {
            tortoiseButton[i].setTitle("\(options[i])", for: .normal)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        //rabbitView 180度翻轉
        let view1Spin = CGFloat.pi / 180
        rabbitView.transform = CGAffineTransform.identity.rotated(by: view1Spin * 180)
        makeQuestion()
        rabbitQuestion()
        tortoiseQuestion()
        rabbitIndex += 1
        tortoiseIndex += 1
    }
    
    func resultAlert(win: String, lose: String) {
        let controller = UIAlertController(title: "\(win)Win🥳", message: "\(win)勝利", preferredStyle: .alert)
        let action = UIAlertAction(title: "Play Again", style: .default) { [self]_ in
            self.rabbitIndex = 0
            self.tortoiseIndex = 0
            self.rabbitCorrectIndex = 0
            self.tortoiseCorrectIndex = 0
            self.makeQuestion()
            rabbitIndex += 1
            tortoiseIndex += 1
            self.rabbitQuestion()
            self.tortoiseQuestion()
            tortoiseImageView.transform = CGAffineTransform(translationX: 0, y: 0)
            rabbitImageView.transform = CGAffineTransform(translationX: 0, y: 0)
        }
        controller.addAction(action)
        present(controller, animated: true, completion: nil)
    }
    
    @IBAction func rabbitAnswer(_ sender: UIButton) {
        if rabbitCorrectIndex < 6 {
            if sender.currentTitle == "\(answers[rabbitIndex - 1])" {
                rabbitCorrectIndex += 1
                rabbitImageView.transform = CGAffineTransform(translationX: CGFloat(-109 * rabbitCorrectIndex), y: 0)
                //下一題
                rabbitQuestion()
                rabbitIndex += 1
            } else {
                //下一題
                rabbitQuestion()
                rabbitIndex += 1
            }
            //兔子贏
            if rabbitCorrectIndex == 6 {
                resultAlert(win: "兔子", lose: "烏龜")
            }
        }
    }
    
    @IBAction func tortoiseAnswer(_ sender: UIButton) {
        if tortoiseCorrectIndex < 6 {
            if sender.currentTitle == "\(answers[tortoiseIndex - 1])" {
                tortoiseCorrectIndex += 1
                tortoiseImageView.transform = CGAffineTransform(translationX: CGFloat(-109 * tortoiseCorrectIndex), y: 0)
                //下一題
                tortoiseQuestion()
                tortoiseIndex += 1
            } else {
                //下一題
                tortoiseQuestion()
                tortoiseIndex += 1
            }
            //烏龜贏
            if tortoiseCorrectIndex == 6 {
                resultAlert(win: "烏龜", lose: "兔子")
            }
        }
    }
}
