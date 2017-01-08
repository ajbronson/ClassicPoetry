//
//  SlaveTableViewController.swift
//  ClassicPoetry
//
//  Created by AJ Bronson on 1/7/17.
//  Copyright © 2017 AJ Bronson. All rights reserved.
//

import UIKit

class SlaveTableViewController: UITableViewController, ChangeStar {
    
    var showHints = false
    var books: [Book]?
    var isInStarMode = false
    var starColor: Star.Color?
    var starCanonIDs:[Int] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.toolbar.isHidden = false
        if books?.count == 0 {
            _ = navigationController?.popViewController(animated: true)
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        if isInStarMode {
            return Array(Set(starCanonIDs)).count
        } else {
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isInStarMode {
            var count = 0
            let singleCanonIDs = (Array(Set(starCanonIDs)))
            let sortedIDs = singleCanonIDs.sorted{$0 < $1}
            
            for item in starCanonIDs {
                if item == sortedIDs[section] {
                    count += 1
                }
            }
            
            return count
        } else {
            return books?.count ?? 0
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if isInStarMode {
            let singleCanonIDs = (Array(Set(starCanonIDs)))
            let sortedIDs = singleCanonIDs.sorted{$0 < $1}
            return FileController.shared.volumeNameForID(id: sortedIDs[section])
        }
        return nil
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let books = books else { return UITableViewCell() }
        
        if isInStarMode {
            let singleCanonIDs = (Array(Set(starCanonIDs)))
            let sortedIDs = singleCanonIDs.sorted{$0 < $1}
            let filteredBooks = books.filter({$0.canonID == sortedIDs[indexPath.section]})
            if showHints {
                if let cell = tableView.dequeueReusableCell(withIdentifier: "slaveCell") as? SlaveTableViewCell {
                    cell.updateWith(book: filteredBooks[indexPath.row], isInStarMode: isInStarMode)
                    cell.delegate = self
                    return cell
                }
            } else {
                if let cell = tableView.dequeueReusableCell(withIdentifier: "slaveCellNoHint") as? SlaveTableViewCellNoHint {
                    cell.updateWith(book: filteredBooks[indexPath.row], isInStarMode: isInStarMode)
                    cell.delegate = self
                    return cell
                }
            }
        } else {
            if showHints {
                if let cell = tableView.dequeueReusableCell(withIdentifier: "slaveCell") as? SlaveTableViewCell {
                    cell.updateWith(book: books[indexPath.row], isInStarMode: isInStarMode)
                    cell.delegate = self
                    return cell
                }
            } else {
                if let cell = tableView.dequeueReusableCell(withIdentifier: "slaveCellNoHint") as? SlaveTableViewCellNoHint {
                    cell.updateWith(book: books[indexPath.row], isInStarMode: isInStarMode)
                    cell.delegate = self
                    return cell
                }
            }
        }
        return UITableViewCell()
    }
    
    func updateSlave(volume: Volume) {
        self.title = volume.name
        self.books = FileController.shared.book(volumeID: volume.id)
        isInStarMode = false
    }
    
    func updateSlaveFromStar(books: [Book], title: String, starColor: Star.Color) {
        self.books = books
        self.title = title
        isInStarMode = true
        self.starColor = starColor
        organizeBooks()
    }
    
    func shouldChangeStar(sender: UITableViewCell, starMode: Bool) {
        if let indexPath = tableView.indexPath(for: sender),
            let books = books {
            if starMode {
                let singleCanonIDs = (Array(Set(starCanonIDs)))
                let sortedIDs = singleCanonIDs.sorted{$0 < $1}
                let filteredBooks = books.filter({$0.canonID == sortedIDs[indexPath.section]})
                let book = filteredBooks[indexPath.row]
                if let indexPathToRemove = books.index(of: book) {
                    self.books?.remove(at: indexPathToRemove)
                    organizeBooks()
                    tableView.beginUpdates()
                    tableView.deleteRows(at: [indexPath], with: .fade)
                    
                    if filteredBooks.count == 1 {
                        var sectionPath = IndexSet()
                        sectionPath.insert(indexPath.section)
                        tableView.deleteSections(sectionPath, with: .fade)
                    }
                    
                    tableView.endUpdates()
                    if self.books?.count == 0 {
                        DispatchQueue.global().async {
                            sleep(1)
                            DispatchQueue.main.async {
                                _ = self.navigationController?.popViewController(animated: true)
                            }
                        }
                    }
                }
            } else {
                tableView.reloadRows(at: [indexPath], with: .right)
            }
        }
    }
    
    func reloadTableView(book: Book, shouldRemove: Bool) {
        if let index = books?.index(of:book),
            shouldRemove {
            self.books?.remove(at: index)
        }
        organizeBooks()
        tableView.reloadData()
    }
    
    func organizeBooks() {
        guard let books = books else { return }
        let sortedBooks = books.sorted{$0.canonID < $1.canonID}
        self.books = sortedBooks
        starCanonIDs = sortedBooks.flatMap({$0.canonID})
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toTabBar" {
            if let tabController = segue.destination as? TextTabBar,
                let indexPath = tableView.indexPathForSelectedRow,
                let books = books {
                if isInStarMode {
                    let singleCanonIDs = (Array(Set(starCanonIDs)))
                    let sortedIDs = singleCanonIDs.sorted{$0 < $1}
                    let filteredBooks = books.filter({$0.canonID == sortedIDs[indexPath.section]})
                    tabController.updateWith(book: filteredBooks[indexPath.row], books: books, view: self, originalStar: starColor, isInStarMode: isInStarMode)
                } else {
                    tabController.updateWith(book: books[indexPath.row], books: books, view: self, originalStar: starColor, isInStarMode: isInStarMode)
                }
            }
        } else if segue.identifier == "toCollectionView" {
            if let collectionVC = segue.destination as? SlaveCollectionViewController,
                let books = books {
                collectionVC.updateWith(books: books, title: self.title, starMode: isInStarMode)
            }
        }
    }
    
    @IBAction func hintButtonTapped(_ sender: UIBarButtonItem) {
        sender.title = showHints ? "Show Hints" : "Hide Hints"
        showHints = !showHints
        tableView.reloadData()
    }
}

protocol ChangeStar {
    func shouldChangeStar(sender: UITableViewCell, starMode: Bool)
}
