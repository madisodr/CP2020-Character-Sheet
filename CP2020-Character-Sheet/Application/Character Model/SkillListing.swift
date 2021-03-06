//
//  SkillListing.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 12/20/18.
//  Copyright © 2018 Ken Krzeminski. All rights reserved.
//

import Foundation

/// Represents the listing of a skill as it is known to the character
final class SkillListing: Codable, Equatable {
    static func == (lhs: SkillListing, rhs: SkillListing) -> Bool {
        return lhs.skill.name == rhs.skill.name && lhs.skill.nameExtension == rhs.skill.nameExtension
    }
    
    
    /// The skill tied to the listing
    let skill: Skill
    
    /// Category for display purposes inside of a tableview. This will be the stat associated with the skill.
    var category: String?
    
    /// Number of points alloted to the skill by the player
    let points: Int
    
    /// The number of points that modify this score. This does not include the linked stat.
    /// This field is intended for positive or negative effects (i.e. temporary states)
    var modifier: Int
    
    /// The modifier from the linked stat, if any
    var statModifier: Int
    
    /// Returns the value of the skill added to the skill check roll
    var skillRollValue: Int {
        return points + modifier + statModifier
    }
    
    init(skill: Skill, points: Int, modifier: Int, statModifier: Int?) {
        self.skill = skill
        self.points = points
        self.modifier = modifier
        // TODO: Make stat modifier a computed property based on a stat lookup
        self.statModifier = statModifier ?? 0
        
        category = skill.isSpecialAbility ? "Special Ability" : skill.linkedStat?.rawValue
    }
    
    enum CodingKeys: String, CodingKey {
        case statModifier = "stat_modifier"
        case skill, category, points, modifier
    }
}
