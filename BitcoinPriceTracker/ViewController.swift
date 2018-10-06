//
//  ViewController.swift
//  BitcoinPriceTracker
//
//  Created by Filip on 05/10/2018.
//  Copyright © 2018 Filip. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire


class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    let baseURL = "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTC"
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    let currencySymbolsArray = ["$", "R$", "$", "¥", "€", "£", "$", "Rp", "₪", "₹", "¥", "$", "kr", "$", "zł", "lei", "₽", "kr", "$", "$", "R"]
    var finalURL = ""
    var symbol = ""
    
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var pickerView: UIPickerView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
        
        
    }

    
//    //MARK: - PickerView
//    /***************************************************************/
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 1
        
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return currencyArray.count
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return currencyArray[row]
       
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        
        finalURL = baseURL + currencyArray[row]
        symbol = currencySymbolsArray[row]
        
        getBitcoinData(url: finalURL)
        
    }
    
    
    //    //MARK: - Networking
    //    /***************************************************************/
  
    func getBitcoinData(url: String) {
        
        
        Alamofire.request(url, method: .get)
            .responseJSON { response in
                if response.result.isSuccess {
                    
                    //print("Success")
                    let bitcoinJSON : JSON = JSON(response.result.value!)
                    self.updateBitcoinData(json: bitcoinJSON)
                    //print(bitcoinJSON)
                    
                } else {
                 
                    print("Error: \(String(describing: response.result.error))")
                    self.priceLabel.text = "Connection Issues"
                    
                }
        }
        
        
    }
    
    
    //MARK: - JSON Parsing
    //    /***************************************************************/

    func updateBitcoinData(json : JSON) {
        
        if let tempData = json["bid"].double {
            
            self.priceLabel.text = "\(symbol) \(tempData)" //symbol + " " + String(tempData)
            priceLabel.adjustsFontSizeToFitWidth = true
            //print(tempData)
            
        }
        
    }
    
}

