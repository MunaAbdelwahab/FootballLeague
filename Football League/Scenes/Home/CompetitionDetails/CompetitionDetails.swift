//
//  CompetitionDetails.swift
//  Football League
//
//  Created by Muna Abdelwahab on 03/10/2022.
//

import Foundation
import RealmSwift

@objc class CompetitionDetailsSaved: Object {
    @Persisted var name: String?
    @Persisted var code: String?
    @Persisted var area: AreaSaved?
    @Persisted var plan: String?
    @Persisted var image: String?
    @Persisted var seasons: List<SeasonSave> = List<SeasonSave>()
}

class AreaSaved: Object {
    @Persisted var name: String?
    var parentCategory = LinkingObjects(fromType: CompetitionDetailsSaved.self, property: "area")
}

class SeasonSave: Object {
    @Persisted var start: String?
    @Persisted var end: String?
    @Persisted var winner: WinnerSaved?
    var parentCategory = LinkingObjects(fromType: CompetitionDetailsSaved.self, property: "seasons")
}

class WinnerSaved: Object {
    @Persisted var name: String?
    @Persisted var tla: String?
    @Persisted var image: String?
    var parentCategory = LinkingObjects(fromType: SeasonSave.self, property: "winner")
}

@objc class TeamSaved: Object {
    @Persisted var teams: List<TeamsSave> = List<TeamsSave>()
}

class TeamsSave: Object {
    @Persisted var image: String?
    @Persisted var shortName: String?
    @Persisted var longName: String?
    @Persisted var id: Int?
    var parentCategory = LinkingObjects(fromType: TeamSaved.self, property: "teams")
}
