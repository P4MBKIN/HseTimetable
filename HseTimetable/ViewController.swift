//
//  ViewController.swift
//  HseTimetable
//
//  Created by Pavel on 19.04.2020.
//  Copyright © 2020 Hse. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(LessonsTableViewCell.self, forCellReuseIdentifier: LessonsTableViewCell.reuseId)
        tableView.register(EventsTableViewCell.self, forCellReuseIdentifier: EventsTableViewCell.reuseId)
        // Do any additional setup after loading the view.
    }
}

// MARK: - Table View Data Source
extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.row % 2 == 0) {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: LessonsTableViewCell.reuseId, for: indexPath) as? LessonsTableViewCell else {
                return UITableViewCell()
            }
            cell.set()
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: EventsTableViewCell.reuseId, for: indexPath) as? EventsTableViewCell else {
                return UITableViewCell()
            }
            return cell
        }
    }
}

// MARK: - Table View Delegate
extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath.row % 2 == 0) {
            return LessonsTableViewCell.cellHeight
        } else {
            return EventsTableViewCell.cellHeight
        }
    }
}
