//
//  FeedTableViewCell.swift
//  BreakPoint
//
//  Created by DokeR on 17.09.2018.
//  Copyright © 2018 DokeR. All rights reserved.
//

import UIKit

class FeedTableViewCell: UITableViewCell {
    
    @IBOutlet weak var profileImageView: RoundedImageView!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    func configCell(profileImageURL: String, email: String, content: String, date: String) {
        profileImageView.loadImageUsingCacheWithUrlString(profileImageURL)
        emailLabel.text = email
        messageLabel.text = content
        
        let newFormatter = DateFormatter()
        newFormatter.dateFormat = "yyyy, MMM d, HH:mm:ss"

        if let newDate = newFormatter.date(from: date) {
            let formatter = DateComponentsFormatter()
            formatter.unitsStyle = .full
            
            let now = Date()
            
            let calendar = NSCalendar.current
            let components1: Set<Calendar.Component> = [.year, .month, .weekOfMonth, .day, .hour, .minute, .second]
            let components = calendar.dateComponents(components1, from: newDate, to: now)
            
            if components.year ?? 0 > 0 {
                formatter.allowedUnits = .year
            } else if components.month ?? 0 > 0 {
                formatter.allowedUnits = .month
            } else if components.weekOfMonth ?? 0 > 0 {
                formatter.allowedUnits = .weekOfMonth
            } else if components.day ?? 0 > 0 {
                formatter.allowedUnits = .day
            } else if components.hour ?? 0 > 0 {
                formatter.allowedUnits = [.hour]
            } else if components.minute ?? 0 > 0 {
                formatter.allowedUnits = .minute
            } else {
                formatter.allowedUnits = .second
            }
            
            let formatString = NSLocalizedString("%@ ago", comment: "Used to say how much time has passed. e.g. '2 hours ago'")
            
            guard let timeString = formatter.string(for: components) else { return }
            
            let agoDate = String(format: formatString, timeString)
            
            if components.day ?? 0 > 0 {
                newFormatter.dateFormat = "MMM d, HH:mm"
                dateLabel.text = newFormatter.string(from: newDate)
            } else {
                dateLabel.text = agoDate
            }
        }
    }
    
}
