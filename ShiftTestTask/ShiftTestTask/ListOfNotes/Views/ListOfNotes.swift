//
//  ListOfNotes.swift
//  ShiftTestTask
//
//  Created by Александр Федоткин on 11.03.2024.
//

import UIKit

class ListOfNotes: UIViewController {
    @IBOutlet weak var tableOfNotes: UITableView!
    
    var goToAddNote: (() -> Void)?
    var goToNote: (() -> Void)?
    
    var presenter : ListOfNotesPresenterProtocol!
    var cellItem : [NoteModel]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupTableView()
    }

}
private extension ListOfNotes {
    private func setupNavigationBar() {
        self.title = "Заметки"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"),
                                                                                 style: .plain,
                                                                                 target: self,
                                                                                 action: #selector(toAddNoteClicked))
    }
    
    @objc func toAddNoteClicked() {
        self.goToAddNote?()
    }
}

extension ListOfNotes : UITableViewDelegate, UITableViewDataSource, ListOfNotesProtocol {

    func setupTableView() {
        tableOfNotes.dataSource = self
        tableOfNotes.delegate = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let cellItem = cellItem,
              !cellItem.isEmpty else { return 0}
        return cellItem.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cellItem = cellItem,
              !cellItem.isEmpty else { return UITableViewCell() }
        let cell = UITableViewCell()
        var cellStyle = cell.defaultContentConfiguration()
        cellStyle.text = "123"
        cell.contentConfiguration = cellStyle
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.goToNote?()
    }
    
}
