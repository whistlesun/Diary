//
//  DiaryMonthDayCollectionViewController.swift
//  Diary
//
//  Created by kevinzhow on 15/3/6.
//  Copyright (c) 2015年 kevinzhow. All rights reserved.
//

import UIKit
import CoreData

let reuseMonthDayCellIdentifier = "MonthDayCollectionViewCell"

class DiaryMonthDayCollectionViewController: UICollectionViewController,UICollectionViewDelegateFlowLayout, UINavigationControllerDelegate {
    
    var diarys = [NSManagedObject]()
    
    var year:Int = 0
    
    var month:Int = 1
    
    var yearLabel:UILabel!
    
    var composeButton:UIButton!
    
    var fetchedResultsController : NSFetchedResultsController!
    
    var diarysGroupInMonth = [Int: Int]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        //Add year label
        
        yearLabel = DiaryLabel(fontname: "TpldKhangXiDictTrial", labelText: "二零一五年", fontSize: 16.0,lineHeight: 5.0)
        
        yearLabel.center = CGPointMake(screenRect.width - yearLabel.frame.size.width/2.0 - 15, 20 + yearLabel.frame.size.height/2.0 )
        
        self.view.addSubview(yearLabel)
        
        //Add compose button
        
        composeButton = diaryButtonWith(text: "撰",  fontSize: 14.0,  width: 26.0,  normalImageName: "Oval", highlightedImageName: "Oval_pressed")
        
        composeButton.center = CGPointMake(screenRect.width - yearLabel.frame.size.width/2.0 - 15, 35 + yearLabel.frame.size.height + 26.0/2.0)
        
        composeButton.addTarget(self, action: "newCompose", forControlEvents: UIControlEvents.TouchUpInside)
        
        
        self.view.addSubview(composeButton)
        //
        
        
        self.navigationController?.delegate = self
        //1
        let appDelegate =
        UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext!
        
        //2
        let fetchRequest = NSFetchRequest(entityName:"Diary")
        
        //        var beginDay = "01/01/\(year)"
        //        var endDay = "12/31/\(year)"
        //        var formatter = NSDateFormatter.new()
        //        formatter.dateFormat = "MM/dd/yyyy"
        //
        //        var beginDate = formatter.dateFromString(beginDay)
        //        var endDate = formatter.dateFromString(endDay)
        
        fetchRequest.predicate = NSPredicate(format: "year = \(year)")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "created_at", ascending: true)]
        
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
            managedObjectContext: managedContext, sectionNameKeyPath: "year",
            cacheName: nil)
        //3
        var error: NSError? = nil
        if (!fetchedResultsController.performFetch(&error)){
            println("Error: \(error?.localizedDescription)")
        }else{
            
            var fetchedResults = fetchedResultsController.fetchedObjects as! [NSManagedObject]
            if (fetchedResults.count == 0){
                NSLog("Present empty year")
            }else{
                diarys = fetchedResults
                for diary in diarys{
                    var diary = diary as! Diary
                    var date = diary.created_at
                    var components = NSCalendar.currentCalendar().component(NSCalendarUnit.CalendarUnitMonth, fromDate: date)
                    
                    if diarysGroupInMonth[components] == nil {
                        diarysGroupInMonth[components] = 1
                    }else{
                        diarysGroupInMonth[components] = diarysGroupInMonth[components]! + 1
                    }
                }
            }
        }
        
        var yearLayout = DiaryLayout.new()
        
        yearLayout.scrollDirection = UICollectionViewScrollDirection.Horizontal
        self.collectionView?.setCollectionViewLayout(yearLayout, animated: false)

        // Register cell classes
//        self.collectionView!.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseMonthDayCellIdentifier)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        //#warning Incomplete method implementation -- Return the number of sections
        return 0
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //#warning Incomplete method implementation -- Return the number of items in the section
        return 0
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseMonthDayCellIdentifier, forIndexPath: indexPath) as! UICollectionViewCell
    
        // Configure the cell
    
        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */

}