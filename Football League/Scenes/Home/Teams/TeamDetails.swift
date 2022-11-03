//
//  TeamDetails.swift
//  Football League
//
//  Created by Muna Abdelwahab on 04/10/2022.
//

import Foundation
import RealmSwift

@objc class TeamDetailsSaved: Object {
    @Persisted var name: String?
    @Persisted var code: String?
    @Persisted var colors: String?
    @Persisted var image: String?
    @Persisted var area: AreasSaved?
    @Persisted var phone: String?
    @Persisted var address: String?
    @Persisted var web: String?
    @Persisted var email: String?
    @Persisted var player: List<PlayerSaved> = List<PlayerSaved>()
}

class PlayerSaved: Object {
    @Persisted var name: String?
    @Persisted var position: String?
    @Persisted var nationality: String?
    var parentCategory = LinkingObjects(fromType: TeamDetailsSaved.self, property: "players")
}

class AreasSaved: Object {
    @Persisted var name: String?
    var parentCategory = LinkingObjects(fromType: TeamDetailsSaved.self, property: "area")
}
