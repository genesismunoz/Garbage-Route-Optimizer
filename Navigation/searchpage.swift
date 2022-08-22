//
//  searchpage.swift
//  Navigation
//
//
import UIKit
import Foundation
import SwiftUI

class tableContents{
    var binName: String?
    var capacity: String?

    
    init(List_bin_name:String, Bin_capacity:String) {
        self.binName = List_bin_name
        self.capacity = Bin_capacity

        
    }
}



class searchpage : UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet weak var buttonMap: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var actionslabel: UILabel!
    
    
    var binList = [tableContents]()
    override func viewDidLoad() {
        super.viewDidLoad()
        //Adding bins to the list
        let bin1 = tableContents(List_bin_name: "Bin 1" , Bin_capacity: "")
        binList.append(bin1)
        let bin2 = tableContents(List_bin_name: "Bin 2",Bin_capacity: "Assigned to you")
        binList.append(bin2)
        let bin3 = tableContents(List_bin_name: "Bin 3",Bin_capacity: "")
        binList.append(bin3)
        let bin4 = tableContents(List_bin_name: "Bin 4",Bin_capacity: "Assigned to you")
        binList.append(bin4)
        let bin5 = tableContents(List_bin_name: "Bin 5", Bin_capacity: "Assigned to you")
        binList.append(bin5)
        let bin6 = tableContents(List_bin_name: "Bin 6", Bin_capacity: "")
        binList.append(bin6)
        let bin7 = tableContents(List_bin_name: "Bin 7", Bin_capacity: "Assigned to you")
        binList.append(bin7)
        let bin8 = tableContents(List_bin_name: "Bin 8", Bin_capacity: "")
        binList.append(bin8)
        let bin9 = tableContents(List_bin_name: "Bin 9", Bin_capacity: "")
        binList.append(bin9)
        let bin10 = tableContents(List_bin_name: "Bin 10", Bin_capacity: "")
        binList.append(bin10)
        let bin11 = tableContents(List_bin_name: "Bin 11", Bin_capacity: "")
        binList.append(bin11)
        let bin12 = tableContents(List_bin_name: "Bin 12", Bin_capacity: "")
        binList.append(bin12)
        let bin13 = tableContents(List_bin_name: "Bin 13", Bin_capacity: "")
        binList.append(bin13)
        let bin14 = tableContents(List_bin_name: "Bin 14", Bin_capacity: "")
        binList.append(bin14)
        let bin15 = tableContents(List_bin_name: "Bin 15",Bin_capacity: "")
        binList.append(bin15)
        let bin16 = tableContents(List_bin_name: "Bin 16", Bin_capacity: "")
        binList.append(bin16)
        let bin17 = tableContents(List_bin_name: "Bin 17", Bin_capacity: "")
        binList.append(bin17)
        
        
        tableView.dataSource = self
        tableView.delegate = self
        
        
    }
    
    //from definition
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return binList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        var cell = tableView.dequeueReusableCell(withIdentifier: "bintable")
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "bintable")
        }
        cell?.textLabel?.text = binList[indexPath.row].binName
        cell?.detailTextLabel?.text = binList[indexPath.row].capacity
        cell?.textLabel?.textColor = UIColor.black
        if binList[indexPath.row].binName == "Bin 2"{
            cell?.textLabel?.textColor = UIColor.red
        }
        if binList[indexPath.row].binName == "Bin 4"{
            cell?.textLabel?.textColor = UIColor.red
        }
        if binList[indexPath.row].binName == "Bin 5"{
            cell?.textLabel?.textColor = UIColor.red
        }
        if binList[indexPath.row].binName == "Bin 7"{
            cell?.textLabel?.textColor = UIColor.red
        }
        if binList[indexPath.row].binName == "Bin 9"{
            cell?.textLabel?.textColor = UIColor.red
        }
        if binList[indexPath.row].binName == "Bin 11"{
            cell?.textLabel?.textColor = UIColor.red
        }
        if binList[indexPath.row].binName == "Bin 16"{
            cell?.textLabel?.textColor = UIColor.red
        }
    
        
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

}
