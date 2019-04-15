//
//  EmojiListViewController.swift
//  Emoji Dictionary
//
//  Created by Denis Bystruev on 11/04/2019.
//  Copyright © 2019 Denis Bystruev. All rights reserved.
//

import UIKit

class EmojiListViewController: UITableViewController {
    
    let cellID = "EmojiCell"
    let configurator = TableViewCellConfigurator()
    var emojis = Emojis.loadSample()
    var deleteMode = false
    
    override func viewDidLoad() {
        navigationItem.title = emojis.title
        navigationItem.leftBarButtonItem = editButtonItem
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        if !editing {
            deleteMode.toggle()
        }
    }
}

// MARK: - Table View Data Source
extension EmojiListViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return emojis.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let emoji = emojis[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID) as! EmojiCell
        
        configurator.configure(cell, with: emoji)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedEmoji = emojis.remove(at: sourceIndexPath.row)
        emojis.insert(movedEmoji, at: destinationIndexPath.row)
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return deleteMode ? .delete : .insert
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            emojis.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        case .insert:
            let newEmoji = emojis[indexPath.row]
            emojis.insert(newEmoji, at: indexPath.row)
            tableView.insertRows(at: [indexPath], with: .automatic)
        default:
            break
        }
    }
}

// MARK: - Navigation
extension EmojiListViewController {
    @IBAction func unwind(segue: UIStoryboardSegue) {        
        guard segue.identifier == "SaveSegue" else { return }
        guard let controller = segue.source as? EmojiDetailViewController else { return }
        let emoji = controller.emoji
        print(#line, #function, emoji.symbol, emoji.name)
        
        let indexPath = IndexPath(row: emojis.count, section: 0)
        emojis.append(emoji)
        tableView.insertRows(at: [indexPath], with: .automatic)
    }
}
