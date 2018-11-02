//
//  Common.swift
//  DeepSocial
//
//  Created by Chung BD on 4/14/18.
//  Copyright © 2018 ChungBui. All rights reserved.
//

import Foundation
import UIKit

let Google_Cloud_Key = "AIzaSyBt5lT0r_QDt4JB9HJaYfSjLifaheXn8hU"

let COLOR_MAIN = UIColor(red: 0, green: 122/255.0, blue: 255/255.0, alpha: 1)

let G_ROUTE_COORDINATOR = RouteCoordinator.share

class Box<A> {
    var value: A
    init(_ val: A) {
        self.value = val
    }
}

public extension Sequence {
    func group<U: Hashable>(by key: (Iterator.Element) -> U) -> [U:[Iterator.Element]] {
        var categories: [U: Box<[Iterator.Element]>] = [:]
        for element in self {
            let key = key(element)
            if case nil = categories[key]?.value.append(element) {
                categories[key] = Box([element])
            }
        }
        var result: [U: [Iterator.Element]] = Dictionary(minimumCapacity: categories.count)
        for (key,val) in categories {
            result[key] = val.value
        }
        return result
    }
}

func hexStringToUIColor (hex:String) -> UIColor {
    var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
    
    if (cString.hasPrefix("#")) {
        cString.remove(at: cString.startIndex)
    }
    
    if ((cString.count) != 6) {
        return UIColor.gray
    }
    
    var rgbValue:UInt32 = 0
    Scanner(string: cString).scanHexInt32(&rgbValue)
    
    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
}

func intNumberToHexString(intNumber:Int) -> String {
    return String(format: "%02lX", intNumber)
}

func hexStringOfColor(red:Int,green:Int,blue:Int) -> String {
    return "#\(intNumberToHexString(intNumber: red))\(intNumberToHexString(intNumber: green))\(intNumberToHexString(intNumber: blue))"
}

extension UIButton {
    func setBackgroundColor(color: UIColor, forState: UIControl.State) {
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        UIGraphicsGetCurrentContext()!.setFillColor(color.cgColor)
        UIGraphicsGetCurrentContext()!.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
        let colorImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.setBackgroundImage(colorImage, for: forState)
    }
}

extension NSMutableAttributedString{
    func setColorForText(_ textToFind: String?, with color: UIColor) {
        let range:NSRange?
        
        if let text = textToFind {
            range = self.mutableString.range(of: text, options: .caseInsensitive)
        }else{
            range = NSMakeRange(0, self.length)
        }
        
        if range!.location != NSNotFound {
            addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range!)
        }
    }
    
    func setFontForText(_ textToFind: String?, with font: UIFont) {
        let range:NSRange?
        
        if let text = textToFind {
            range = self.mutableString.range(of: text, options: .caseInsensitive)
        }else{
            range = NSMakeRange(0, self.length)
        }
        
        if range!.location != NSNotFound {
            addAttribute(NSAttributedString.Key.font, value: font, range: range!)
        }
    }
}

extension CGFloat {
    static var random: CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}

extension UIColor {
    static var random: UIColor {
        return UIColor(red: .random, green: .random, blue: .random, alpha: 1.0)
    }
}

class UIManager {
    enum AlertType {
        case error
        case announcement
    }
    
    static func addShawdow(to view:UIView) {
        let layer = view.layer
        let shadowPath = UIBezierPath(rect: view.bounds)
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        layer.shadowOpacity = 0.5
        layer.shadowPath = shadowPath.cgPath
    }

    class func showAlert(withViewController vc:UIViewController, content:String?, type:AlertType = .announcement, completion:(()->Void)? = nil) {
        
        var title:String = "Announcement"
        
        switch type {
        case .error:
            title = "Alert"
        default:
            break
        }
        
        let alert = UIAlertController(title: title, message: content, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: { (_) in
            alert.dismiss(animated: true, completion: nil)
            completion?()
        })
        
        alert.addAction(okAction)
        vc.present(alert, animated: true, completion: nil)
    }
    
    class func showErrorAlert(withViewController vc:UIViewController, error:Error?) {
        if let error = error {
            showAlert(withViewController: vc, content: error.localizedDescription, type: .error)
        } else {
            showAlert(withViewController: vc, content: "", type: .error)
        }
    }
    
}

struct Utility {
    static func getDocumentDirectory() -> URL {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return documentsDirectory
    }
    
    static func getDirectory(withFileDirectory filename:String) -> URL {
        let docDirec = getDocumentDirectory()
        
        return docDirec.appendingPathComponent(filename)
    }
    
}

func getDataFromFile(_ fileName:String,extensionType:String) -> Data? {
    let bundle = Bundle.main
    if let path = bundle.path(forResource: fileName, ofType: extensionType) {
        return (try? Data(contentsOf: URL(fileURLWithPath: path)))
    }
    return nil
}

func delayWithSeconds(_ seconds: Double, completion: @escaping () -> ()) {
    DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
        completion()
    }
}
