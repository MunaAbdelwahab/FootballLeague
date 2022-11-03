//
//  Competition.swift
//  Football League
//
//  Created by Muna Abdelwahab on 03/10/2022.
//

import Foundation
import RealmSwift

@objc class CompetitionsSaved: Object {
    @Persisted var competitions: List<CompetitionSave> = List<CompetitionSave>()
}

class CompetitionSave: Object {
    @Persisted var id: Int?
    @Persisted var name: String?
    @Persisted var code: String?
    @Persisted var numberOfTeams: Int?
    @Persisted var numberOfGames: Int?
    var parentCategory = LinkingObjects(fromType: CompetitionsSaved.self, property: "competitions")
}
