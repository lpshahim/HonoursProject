//
//  TableViewControllerTest.swift
//  MobileDoctor
//
//  Created by Louis-Philip Shahim on 04/09/2015.
//  Copyright (c) 2015 Louis-Philip Shahim. All rights reserved.
//

import UIKit
import Parse
import Bolts


class TableViewControllerTest: PFQueryTableViewController {
    // Define the query that will provide the data for the table view
    override func queryForTable() -> PFQuery {
        var query = PFQuery(className: "Countries")
        query.orderByAscending("nameEnglish")
        return query
    }
    // Initialise the PFQueryTable tableview
    override init(style: UITableViewStyle, className: String!) {
        super.init(style: style, className: className)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // Configure the PFQueryTableView
        self.parseClassName = "Patients"
        self.textKey = "p_name"
        self.pullToRefreshEnabled = true
        self.paginationEnabled = false
    }
   
}
