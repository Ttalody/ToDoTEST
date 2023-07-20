//
//  TaskTableViewCell.swift
//  ToDo
//
//  Created by Artur on 13.07.23.
//

import UIKit

class TaskTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "TaskTableViewCell"

    @IBOutlet weak var cellLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    func configure(with task: TaskModel) {
        cellLabel.text = task.title
        if task.isDone {
            self.backgroundColor = .green
        } else {
            self.backgroundColor = .white
        }
    }
}
