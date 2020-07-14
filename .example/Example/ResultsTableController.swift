//
//  ResultsTableController.swift
//  Example
//
//  Created by Lorenzo Toscani De Col on 14/07/2020.
//

import UIKit

class ResultsTableController: UITableViewController {
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		tableView.rowHeight = 50
		tableView.tableFooterView = UIView()
		tableView.register(SimpleCell.self, forCellReuseIdentifier: SimpleCell.defaultReuseId)
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 50
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: SimpleCell.defaultReuseId, for: indexPath) as! SimpleCell
		cell.setup(with: "Row n\(indexPath.row + 1)")
		return cell
	}
}
