//
//  ViewController.swift
//  SwiftSoupExample
//
//  Created by Hansub Yoo on 2022/08/18.
//

import UIKit
import SwiftSoup

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        crawl()
        
    }

    func crawl(){
        let rawEncoding = CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(CFStringEncodings.EUC_KR.rawValue))
        let encoding = String.Encoding(rawValue: rawEncoding)
        
        let url = URL(string: "https://dhlottery.co.kr/gameResult.do?method=statGroupNum")
        print("url",url)
        guard let myURL = url else {   return    }
        print("my url", myURL)
        
        do {
            let html = try! String(contentsOf: myURL, encoding: encoding)
//            print(html)
            let doc: Document = try SwiftSoup.parse(html)
            print(doc)
            let headerTitle = try doc.title()
            print(headerTitle)

//            let firstLinkTitles: Elements = try doc.select("tbody > tr > td:nth-child(1) > span") //.은 클래스
//            print(try firstLinkTitles.text())
//
//            for i in firstLinkTitles {
//                print("title: ", try i.text())
//            }
//
            let secondLinkTitles: Elements = try doc.select("tbody > tr > td:nth-child(3)") //.은 클래스
            print(try secondLinkTitles.text())

            for i in secondLinkTitles {
                print("title: ", try i.text())
            }
            
        } catch Exception.Error(let type, let message) {
            print("Message: \(message)")
        } catch {
            print("error")
        }
        
    }
    
    // MARK: EUC-KR 인코딩
    func euckrEncoding(_ query: String) -> String {
        
        let rawEncoding = CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(CFStringEncodings.EUC_KR.rawValue))
        let encoding = String.Encoding(rawValue: rawEncoding)
        
        let eucKRStringData = query.data(using: encoding) ?? Data()
        let outputQuery = eucKRStringData.map {byte->String in
            if byte >= UInt8(ascii: "A") && byte <= UInt8(ascii: "Z")
                || byte >= UInt8(ascii: "a") && byte <= UInt8(ascii: "z")
                || byte >= UInt8(ascii: "0") && byte <= UInt8(ascii: "9")
                || byte == UInt8(ascii: "_") || byte == UInt8(ascii: ".") || byte == UInt8(ascii: "-")
            {
                return String(Character(UnicodeScalar(UInt32(byte))!))
            } else if byte == UInt8(ascii: " ") {
                return "+"
            } else {
                return String(format: "%%%02X", byte)
            }
        }.joined()
        
        return outputQuery
    }
}

