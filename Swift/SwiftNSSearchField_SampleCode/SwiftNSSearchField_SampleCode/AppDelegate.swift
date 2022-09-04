//
//  AppDelegate.swift
//  SwiftNSSearchField_SampleCode
//  ddas.tech
//  Created by Debasis Das on 9/4/22.
//

import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate,NSTableViewDelegate,NSTableViewDataSource,NSSearchFieldDelegate {

    @IBOutlet var window: NSWindow!
    @IBOutlet weak var tableView:NSTableView!
    @IBOutlet weak var searchField:NSSearchField!
    @IBOutlet weak var predicateTextField: NSTextField!
   
    var contacts:[Contact] = []
    var contactsArrayController:NSArrayController = NSArrayController()


    func applicationDidFinishLaunching(_ aNotification: Notification) {
        let contact1 = Contact(fName: "Debasis", lName: "Das")
        let contact2 = Contact(fName: "John", lName: "Doe")
        let contact3 = Contact(fName: "Jane", lName: "Doe")
        let contact4 = Contact(fName: "Mary", lName: "Jane")
        contacts.append(contact1)
        contacts.append(contact2)
        contacts.append(contact3)
        contacts.append(contact4)
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.searchField.delegate = self
        
        self.contactsArrayController.content = self.contacts
        self.tableView.reloadData()
    }


    func numberOfRows(in tableView: NSTableView) -> Int {
        if let contacts = self.contactsArrayController.arrangedObjects as? [Contact]{
            return contacts.count
        }
        else{
            return 0
        }
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        if let contacts = self.contactsArrayController.arrangedObjects as? [Contact]{
            let contact = contacts[row]
            var result:NSTableCellView
            result  = tableView.makeView(withIdentifier: (tableColumn?.identifier)!, owner: self) as! NSTableCellView
            switch tableColumn?.identifier.rawValue {
            case "firstName":
                result.textField?.stringValue = contact.firstName
            case "lastName":
                result.textField?.stringValue = contact.lastName
            default:
                result.textField?.stringValue = "Default Val"
            }
            return result

        }
        return nil
    }
    
    func controlTextDidChange(_ obj: Notification) {
        if let searchString = (obj.object as? NSSearchField)?.stringValue{
            if searchString != ""{
                let predicate = NSPredicate(format: "firstName contains %@ OR lastName contains %@ ",searchString,searchString)
                self.predicateTextField.stringValue = predicate.description
                self.contactsArrayController.filterPredicate = predicate
            } else{
                self.predicateTextField.stringValue = "No Predicate Applied"
                self.contactsArrayController.filterPredicate = nil
            }
            self.tableView.reloadData()
        }
        
    }

}

class Contact : NSObject{
    @objc var firstName : String = ""
    @objc var lastName: String = ""
    
    convenience init(fName:String, lName:String) {
        self.init()
        self.firstName = fName
        self.lastName = lName
    }
}

