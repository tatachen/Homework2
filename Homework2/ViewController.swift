//
//  ViewController.swift
//  Homework2
//
//  Created by Tata on 2019/8/9.
//  Copyright © 2019 Tata. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate{
    
    @IBOutlet weak var genderSegment: UISegmentedControl!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var constellationText: UITextField!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var resultImage: UIImageView!
    
    var constellations = ["Aries", "Taurus", "Gemini", "Cancer", "Leo", "Virgo", "Libra", "Scorpio", "Sagittarius", "Capricorn", "Aquarius", "Pisces"]
    var autoCompleteCharacterCount = 0
    var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.constellationText.delegate = self
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var subString = (constellationText.text!.capitalized as NSString).replacingCharacters(in: range, with: string)
        subString = formatSubstring(subString: subString)
        if subString.count == 0 {
            resetValues()
        } else {
            searchAutocompleteEntriesWIthSubstring(substring: subString)
        }
        return true
    }
    
    func formatSubstring(subString: String) -> String {
        let formatted = String(subString.dropLast(autoCompleteCharacterCount)).lowercased().capitalized
        return formatted
    }
    
    func resetValues() {
        autoCompleteCharacterCount = 0
        constellationText.text = ""
    }
    
    func searchAutocompleteEntriesWIthSubstring(substring: String) {
        let userQuery = substring
        let suggestions = getAutocompleteSuggestions(userText: substring) //1
        
        if suggestions.count > 0 {
            timer = .scheduledTimer(withTimeInterval: 0.01, repeats: false, block: { (timer) in //2
                let autocompleteResult = self.formatAutocompleteResult(substring: substring, possibleMatches: suggestions) // 3
                self.putColourFormattedTextInTextField(autocompleteResult: autocompleteResult, userQuery : userQuery) //4
                self.moveCaretToEndOfUserQueryPosition(userQuery: userQuery) //5
            })
        } else {
            timer = .scheduledTimer(withTimeInterval: 0.01, repeats: false, block: { (timer) in //7
                self.constellationText.text = substring
            })
            autoCompleteCharacterCount = 0
        }
    }
    
    func getAutocompleteSuggestions(userText: String) -> [String]
    {
        var possibleMatches: [String] = []
        for item in constellations {
            let myString: NSString! = item as NSString
            let substringRange : NSRange! = myString.range(of: userText)
            if (substringRange.location == 0) {
                possibleMatches.append(item)
            }
        }
        return possibleMatches
    }
    
    func formatAutocompleteResult(substring: String, possibleMatches: [String]) -> String {
    var autoCompleteResult = possibleMatches[0]
    autoCompleteResult.removeSubrange(autoCompleteResult.startIndex..<autoCompleteResult.index(autoCompleteResult.startIndex, offsetBy: substring.count))
    autoCompleteCharacterCount = autoCompleteResult.count
    return autoCompleteResult
    }
    func putColourFormattedTextInTextField(autocompleteResult: String, userQuery : String) {
        let colouredString: NSMutableAttributedString = NSMutableAttributedString(string: userQuery + autocompleteResult)
        colouredString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.green, range: NSRange(location: userQuery.count,length:autocompleteResult.count))
        self.constellationText.attributedText = colouredString
    }
    func moveCaretToEndOfUserQueryPosition(userQuery : String) {
        if let newPosition = self.constellationText.position(from: self.constellationText.beginningOfDocument, offset: userQuery.count) {
            self.constellationText.selectedTextRange = self.constellationText.textRange(from: newPosition, to: newPosition)
        }
        let selectedRange: UITextRange? = constellationText.selectedTextRange
        constellationText.offset(from: constellationText.beginningOfDocument, to: (selectedRange?.start)!)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        constellationText.resignFirstResponder()
        return true
    }
    @IBAction func heightChange(_ sender: UISlider) {
        heightLabel.text = Int(sender.value).description
    }
    
    @IBAction func yearChange(_ sender: UIStepper) {
        yearLabel.text = Int(sender.value).description
    }
    
    @IBAction func submit(_ sender: UIButton) {
        let gender = genderSegment.titleForSegment(at: genderSegment.selectedSegmentIndex)
        let height:Int = Int(heightLabel.text!) ?? 0_
        let constellation:String = constellationText.text!
        if gender == "女"{
            resultImage.image = UIImage(named: "3")
        } else if height < 175 || constellation.contains("Virgo"){
            resultImage.image = UIImage(named: "2")
        } else {
            resultImage.image = UIImage(named: "1")
        }
        
    }
}

