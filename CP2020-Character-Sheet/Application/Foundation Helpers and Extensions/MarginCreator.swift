//
//  MarginCreator.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 12/15/18.
//  Copyright © 2018 Ken Krzeminski. All rights reserved.
//

import UIKit

protocol MarginCreator {
    
    /// Percentage of the view to apply padding to. Note: This is the padding for EACH side.
    /// i.e. If you supply a padding of 0.1, the top, bottom, left, and right will each be inset by
    /// 10% of the view width and height (depending on axis)
    var paddingRatio: CGFloat { get }
    
    
    /// Creates NSDirectionalEdgeInsets by uniformily applying the padding ratio across all edges.
    ///
    /// - Parameter frame: The frame on which the padding will be added to
    /// - Returns: NSDirectionalEdgeInsets for the padding/margins/insets/whatever
    func createInsets(with frame: CGRect) -> NSDirectionalEdgeInsets
}

extension MarginCreator {
    
    func createInsets(with frame: CGRect) -> NSDirectionalEdgeInsets {
        return NSDirectionalEdgeInsets(top: frame.height * paddingRatio,
                                       leading: frame.width * paddingRatio,
                                       bottom: frame.height * paddingRatio,
                                       trailing: frame.width * paddingRatio)
    }
}
