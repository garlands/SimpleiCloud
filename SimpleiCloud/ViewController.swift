//
//  ViewController.swift
//  SimpleiCloud
//
//  Created by Masahiro Tamamura on 2019/08/27.
//  Copyright © 2019 Masahiro Tamamura. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextViewDelegate {

    @IBOutlet var textView: UITextView!
    let filename : String = "test.txt"
    let query : NSMetadataQuery = NSMetadataQuery.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = nil

        if let cloudUrl = applicationCloudFolder(fileName: filename) {
            print("\(cloudUrl)")
            do {
                let content = try String(contentsOf: cloudUrl)
                textView.text = content
                saveLocalFile(fileName: filename)
            } catch {
                print("failed 0")
                loadLocalFile(fileName: filename)
            }
        }else{
            loadLocalFile(fileName: filename)
        }
    }
    
    @IBAction func touchUpSaveButton(_ sender: UIButton) {
        let dirPaths : Array = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let basePath : String = dirPaths[0]
        let filePath : String = "\(basePath)/\(filename)"
        
        let fileManager : FileManager = FileManager.default
        if fileManager.fileExists(atPath: basePath) {
            let content : String = textView.text
            do {
                try content.write(toFile: filePath, atomically: true, encoding: .utf8)
                
            } catch {
                print("failed 2")
            }
        }
        saveLocalFile(fileName: filename)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        let btn : UIBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(touchUpDoneButton))
        self.navigationItem.rightBarButtonItem = btn
    }
    
    @objc func touchUpDoneButton(button : UIButton){
         textView.endEditing(true)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if let text = textView.text {
            print("\(text)")
        }
        self.navigationItem.rightBarButtonItem = nil
    }
    
    func loadLocalFile(fileName : String) {
        let dirPaths : Array = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let basePath : String = dirPaths[0]
        let filePath : String = "\(basePath)/\(fileName)"
        do {
            let content = try String(contentsOfFile: filePath)
            textView.text = content
        } catch {
            print("failed 1")
        }
    }
    
    func saveLocalFile(fileName : String) {
        if let cloudUrl = applicationCloudFolder(fileName: fileName) {
            let content : String = textView.text
            do {
                try content.write(to: cloudUrl, atomically: true, encoding: .utf8)
            } catch {
                print("failed 3")
            }
        }else{
            print("failed 4")
        }
    }
    
    func applicationCloudFolder(fileName:String) -> URL?
    {
        let teamId : String = "(your teamID)"
        let bundleId  = Bundle.main.bundleIdentifier
        let containerId : String = "\(teamId).\(String(describing: bundleId))"
        if let cloudRootURL : URL = FileManager.default.url(forUbiquityContainerIdentifier: containerId) {
            var cloudDocuments : URL = cloudRootURL.appendingPathComponent("Documents")
            cloudDocuments = cloudDocuments.appendingPathComponent(fileName)
            return cloudDocuments
        }else{
            print("failed")
        }
        return nil
    }
}

