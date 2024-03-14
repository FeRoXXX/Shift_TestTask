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
    var goToNote: ((_: UUID) -> Void)?
    
    var presenter : ListOfNotesPresenterProtocol!
    var cellItem : [NoteModel]?
    var firstOpen : Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupTableView()
        presenter.loadView(controller: self, view: self)
    }

    override func viewDidAppear(_ animated: Bool) {
        if !firstOpen {
            presenter.viewOpen()
        }
        firstOpen = false
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
              !cellItem.isEmpty else { return 0 }
        return cellItem.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cellItem = cellItem,
              !cellItem.isEmpty else { return UITableViewCell() }
        let cell = UITableViewCell()
        var cellStyle = cell.defaultContentConfiguration()
        cellStyle.textProperties.numberOfLines = 1
        cellStyle.secondaryTextProperties.numberOfLines = 1
        let strings = cellItem[indexPath.row].text.string.findTitleAndText()
        cellStyle.text = strings.title
        
        if let text = strings.text {
            cellStyle.secondaryText = text
        } else {
            cellStyle.secondaryText = "Нет дополнительного текста"
        }
        cell.contentConfiguration = cellStyle
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cellItem = cellItem,
              let id = cellItem[indexPath.row].id else { return }
        self.goToNote?(id)
    }
    
    func updateTableData(data: [NoteModel]?) {
        self.cellItem = data
        tableOfNotes.reloadData()
    }
    
}
