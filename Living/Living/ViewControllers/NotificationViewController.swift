//
//  NotificationViewController.swift
//  Living
//
//  Created by Nelson FB on 16/07/16.
//  Copyright © 2016 ar-smart. All rights reserved.
//

import UIKit
import DZNEmptyDataSet

class NotificationViewController: UIViewController,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate  {
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btn_back: UILabel!

    
    var actions = Actions()
    var theme = ThemeManager()
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh(_:)), for: UIControlEvents.valueChanged)
        
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()



        load_notifications()
        self.tableView.tableFooterView = UIView()
        self.tableView.addSubview(self.refreshControl)
        self.tableView.emptyDataSetSource = self
        self.tableView.emptyDataSetDelegate = self
        self.navigationController?.navigationBar.barTintColor = UIColor(theme.MainColor)
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        self.title = "Acciones"
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    func load_notifications(){
        
        actions.load(ArSmartApi.sharedApi.getToken(), hub: ArSmartApi.sharedApi.hub!.hid) { (IsError, result) in
            if(!IsError){
                self.tableView.reloadData()
                
                
            }
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        print(self.actions.actions.count)
        return self.actions.actions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        let cell:NotificationViewCell = tableView.dequeueReusableCell(withIdentifier: "cell")! as! NotificationViewCell



        let date = ArSmartUtils.ParseDate(self.actions.actions[(indexPath as NSIndexPath).row].created_at)
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "MMMM dd yyyy HH:mm"
 
        
        let convertedDateString = dateFormatter.string(from: date as Date)


        cell.lbl_date_text.text = convertedDateString
        cell.lbl_item_text.text = self.actions.actions[(indexPath as NSIndexPath).row].message
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath) {
        
        
    }
    func handleRefresh(_ refreshControl: UIRefreshControl) {
        
        
        self.tableView.reloadData()
        refreshControl.endRefreshing()
    }
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let str = "Notificaciones"
        let attrs = [NSFontAttributeName: UIFont.preferredFont(forTextStyle: UIFontTextStyle.headline)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let str = "No hay notificaciones registradas"
        let attrs = [NSFontAttributeName: UIFont.preferredFont(forTextStyle: UIFontTextStyle.body)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    

    


}
