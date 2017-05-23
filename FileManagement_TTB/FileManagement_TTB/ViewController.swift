//
//  ViewController.swift
//  FileManagement_TTB
//
//  Created by TTB on 5/23/17.
//  Copyright © 2017 TTB. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIAlertViewDelegate {
    
    var fileManager: FileManager?
    
    var documentDir:NSString?
    
    var filePath:NSString?

    override func viewDidLoad() {
        super.viewDidLoad()
        fileManager=FileManager.default
        
        let dirPaths:NSArray=NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as NSArray
        
        documentDir=dirPaths[0] as? NSString
        print("path : \(String(describing: documentDir))")
        
	       
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func btnCreateFileClicked(_ sender: Any) {
        
        filePath = documentDir?.appendingPathComponent("file1.txt") as NSString?
        fileManager?.createFile(atPath: filePath! as String, contents: nil, attributes: nil)
        filePath=documentDir?.appendingPathComponent("file2.txt") as! NSString
        fileManager?.createFile(atPath: filePath! as String, contents: nil, attributes: nil)
        self.showSuccessAlert(titleAlert: "Success", messageAlert: "File created successfully")
    }
    
    func showSuccessAlert(titleAlert:NSString,messageAlert:NSString)
    {
        let alert:UIAlertController=UIAlertController(title:titleAlert as String, message: messageAlert as String, preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default)
        {
            UIAlertAction in
        }
        alert.addAction(okAction)
        if UIDevice.current.userInterfaceIdiom == .phone
        {
            self.present(alert, animated: true, completion: nil)
        }
    }

    @IBOutlet weak var btnCreateDirectoryCliecked: UIButton!
    
    
    @IBAction func btnCreateDirectoryClicked(_ sender: Any) {
        
        do{
            try filePath=documentDir?.appendingPathComponent("/folder1") as NSString?
            try fileManager?.createDirectory(atPath: filePath! as String, withIntermediateDirectories: false, attributes: nil)
            try self.showSuccessAlert(titleAlert: "Success", messageAlert: "Directory created successfully")
        }
        catch let error as NSError{
            print("errorrr \(String(describing: error))")
        }
       // self.showSuccessAlert(titleAlert: "Success", messageAlert: "Directory created successfully")
        
        
//        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
//        let documentsDirectory: AnyObject = paths[0] as AnyObject
//        let dataPath = documentsDirectory.appendingPathComponent("/folder1")!
//        
//        do {
//            try FileManager.default.createDirectory(atPath: dataPath.absoluteString, withIntermediateDirectories: false, attributes: nil)
//        } catch let error as NSError {
//            print(error.localizedDescription);
//        }
        
        
        
        
        
    }
    
    @IBAction func btnWriteFileCliecked(_ sender: Any) {
        let content:NSString=NSString(string: "helllo how are you?")
        let fileContent:NSData=content.data(using: String.Encoding.utf8.rawValue)! as NSData
        fileContent.write(toFile: (documentDir?.appendingPathComponent("file1.txt"))!, atomically: true)
        self.showSuccessAlert(titleAlert: "Success", messageAlert: "Content written successfully")    }
    
    @IBAction func btnReadFileClicked(_ sender: Any) {
        filePath=documentDir?.appendingPathComponent("/file1.txt") as NSString?
        
        var fileContent:NSData?
        fileContent=fileManager?.contents(atPath: filePath! as String)! as! NSData
        
        let str:NSString=NSString(data: fileContent! as Data, encoding: String.Encoding.utf8.rawValue)!
        
        self.showSuccessAlert(titleAlert: "Success", messageAlert: "data : \(str)" as NSString)
    }
    
    
    @IBAction func btnMoveFileClicked(_ sender: Any) {
        let oldFilePath:String=documentDir!.appendingPathComponent("/folder1/move.txt") as String
        let newFilePath:String=documentDir!.appendingPathComponent("temp.txt") as String
        
        do{
            try fileManager?.moveItem(atPath: oldFilePath, toPath: newFilePath)
        }
        catch let err as NSError{
                print("errorrr \(String(describing: err))")
        }
        
        self.showSuccessAlert(titleAlert: "Success", messageAlert: "File moved successfully")
    }
    
    @IBOutlet weak var btnCopyFileClicked: UIButton!
    
    
    @IBAction func btnCopyFileClicked(sender: AnyObject)
    {
        filePath = documentDir?.appendingPathComponent("temp.txt") as NSString?
        let originalFile=documentDir?.appendingPathComponent("temp.txt")
        let copyFile=documentDir?.appendingPathComponent("copy.txt")
        do{
            try fileManager?.copyItem(atPath: originalFile!, toPath: copyFile!)
        }
        catch{
            
        }
        self.showSuccessAlert(titleAlert: "Success", messageAlert:"File copied successfully")
    }
    
    @IBAction func btnFilePermissionsClicked(_ sender: Any) {
        filePath = documentDir?.appendingPathComponent("temp.txt") as NSString?
        var filePermissions:NSString = ""
        if(fileManager?.isWritableFile(atPath: filePath! as String))!
        {
            filePermissions=filePermissions.appending("file is writable. ") as NSString
        }
        if(fileManager?.isReadableFile(atPath: (filePath! as String) as String))!
        {
            filePermissions=filePermissions.appending("file is readable. ") as NSString
        }
        if(fileManager?.isExecutableFile(atPath: ((filePath! as String) as String) as String))!
        {
            filePermissions=filePermissions.appending("file is executable.") as NSString
        }
        self.showSuccessAlert(titleAlert: "Success", messageAlert: "\(filePermissions)" as NSString)
        
    }
    
    @IBAction func btnEqualityClicked(_ sender: Any) {
        let filePath1=documentDir?.appendingPathComponent("temp.txt")
        let filePath2=documentDir?.appendingPathComponent("copy.txt")
        if(fileManager? .contentsEqual(atPath: filePath1!, andPath: filePath2!))!
        {
            self.showSuccessAlert(titleAlert: "Message", messageAlert: "Files are equal.")
        }
        else
        {
            self.showSuccessAlert(titleAlert: "Message", messageAlert: "Files are not equal.")
        }
    }
    
    @IBAction func btnDirectoryContantsClicked(_ sender: Any) {
        
        //fileManager = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask)
        do{
             let arrDirContent = try fileManager?.contentsOfDirectory(atPath: documentDir! as String)
            self.showSuccessAlert(titleAlert: "Success", messageAlert: "Content of directory \(String(describing: arrDirContent))" as NSString)
        }
        catch let error as NSError
        {
            print("Error: \(error.localizedDescription)")
        }
        
    }

    @IBAction func btnRemoveFileClicked(_ sender: Any) {
        filePath = documentDir?.appendingPathComponent("temp.txt") as NSString?
        do{
            try fileManager?.removeItem(atPath: filePath! as String)
        }
        catch let error as NSError {
            print("Error: \(error.localizedDescription)")
        }
        self.showSuccessAlert(titleAlert: "Message", messageAlert: "File removed successfully.")
    }
}





















