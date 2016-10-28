//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"



// HI!! I'M THE DELEGATE. I DON'T MAKE ANY SENSE SO JUST GFY FOR NOW (WINKY)
protocol TableViewDelegate: class {
    
    
    
    func TableViewCellFor(row: Int)
}



class TableView {
    
    // if we don't declare as weak then we will trigger a retain cycle
    weak var delegate: TableViewDelegate?
    
    func setupTableView() {
        delegate?.TableViewCellFor(row: 1)
    }
}


class MyCustomController: UIViewController, TableViewDelegate {
    
    let myTableView = TableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.myTableView.delegate = self
    }
    
    func TableViewCellFor(row: Int) {
        print("Here")
    }
    
}
