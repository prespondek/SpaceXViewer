//
//  LaunchTypes.swift
//  SpaceXViewer
//
//  Created by Peter Respondek on 7/12/19.
//  Copyright © 2019 Peter Respondek. All rights reserved.
//

import RxDataSources

struct LaunchSection {
  var header: String
  var items: [Item]
}

extension LaunchSection: SectionModelType {
  typealias Item = Launch

   init(original: LaunchSection, items: [Item]) {
    self = original
    self.items = items
  }
}
