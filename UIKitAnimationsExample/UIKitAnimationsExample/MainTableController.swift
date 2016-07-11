//
//  MainTableController.swift
//  UIKitAnimationsExample
//
//  Created by Ildar Zalyalov on 11.07.16.
//  Copyright © 2016 com.flatstack. All rights reserved.
//

import Foundation
import UIKit

enum Identifiers: String {
    case Base = "base"
    case PropertyAnimator = "propertyAnim"
    case SpringAnimation = "spring"
}

class MainTableController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var variants:Array<String>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        variants = ["Base animation","Property Animator","Spring Animation"]
        
    }
    
    
}

//MARK: - TableView Delegate, DataSource
extension MainTableController: UITableViewDelegate, UITableViewDataSource{
    
    private func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.variants?.count)!;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "cell"
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        
        cell.textLabel?.text = self.variants[indexPath.row]
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let storyBoard: UIStoryboard = UIStoryboard(name: "AnimationStoryBoard", bundle: nil) else {return}
        var vc: UIViewController
        
        switch indexPath.row {
        case 0: vc = storyBoard.instantiateViewController(withIdentifier: Identifiers.Base.rawValue)
        case 1: vc = storyBoard.instantiateViewController(withIdentifier: Identifiers.PropertyAnimator.rawValue)
        case 2: vc = storyBoard.instantiateViewController(withIdentifier: Identifiers.SpringAnimation.rawValue)
        default: return
        }
        
        self.tableView.deselectRow(at: indexPath, animated: true)
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
}
