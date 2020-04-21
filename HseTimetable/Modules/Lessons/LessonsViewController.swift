//
//  LessonsViewController.swift
//  HseTimetable
//
//  Created by Pavel on 21.04.2020.
//  Copyright © 2020 Hse. All rights reserved.
//

import RxSwift
import RxCocoa
import UIKit

final class LessonsViewController: UIViewController, LessonsViewProtocol {
    
    @IBOutlet weak var lessonsTableView: UITableView!
    var refreshControl: UIRefreshControl?
    
    var presenter: LessonsPresenterProtocol!
    let configurator: LessonsConfiguratorProtocol = LessonsConfigurator()
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configurator.configure(with: self)
        setup()
    }
    
    private func setup() {
        self.lessonsTableView.register(LessonsTableViewCell.self, forCellReuseIdentifier: LessonsTableViewCell.reuseId)
        self.lessonsTableView.register(EventsTableViewCell.self, forCellReuseIdentifier: EventsTableViewCell.reuseId)
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.addTarget(self, action: #selector(refreshControlValueChanged(sender:)), for: .valueChanged)
        self.lessonsTableView.refreshControl = refreshControl
        
        // News received
        self.presenter.outputs.lessons.asObservable()
            .observeOn(MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] _ in
                self?.lessonsTableView.reloadData()
                self?.refreshControl?.endRefreshing()
            })
            .disposed(by: disposeBag)
        
        // Error received
        self.presenter.outputs.error
            .observeOn(MainScheduler.asyncInstance)
            .subscribe(onNext: { error in
                let alert = UIAlertController(title: "Error", message: String(describing: error), preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                self.present(alert, animated: true)
            })
            .disposed(by: disposeBag)
        
        // First view load
        self.presenter.inputs.viewDidLoadTrigger.onNext(())
    }
    
    @objc private func refreshControlValueChanged(sender: UIRefreshControl) {
        self.presenter.inputs.refreshControlTrigger.onNext(())
    }
}

// MARK: - Table View Data Source
extension LessonsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard self.presenter.outputs.opens.indices.contains(section) else { return 0 }
        return self.presenter.outputs.opens[section] ? 2 : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard self.presenter.outputs.lessons.value.indices.contains(indexPath.section) else { return UITableViewCell() }
        if indexPath.row == 0 {
            let cell = self.lessonsTableView.dequeueReusableCell(withIdentifier: LessonsTableViewCell.reuseId) as? LessonsTableViewCell
            guard let lessonsCell = cell else { return UITableViewCell() }
            lessonsCell.setup(lesson: self.presenter.outputs.lessons.value[indexPath.section])
            return lessonsCell
        } else {
            let cell = self.lessonsTableView.dequeueReusableCell(withIdentifier: EventsTableViewCell.reuseId) as? EventsTableViewCell
            guard let eventsCell = cell else { return UITableViewCell() }
            eventsCell.setup(lesson: self.presenter.outputs.lessons.value[indexPath.section])
            return eventsCell
        }
    }
}

// MARK: - Table View Delegate
extension LessonsViewController: UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.presenter.outputs.lessons.value.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard self.presenter.outputs.lessons.value.indices.contains(indexPath.section) else { return 0 }
        if indexPath.row == 0 { return LessonsTableViewCell.cellHeight }
        else { return EventsTableViewCell.cellHeight }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard self.presenter.outputs.opens.indices.contains(indexPath.section) else { return }
        if self.presenter.outputs.opens[indexPath.section] == true {
            self.presenter.outputs.opens[indexPath.section] = false
        } else {
            self.presenter.outputs.opens[indexPath.section] = true
        }
        let sections = IndexSet.init(integer: indexPath.section)
        self.lessonsTableView.reloadSections(sections, with: .none)
    }
}
