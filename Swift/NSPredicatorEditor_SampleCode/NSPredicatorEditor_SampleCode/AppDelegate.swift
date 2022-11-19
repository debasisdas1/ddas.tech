//  AppDelegate.swift
//  NSPredicatorEditor_SampleCode
//  Created by Debasis Das on 11/18/22.

import Cocoa

let defaultPredicate = "FIRST_NAME == 'JOHN' OR LAST_NAME == 'DOE' OR (DOB >= CAST('1/1/1985 00:00', 'NSDate') AND DOB <= CAST('01/01/1995', 'NSDate'))"
@main
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet var window: NSWindow!
    @IBOutlet weak var predicateEditor: NSPredicateEditor!
    @IBOutlet weak var queryTextField: NSTextField!
    
    
    func predicateRowTemplates()-> [NSPredicateEditorRowTemplate]{
        let compoundPredicateRowTemplate = NSPredicateEditorRowTemplate(compoundTypes: [NSNumber(value:NSCompoundPredicate.LogicalType.and.rawValue),
            NSNumber(value:NSCompoundPredicate.LogicalType.or.rawValue),
            NSNumber(value:NSCompoundPredicate.LogicalType.not.rawValue)]
        )
        
        let stringOperators = [
            NSNumber(value: NSComparisonPredicate.Operator.equalTo.rawValue),
            NSNumber(value: NSComparisonPredicate.Operator.notEqualTo.rawValue),
            NSNumber(value: NSComparisonPredicate.Operator.like.rawValue),
            NSNumber(value: NSComparisonPredicate.Operator.beginsWith.rawValue),
            NSNumber(value: NSComparisonPredicate.Operator.endsWith.rawValue),
            NSNumber(value: NSComparisonPredicate.Operator.contains.rawValue)
        ]
        
        let dateAndNumberOperators = [
            NSNumber(value: NSComparisonPredicate.Operator.equalTo.rawValue),
            NSNumber(value: NSComparisonPredicate.Operator.notEqualTo.rawValue),
            NSNumber(value: NSComparisonPredicate.Operator.lessThan.rawValue),
            NSNumber(value: NSComparisonPredicate.Operator.lessThanOrEqualTo.rawValue),
            NSNumber(value: NSComparisonPredicate.Operator.greaterThan.rawValue),
            NSNumber(value: NSComparisonPredicate.Operator.greaterThanOrEqualTo.rawValue)
        ]
        
        
        let firstNameRowTemplate = NSPredicateEditorRowTemplate(
            leftExpressions: [NSExpression(forKeyPath: "FIRST_NAME")],
            rightExpressionAttributeType: .stringAttributeType,
            modifier: .direct,
            operators: stringOperators,
            options: 0)
        
        let lastNameRowTemplate = NSPredicateEditorRowTemplate(
            leftExpressions: [NSExpression(forKeyPath: "LAST_NAME")],
            rightExpressionAttributeType: .stringAttributeType,
            modifier: .direct,
            operators: stringOperators,
            options: 0)
        
        let dobRowTemplate = NSPredicateEditorRowTemplate(
            leftExpressions: [NSExpression(forKeyPath: "DOB")],
            rightExpressionAttributeType: .dateAttributeType,
            modifier: .direct,
            operators: dateAndNumberOperators,
            options: 0)
        
        let ageRowTemplate = NSPredicateEditorRowTemplate(
            leftExpressions: [NSExpression(forKeyPath: "AGE")],
            rightExpressionAttributeType: .integer32AttributeType,
            modifier: .direct,
            operators: dateAndNumberOperators,
            options: 0)
        
        return [compoundPredicateRowTemplate,firstNameRowTemplate,lastNameRowTemplate,dobRowTemplate,ageRowTemplate]
    }

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
        self.predicateEditor.rowTemplates.removeAll()
        let defaultPred = NSPredicate(format: defaultPredicate)
        self.predicateEditor.rowTemplates = self.predicateRowTemplates()
        print(self.predicateEditor.rowTemplates)
        print(defaultPred)
        self.predicateEditor.objectValue = defaultPred
    }

    @IBAction func generateQuery(_ sender:Any){
        self.queryTextField.stringValue = self.predicateEditor.predicate?.description ?? ""
    }


}

