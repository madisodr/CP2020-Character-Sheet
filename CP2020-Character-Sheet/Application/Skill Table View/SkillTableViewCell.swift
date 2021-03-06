//
//  SkillTableViewCell.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 12/20/18.
//  Copyright © 2018 Ken Krzeminski. All rights reserved.
//

import UIKit

/// Custom UITableViewCell which shows a skill listing in unlabeled columns.
final class SkillTableViewCell: UITableViewCell {
    
    // MARK: Fields for the cell
    
    private var name: UILabel?
    private var points: UILabel?
    private var modifier: UILabel?
    private var total: UILabel?
    
    private var viewModel: SkillTableViewCellModel?
    private var skillListing: SkillListing?
    
    /// Used to indicate that firstTimeSetup has been called by layoutSubViews()
    private var cellHasBeenSetup = false
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.autoresizingMask = UIView.AutoresizingMask.flexibleHeight
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Sets up the view with the SkillListing provided. This function is intended for first-time setup.
    /// Use this as as second-stage initializer after creating the cell in a table view with a reuse identifier.
    ///
    /// - Parameters:
    ///   - skillListing: SkillListing corresponding with the table view cell
    ///   - viewModel: The cell's view model
    func prepareForFirstTimeSetup(with skillListing: SkillListing, viewModel: SkillTableViewCellModel) {
        self.viewModel = viewModel
        self.skillListing = skillListing
    }
    
    /// Updates the skill listing. This can be called at any time to change the values displayed.
    ///
    /// - Parameter skillListing: The skill listing to display
    func update(skillListing: SkillListing) {
        self.skillListing = skillListing
        updateColumnValues()
    }
    
    /// Update the skill listing for the table view.
    private func updateColumnValues() {
        guard let viewModel = viewModel, let skillListing = skillListing else { return }
        
        var name = skillListing.skill.name
        
        if let nameExtension = skillListing.skill.nameExtension {
            name = "\(name): \(nameExtension)"
        }
        
        self.name?.text = name
        self.name?.font = viewModel.nameFont
        self.name?.textAlignment = .left
        self.name?.fitTextToBounds(maximumSize: viewModel.fontSize)
        
        points?.text = "\(skillListing.points)"
        points?.font = viewModel.numberFont
        points?.textAlignment = .center
        points?.fitTextToBounds(maximumSize: viewModel.fontSize)
        
        modifier?.text = "\(skillListing.modifier)"
        modifier?.font = viewModel.numberFont
        modifier?.textAlignment = .center
        modifier?.fitTextToBounds(maximumSize: viewModel.fontSize)
        
        total?.text = "\(skillListing.skillRollValue)"
        total?.font = viewModel.totalFont
        total?.textAlignment = .center
        total?.fitTextToBounds(maximumSize: viewModel.fontSize)
    }
    
    private func columnLabel(frame: CGRect) -> UILabel {
        let label = UILabel(frame: frame)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = StyleConstants.Color.dark
        label.font = StyleConstants.Font.defaultFont
        label.text = "0"
        label.fitTextToBounds()
        
        return label
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // The correct cell height doesn't seem to be set until layoutSubViews() is called.
        // This hacky sorta-initializer is called
        if !cellHasBeenSetup {
            firstTimeSetup()
            
            cellHasBeenSetup = true
        }
    }
    
    /// This is a one-time called second stage initializer
    private func firstTimeSetup() {
        let nameCellWidthRatio = CGFloat(0.55) // 55% of view width
        let numericCellWidthRatio = CGFloat(0.15) // 3 cells, 15% of width each
        
        let safeFrame = contentView.safeAreaLayoutGuide.layoutFrame
        let totalWidth = safeFrame.width
        
        // MARK: Name column construction
        
        let nameFrameWidth = totalWidth * nameCellWidthRatio
        let nameFrame = CGRect(x: safeFrame.minX, y: safeFrame.minY,
                               width: nameFrameWidth, height: safeFrame.height)
        let nameMargins = NSDirectionalEdgeInsets(top: nameFrame.height * 0.05,
                                                  leading: nameFrame.width * 0.05,
                                                  bottom: nameFrame.height * 0.05,
                                                  trailing: nameFrame.width * 0.05)
        
        let nameView = UILabel.container(frame: nameFrame,
                                         margins: nameMargins,
                                         backgroundColor: StyleConstants.Color.light,
                                         borderColor: nil, borderWidth: nil,
                                         labelMaker: columnLabel)
        name = nameView.label
        contentView.addSubview(nameView.container)
        
        NSLayoutConstraint.activate([
            nameView.container.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor),
            nameView.container.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor),
            nameView.container.widthAnchor.constraint(equalToConstant: nameFrameWidth),
            nameView.container.heightAnchor.constraint(equalToConstant: safeFrame.height)
            ])
        
        // MARK: Numeric Column Construction
        
        var leadingAnchor = nameView.container.trailingAnchor
        var count = 0
        
        for numericColumn in 1...3 {
            let numericFrameWidth = totalWidth * numericCellWidthRatio
            let numericFrame = CGRect(x: nameFrameWidth + (numericFrameWidth * CGFloat(count)),
                                      y: safeFrame.minY,
                                      width: numericFrameWidth,
                                      height: safeFrame.height)
            let numericMargins = NSDirectionalEdgeInsets(top: numericFrame.height * 0.05,
                                                         leading: numericFrame.width * 0.05,
                                                         bottom: numericFrame.height * 0.05,
                                                         trailing: numericFrame.width * 0.05)
            let backgroundColor = numericColumn % 2 > 0 ? StyleConstants.Color.gray : StyleConstants.Color.light
            let numericView = UILabel.container(frame: numericFrame,
                                                margins: numericMargins,
                                                backgroundColor: backgroundColor,
                                                borderColor: nil, borderWidth: nil,
                                                labelMaker: columnLabel)
            
            numericView.label.backgroundColor = backgroundColor
            
            // Store the labels on the object to be edited by the update function
            switch numericColumn {
            case 1:
                points = numericView.label
            case 2:
                modifier = numericView.label
            case 3:
                total = numericView.label
            default:
                break
            }
            
            contentView.addSubview(numericView.container)
            
            NSLayoutConstraint.activate([
                numericView.container.leadingAnchor.constraint(equalTo: leadingAnchor),
                numericView.container.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor),
                numericView.container.widthAnchor.constraint(equalToConstant: numericFrameWidth),
                numericView.container.heightAnchor.constraint(equalToConstant: safeFrame.height)
                ])
            
            leadingAnchor = numericView.container.trailingAnchor
            count += 1
        }
        
        updateColumnValues()
    }
    
}
