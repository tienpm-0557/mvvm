//
//  HeaderFooterListPage.swift
//  MVVMExample
//
//  Created by pham.minh.tien on 5/16/20.
//  Copyright © 2020 Sun*. All rights reserved.
//

import UIKit

class HeaderFooterListPage: SectionListPage {
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func setupTableView(_ tableView: UITableView) {
        super.setupTableView(tableView)
        tableView.register(footerType: SectionFooterListView.self)
    }

    override func footerIdentifier(_ footerViewModel: Any, _ returnClassName: Bool = false) -> String? {
        return returnClassName ? SectionFooterListView.className : SectionFooterListView.identifier
    }
}
