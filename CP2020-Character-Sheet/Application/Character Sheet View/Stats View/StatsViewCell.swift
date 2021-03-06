//
//  StatsViewCell.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 11/24/18.
//  Copyright © 2018 Ken Krzeminski. All rights reserved.
//

import UIKit

final class StatsViewCell: UICollectionViewCell {
    private var statViews = [StatView]()
    private var model: StatsViewCellModel?
    
    func setup(with viewModel: StatsViewCellModel, statViewModels: [StatViewModel]) {
        model = viewModel        
        contentView.layoutMargins = UIEdgeInsets(top: self.frame.height * viewModel.paddingRatio,
                                                 left: self.frame.width * viewModel.paddingRatio,
                                                 bottom: self.frame.height * viewModel.paddingRatio,
                                                 right: self.frame.width * viewModel.paddingRatio)
        var statViewModels = statViewModels.reversed().map({ $0 })
        var rows = [[StatViewModel]]()
        let rowCount: Int = {
            return statViewModels.count / viewModel.statsPerRow + ((statViewModels.count % viewModel.statsPerRow > 0) ? 1 : 0)
        }()
        
        // Divvy up the view models into their rows
        for _ in 1...rowCount {
            var currentRow = [StatViewModel]()
            for _ in 1...viewModel.statsPerRow {
                guard !statViewModels.isEmpty else { break }
                if let nextModel = statViewModels.popLast() {
                    currentRow.append(nextModel)
                }
            }
            rows.append(currentRow)
        }
        
        // Assemble the rows
        
        var topAnchor = contentView.layoutMarginsGuide.topAnchor
        var leadingAnchor = contentView.layoutMarginsGuide.leadingAnchor
        let width = contentView.layoutMarginsGuide.layoutFrame.width * viewModel.statViewWidthRatio
        let height = contentView.layoutMarginsGuide.layoutFrame.height * (1.0 / CGFloat(rows.count))
        var frame = CGRect(x: contentView.layoutMarginsGuide.layoutFrame.minX,
                           y: contentView.layoutMarginsGuide.layoutFrame.minY,
                           width: width,
                           height: height)
        
        rows.enumerated().forEach { rowIndex, row in
            row.enumerated().forEach { modelIndex, model in
                let statView = StatView(frame: frame, viewModel: model)
                contentView.addSubview(statView)
                
                NSLayoutConstraint.activate([
                    statView.widthAnchor.constraint(equalToConstant: width),
                    statView.heightAnchor.constraint(equalToConstant: height),
                    statView.leadingAnchor.constraint(equalTo: leadingAnchor),
                    statView.topAnchor.constraint(equalTo: topAnchor)
                    ])
                
                statViews.append(statView)
                
                // Set up the frame and leading anchor for the next stat view
                frame = CGRect(x: width * CGFloat(modelIndex + 1),
                               y: height * CGFloat(rowIndex + 1),
                               width: width,
                               height: height)
                leadingAnchor = statView.trailingAnchor
            }
            
            // Set up parameters for next row
            if let nextTopAnchor = statViews.last?.bottomAnchor  {
                topAnchor = nextTopAnchor
                leadingAnchor = contentView.layoutMarginsGuide.leadingAnchor
                frame = CGRect(x: contentView.layoutMarginsGuide.layoutFrame.minX,
                               y: height * CGFloat(rowIndex + 1),
                               width: width,
                               height: height)
            }
        }
                
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.backgroundColor = StyleConstants.Color.light
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("This initializer is not supported.")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        fatalError("Interface Builder is not supported!")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        // TODO: Test cell re-use and see if it needs anything here
    }
}
