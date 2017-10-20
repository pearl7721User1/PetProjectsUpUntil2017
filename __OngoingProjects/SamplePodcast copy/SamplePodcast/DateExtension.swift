//
//  File.swift
//  SamplePodcast
//
//  Created by SeoGiwon on 06/09/2017.
//  Copyright © 2017 SeoGiwon. All rights reserved.
//

import UIKit

extension NSDate {
    /*
    static func dateFrom(dateString: String) -> NSDate? {
        
        
        var dateFormatter = DateFormatter()
        // This is important - we set our input date format to match our input string
        // if the format doesn't match you'll get nil from your string, so be careful
        dateFormatter.dateFormat = "EEE, dd MMM yyyy hh:mm:ss Z'" //"MM/dd/yyyy hh:mm:ss a Z'"
        guard let dateFromString = dateFormatter.date(from: dateString) else {
            return nil
        }
        
        return dateFromString as NSDate
    }
    */
    
    func colloquial(isShortForm: Bool) -> String {
        
        let date = self as Date
        
        if Calendar.current.isDateInToday(date) {
            
            if isShortForm {
                return "Today"
            }
            else {
                let format = DateFormatter()
                format.dateFormat = "h:mm a"
                return "Today at \(format.string(from: date))"
            }
            
        }
        
        guard let startOfWeek = Date().startOfWeek,
            let startOfYear = Date().startOfYear else {
                return ""
        }
        
        if startOfWeek.compare(date) != .orderedDescending && (startOfYear.compare(date) == .orderedAscending || startOfYear.compare(self as Date) == .orderedSame) {
            let formatGamma = DateFormatter()
            
            if isShortForm {
                formatGamma.dateFormat = "EEE"
            } else {
                formatGamma.dateFormat = "EEEE"
            }
            
            
            return formatGamma.string(from: date)
        }
        else if startOfYear.compare(self as Date) != .orderedDescending {
            let formatBeta = DateFormatter()
            
            if isShortForm {
                formatBeta.dateFormat = "dd MMM"
            } else {
                formatBeta.dateFormat = "dd MMMM"
            }
            
            return formatBeta.string(from: date)
        }
        else {
            let formatAlpha = DateFormatter()
            
            if isShortForm {
                formatAlpha.dateFormat = "MM/dd/yyyy"
            } else {
                formatAlpha.dateFormat = "dd MMM yyyy"
            }
            
            return formatAlpha.string(from: date)
        }
    }
    
}

extension Date {
    
    var startOfWeek: Date? {
        
        var components = Calendar.current.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)
        components.hour = 0
        components.minute = 0
        components.second = 0
        
        let date = Calendar.current.date(from: components)
        
        return date
    }
    
    
    var startOfYear: Date? {
        
        
        var components = Calendar.current.dateComponents([.yearForWeekOfYear], from: self)
        components.hour = 0
        components.minute = 0
        components.second = 0
        
        let date = Calendar.current.date(from: components)
        
        return date
    }
}

