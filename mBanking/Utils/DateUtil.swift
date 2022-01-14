//
//  DateUtil.swift
//  mBanking
//
//  Created by Borna Ungar on 12.01.2022..
//

import Foundation
public class DateUtils {
    
    static let dotTimeFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy."
        return dateFormatter
    }()
    
    public static func getDateOfDottedString(_ string: String) -> Date {
        guard let date = dotTimeFormatter.date(from: string) else { return Date.distantPast }
        return date
    }
}
