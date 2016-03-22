//
//  XWExampleVC.swift
//  XWSwiftRefresh
//
//  Created by Xiong Wei on 15/10/7.
//  Copyright © 2015年 Xiong Wei. All rights reserved.
//  简书：猫爪


import UIKit


struct exampleModel {
    var header:String
    var title:Array<String>
    var methods:Array<String>
    var vc:XWDisplayTableViewController
    
    mutating func prepare(title:String, method:String){
        vc.title = title
        vc.method = method
    }
}

let exampleHeaderTitle00 = "UITableView + 上拉下拉刷新"
let exampleHeaderTitle01 = "UITableView + 上拉刷新gif"



class XWExampleVC: UITableViewController {
    
    
    private lazy var exampleModels:Array<exampleModel> = {
       
        let example1 = exampleModel(header: exampleHeaderTitle00, title: ["默认"], methods: ["example001"], vc: XWDisplayTableViewController())
        
        let example2 = exampleModel(header: exampleHeaderTitle01, title: ["GIf"], methods: ["example011"], vc: XWDisplayTableViewController())
        
       
        
        return [example1,example2]
    }()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
//        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "background"), forBarMetrics: UIBarMetrics.Default)
        self.title = "演示"
        self.tableView.tableFooterView = UIView()
    }

    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.exampleModels.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("exampleCellIdentitiy", forIndexPath: indexPath)
        
        let exampleModel = self.exampleModels[indexPath.row]
        
        cell.textLabel?.text = exampleModel.header
        
        cell.detailTextLabel?.text = String(exampleModel.title)
        
        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        var example = self.exampleModels[indexPath.row]
        example.prepare(example.header, method: example.methods[0])
        self.navigationController?.pushViewController(example.vc, animated: true)
    }

}
