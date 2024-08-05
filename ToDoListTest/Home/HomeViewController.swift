//
//  HomeViewController.swift
//  ToDoListTest
//
//  Created by Константин Евсюков on 03.08.2024.
//

import UIKit
import SnapKit
import FirebaseFirestore
import Reachability

class HomeViewController: UIViewController {
    
    private let listTableView = UITableView()
    let db = Firestore.firestore()
    var reachability: Reachability?
    
    var lists: [ListModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    deinit {
        reachability?.stopNotifier()
    }
}

//MARK: Setup UI
private extension HomeViewController {
    
    func setupUI() {
        setupNavigationBar()
        setupTableView()
        fetchTasks()
    }
    
    func setupNavigationBar() {
        self.navigationItem.title = "Задачи"
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        
        let closeButton = UIBarButtonItem(title: "Выйти", style: .plain, target: self, action: #selector(closeButtonTaped))
        let addButton = UIBarButtonItem(image: UIImage(systemName: "plus.app"), style: .plain, target: self, action: #selector(addButtonTaped))
        let buttonColor = UIColor.black
        closeButton.tintColor = buttonColor
        addButton.tintColor = buttonColor
        
        appearance.backgroundColor = .white
        self.navigationController?.navigationBar.standardAppearance = appearance
        self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
        self.navigationController?.navigationBar.compactAppearance = appearance
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "person.circle"), style: .plain, target: self, action: #selector(userButtonTaped))
        self.navigationItem.leftBarButtonItem?.tintColor = .black
        self.navigationItem.setRightBarButtonItems([addButton, closeButton], animated: true)
    }
    
    func setupTableView() {
        listTableView.register(HomeTableViewCell.self, forCellReuseIdentifier: HomeTableViewCell.identifier)
        listTableView.separatorStyle = .none
        listTableView.delegate = self
        listTableView.dataSource = self
        
        view.addSubview(listTableView)
        
        listTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    @objc func userButtonTaped() {
        
    }
    
    @objc func closeButtonTaped() {
        AuthService.shared.signOut { [weak self] error in
            guard let self = self else { return }
            
            if let error = error {
                AlertManager.showCloseError(on: self, with: error)
                return
            }
            
            if let sceneDelegete = self.view.window?.windowScene?.delegate as? SceneDelegate {
                sceneDelegete.checkAuthentication()
            }
        }
    }
}

//MARK: Check connection
private extension HomeViewController {
    
    func setupReachability() {
        reachability = try? Reachability()
        
        reachability?.whenReachable = { reachability in
            if reachability.connection == .wifi {
                print("Подключен через Wi-Fi")
            } else {
                print("Подключен через сотовую связь")
            }
        }
        
        reachability?.whenUnreachable = { _ in
            self.showNoInternetAlert()
        }
        
        do {
            try reachability?.startNotifier()
        } catch {
            print("Не удается выслать уведомление")
        }
    }
    
    func showNoInternetAlert() {
        let alertController = UIAlertController(title: "Нет подключения", message: "Проверьте ваше интернет-соединение", preferredStyle: .alert)
        let actionOK = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(actionOK)
        
        DispatchQueue.main.async {
            self.present(alertController, animated: true)
        }
    }
}

//MARK: Add and Check Tasks
private extension HomeViewController {
    
    @objc func addButtonTaped() {
        let allertController = UIAlertController(title: "Новая задача", message: "Что планируете сделать?", preferredStyle: .alert)
        allertController.addTextField { _ in }
        
        let actionCancel = UIAlertAction.init(title: "Отмена", style: .cancel)
        let actionAdd = UIAlertAction(title: "Добавить", style: .default) { [weak self] _ in
            guard let self = self, let textField = allertController.textFields?.first, let text = textField.text, !text.isEmpty else { return }
            
            self.addTask(title: text)
        }
        
        [actionAdd, actionCancel].forEach {
            allertController.addAction($0)
        }
        
        present(allertController, animated: true)
    }
    
    func addTask(title: String) {
        guard reachability?.connection != .unavailable else {
            showNoInternetAlert()
            return
        }
        
        let newTask = db.collection("tasks")
            .document()
        let dateCompletion = Date().addingTimeInterval(24 * 60 * 60)
        newTask.setData([
            "title": title,
            "id": newTask.documentID,
            "dateCompletion": dateCompletion
        ]) { error in
            if let error = error {
                AlertManager.showAddTaskError(on: self, with: error)
            } else {
                print("Документ добавлен с Id: \(newTask.documentID)")
                self.fetchTasks()
            }
        }
    }
    
    func fetchTasks() {
        guard reachability?.connection != .unavailable else {
            showNoInternetAlert()
            return
        }
        
        db.collection("tasks").getDocuments { [weak self] snapshot, error in
            guard let self = self else { return }
            
            if let error = error {
                AlertManager.showFetchTaskError(on: self, with: error)
            } else {
                self.lists = snapshot?.documents.compactMap { document in
                    guard let title = document.data()["title"] as? String,
                          let id = document.data()["id"] as? String,
                          let dateTimestampCompletion = document.data()["dateCompletion"] as? Timestamp else { return nil }
                    
                    let dateCompletion = dateTimestampCompletion.dateValue()
                    return ListModel(title: title, id: id, dateCompletion: dateCompletion)
                } ?? []
                DispatchQueue.main.async {
                    self.listTableView.reloadData()
                }
            }
        }
    }
    
    func checkUpcomingTasks() {
        let upcomingTasks = lists.filter { task in
            if let dateCompletion = task.dateCompletion {
                return dateCompletion.timeIntervalSinceNow < 24 * 60 * 60
            }
            return false
        }
        
        if !upcomingTasks.isEmpty {
            let upcomingTaskTitles = upcomingTasks.map { $0.title }.joined(separator: ", ")
            print("Upcoming tasks: \(upcomingTaskTitles)")
            
            let alertController = UIAlertController(title: "Приближаются задачи", message: "Близко к выполнению: \(upcomingTaskTitles)", preferredStyle: .alert)
            let actionOK = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(actionOK)
            
            present(alertController, animated: true)
        }
    }
}

//MARK: Edit Task
private extension HomeViewController {
    
    @objc func editButtonTapped() {
        listTableView.setEditing(!listTableView.isEditing, animated: true)
    }
    
    func editTask(task: ListModel, newTitle: String) {
        db.collection("tasks").document(task.id).updateData([
            "title": newTitle
        ]) { error in
            if let error = error {
                AlertManager.showEditTaskError(on: self, with: error)
            } else {
                self.fetchTasks()
            }
        }
    }
    
    func showEditAlert(for task: ListModel) {
        let alertController = UIAlertController(title: "Редактировать задачу", message: "Измените задачу", preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.text = task.title
        }
        
        let actionCancel = UIAlertAction(title: "Отмена", style: .cancel)
        let actionSave = UIAlertAction(title: "Сохранить", style: .default) { [weak self] _ in
            guard let self = self,
                  let textField = alertController.textFields?.first,
                  let newText = textField.text,
                  !newText.isEmpty else { return }
            
            self.editTask(task: task, newTitle: newText)
        }
        
        [actionCancel, actionSave].forEach {
            alertController.addAction($0)
        }
        
        present(alertController, animated: true)
    }
}

//MARK: Delete Tasks
private extension HomeViewController {
    
    func deleteTask(task: ListModel, completion: @escaping (Bool) -> Void) {
        db.collection("tasks").document(task.id).delete { error in
            if let error = error {
                AlertManager.showDeleteTaskError(on: self, with: error)
                completion(false)
            } else {
                print("Задача успешно удалена")
                completion(true)
            }
        }
    }
}

//MARK: HomeTableViewCellDelegate
extension HomeViewController: HomeTableViewCellDelegate {
    
    func didTapCheckButton(on cell: HomeTableViewCell) {
        guard let indexPatch = listTableView.indexPath(for: cell) else { return }
        checkUpcomingTasks()
    }
}

//MARK: UITableViewDelegate, UITableViewDataSource
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeTableViewCell.identifier, for: indexPath) as? HomeTableViewCell else { return UITableViewCell() }
        
        cell.configure(list: lists[indexPath.row])
        cell.selectionStyle = .none
        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let task = lists[indexPath.row]
            deleteTask(task: task) { [weak self] success in
                guard let self = self else { return }
                if success {
                    self.lists.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                } else {
                    print("Ошибка удаления задачи")
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let task = lists[indexPath.row]
        showEditAlert(for: task)
    }
}
