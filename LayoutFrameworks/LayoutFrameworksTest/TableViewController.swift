//
//  TableViewController.swift
//  LayoutFrameworksTest
//
//  Created by Nikita Fomin on 11.08.15.
//  Copyright (c) 2015 Nikita Fomin. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1 {
            return "SnapKit"
        } else if section == 2 {
            return "PureLayout"
        } else {
            return "Apple"
        }
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 6
        } else if section == 1 {
            return 4
        } else {
            return 1
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as! UITableViewCell
        
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                cell.textLabel?.text = "first"
            case 1:
                cell.textLabel?.text = "second"
            case 2:
                cell.textLabel?.text = "thrid"
            case 3:
                cell.textLabel?.text = "fourth"
            case 4:
                cell.textLabel?.text = "five"
            case 5:
                cell.textLabel?.text = "six"
            default:
                break
            }
        } else if indexPath.section == 1 {
            switch indexPath.row {
            case 0:
                cell.textLabel?.text = "first"
            case 1:
                cell.textLabel?.text = "second"
            case 2:
                cell.textLabel?.text = "thrid"
            case 3:
                cell.textLabel?.text = "fourth"
            default:
                break
            }
        } else {
            switch indexPath.row {
            case 0:
                cell.textLabel?.text = "first"
            default:
                break
            }
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        var viewController: UIViewController?
        
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                viewController = FirstCenterViewController()
            case 1:
                viewController = SecondViewController()
            case 2:
                viewController = ThirdViewController()
            case 3:
                viewController = FourthViewController()
            case 4:
                viewController = FiveViewController()
            case 5:
                viewController = SixViewController()
            default:
                break
            }
        } else if indexPath.section == 1 {
            switch indexPath.row {
            case 0:
                viewController = FirstSnapViewController()
            case 1:
                viewController = SecondSnapViewController()
            case 2:
                viewController = ThridSnapViewController()
            case 3:
                viewController = FourthSnapViewController()
            default:
                break
            }
        } else if indexPath.section == 2 {
            switch indexPath.row {
            case 0:
                viewController = FirstVisualViewController()
            default:
                break
            }
        }
        
        if let controller = viewController {
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
