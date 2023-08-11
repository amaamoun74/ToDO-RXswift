//
//  ViewController.swift
//  ToDo-RxSwift
//
//  Created by ahmed on 11/08/2023.
//

import UIKit
import RxSwift
import RxRelay

class TaskListViewController: UIViewController {
    private var filteredTasks = [Task]()
    @IBOutlet weak var prioritySegmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    private var disposeBag = DisposeBag()
    private var tasks = BehaviorRelay<[Task]>(value: [])
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func priorityValueChanged(segmentedControl: UISegmentedControl) {
        
        let priority = Priority(rawValue: segmentedControl.selectedSegmentIndex - 1)
        filterTasks(by: priority)
        
    }
}

extension TaskListViewController: UITableViewDelegate {}

extension TaskListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filteredTasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskTableViewCell", for: indexPath)
        cell.textLabel?.text = self.filteredTasks[indexPath.row].title
        return cell
    }
    
}
extension TaskListViewController {
    private func updateTableView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    private func filterTasks(by priority: Priority?) {
        
        if priority == nil {
           // self.filteredTasks = self.tasks.value
            self.updateTableView()
        } else {
            
            self.tasks.map { tasks in
                return tasks.filter { $0.priority == priority! }
                }.subscribe(onNext: { [weak self] tasks in
                    self?.filteredTasks = tasks
                    self?.updateTableView()
                }).disposed(by: disposeBag)
         
        }
        
    }
}
