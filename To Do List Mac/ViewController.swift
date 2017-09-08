//
//  ViewController.swift
//  To Do List Mac
//
//  Created by JOHN KENNY on 05/09/2017.
//  Copyright © 2017 JOHN KENNY. All rights reserved.
//

import Cocoa

class ViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate {

    @IBOutlet var textInput: NSTextField!
    
    @IBOutlet var importantCheck: NSButton!
    
    
    @IBOutlet var tabView: NSTableView!
  
    
    @IBOutlet var deleteBtn: NSButton!
    
    
    var allitems : [ListItems] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getItems()
        
    }

    
    //get all items from core data
    func getItems(){
        //get items from core data
        
        //to get the core data from the app delegate
        if let ctx = (NSApplication.shared().delegate as? AppDelegate)?.persistentContainer.viewContext{
            //fetch data  //set items to clas property
            do{
                //adds all items into the array
                allitems = try ctx.fetch(ListItems.fetchRequest())
                
                print("amount \(allitems.count)")
                
            }catch{
                print (error)
            }
        }
        
        
        //update the table with the info from core data
        tabView.reloadData()
        
    }
    
    // MARK: - Tableview Stuff
    
    //matches the numer of rows in the table to the lenght of the array with our data
    func numberOfRows(in tableView: NSTableView) -> Int {
        return allitems.count
    }
    
    //put the data in the cells
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        //tableView.make(withIdentifier: "", owner: self)
        let item = allitems[row]
        
        if tableColumn?.identifier == "vipCol"{
            
            //important col
            if let cell = tableView.make(withIdentifier: "vipCell", owner: self) as? NSTableCellView{
                print(item.important)
                if item.important {
                    
                    cell.textField?.stringValue = "‼️"
                }else{
                    cell.textField?.stringValue = ""
                }
                return cell
            }
        }//to do name
        else{
            
            if let cell = tableView.make(withIdentifier: "toDoCell", owner: self) as? NSTableCellView{
                
                cell.textField?.stringValue = item.name!
                return cell
                
            }
        }
        
        return nil
    }
    
    
    //show delete button when item is clicked
    func tableViewSelectionDidChange(_ notification: Notification) {
        deleteBtn.isHidden = false
    }
    
    //when the add button is pressed
    @IBAction func addBtn(_ sender: Any) {
        print("test")
        if textInput.stringValue != ""{
            //to get the core data from the app delegate
            if let ctx = (NSApplication.shared().delegate as? AppDelegate)?.persistentContainer.viewContext{
                
                let item = ListItems(context: ctx)
                //add item
                item.name = textInput.stringValue
                if importantCheck.state == 0{
                    item.important = false
                }else{
                    item.important = true
                }
                //save to core data
                (NSApplication.shared().delegate as? AppDelegate)?.saveAction(nil)
                //clear text
                textInput.stringValue = ""
                //uncheck important
                importantCheck.state = 0
                
                //reget items
                getItems()
            }
            
        }
    }

    
    //to delete an item from core data
    @IBAction func deletePressed(_ sender: Any) {
        
        let selected =  allitems[tabView.selectedRow]
        
        if let ctx = (NSApplication.shared().delegate as? AppDelegate)?.persistentContainer.viewContext{
            ctx.delete(selected)
            
            //save to core data
            (NSApplication.shared().delegate as? AppDelegate)?.saveAction(nil)
            
            getItems()
            
            deleteBtn.isHidden = true
        }
        
    }

}

