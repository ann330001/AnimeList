//
//  JSONStruct.swift
//  AnimeList
//
//  Created by Ann on 2020/11/14.
//  Copyright © 2020 AnnChen.com. All rights reserved.
//

import Foundation

// Retrieve Top List
struct RetrieveTopList : Decodable
{
    var top : [Top]
    private enum CodingKeys: String, CodingKey {
        case top = "top"
    }
}

struct Top : Decodable
{
    var mal_id: Int32
    var rank: Int32
    var title: String
    var url: String
    var image_url: URL
    var type: String
    var start_date: String?
    var end_date: String?
    
    private enum CodingKeys: String, CodingKey {
        case mal_id = "mal_id"
        case rank = "rank"
        case title = "title"
        case url = "url"
        case image_url = "image_url"
        case type = "type"
        case start_date = "start_date"
        case end_date = "end_date"
    }
}

enum TopType: String, CaseIterable {
    case anime = "anime"
    case manga = "manga"
}

enum TopSubtypeAnime: String, CaseIterable {
    case airing = "airing"
    case upcoming = "upcoming"
    case tv = "tv"
    case movie = "movie"
    case ova = "ova"
    case special = "special"
}

enum TopSubtypeManga: String, CaseIterable {
    case manga = "manga"
    case novels = "novels"
    case oneshots = "oneshots"
    case doujin = "doujin"
    case manhwa = "manhwa"
    case manhua = "manhua"
}

enum TopSubtypeBoth: String, CaseIterable {
    case bypopularity = "bypopularity"
    case favorite = "favorite"
}
