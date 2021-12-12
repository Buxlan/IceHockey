//
//  HockeyPlayerRole.swift.swift
//  IceHockey
//
//  Created by  Buxlan on 10/30/21.
//

enum PlayerRole: Int, Codable, CustomStringConvertible {
    
    case striker
    case defender
    case goalkeeper
    
    var description: String {
        var description: String
        switch self {
        case .striker:
            description = L10n.HockeyPlayer.positionStrikerPlural
        case .defender:
            description = L10n.HockeyPlayer.positionDefenderPlural
        case .goalkeeper:
            description = L10n.HockeyPlayer.positionGoalkeeperPlural
        }
        return description
    }
    
    init(rawValue: Int) {
        switch rawValue {
        case 0:
            self = .striker
        case 1:
            self = .defender
        case 2:
            self = .goalkeeper
        default:
            self = .striker
        }
    }
    
}
