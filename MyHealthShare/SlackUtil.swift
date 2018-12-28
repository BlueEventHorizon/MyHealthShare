//
//  SlackUtil.swift
//  MyHealthShare
//
//  Created by 寺田 克彦 on 2018/11/30.
//  Copyright © 2018 beowulf-tech. All rights reserved.
//

import Foundation
import UIKit

open class SlackUtil {
    
    static public let shared = SlackUtil()
    private init(){}
    
    struct SlackInfo
    {
        var title: String
        var webhookUrl: String
        var message: String
        
        var slackIcon: String = ""
        
        var authorName: String?
        var authorLink: String = ""
        var authorIcon: String?
        
        var color: String = "00ff50"
        var footer: String?
        var footerIcon: String?
        
        init(title: String, webhookUrl: String, message: String, slackIcon: String, authorName: String, authorIcon: String) {
            self.title = title
            self.webhookUrl = webhookUrl
            self.message = message
            
            self.slackIcon = slackIcon
            self.authorName = authorName
            self.authorIcon = authorIcon
        }
    }
    
    enum SlackUtilError: Error{
        case failed
        case error(_ error: Error)
    }

    func send(info: SlackInfo, completion: @escaping (Result<Bool, SlackUtilError>) -> Void)
    {
        var request = URLRequest(url: URL(string: info.webhookUrl)!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Slackへ送信するJSONを作成
        var dic = Dictionary<String, String>()
        dic["color"] = info.color
        dic["author_name"] = info.authorName
        dic["author_link"] = info.authorLink
        dic["author_icon"] = info.authorIcon
        dic["text"] = info.message
        dic["footer"] = info.footer
        dic["footer_icon"] = info.footerIcon

        var attachments = Array<Any>()
        attachments.append(dic)
        
        var params = Dictionary<String, Any>()
        params["username"] = info.title
        params["icon_emoji"] = info.slackIcon
        params["attachments"] = attachments
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: params, options: [])
        } catch {
            return completion(Result.failure(.failed))
        }
        
        let task = URLSession.shared.dataTask(with: request)
        { (data: Data?, response: URLResponse?, error: Error?) in
            if let error = error {
                return completion(Result.failure(SlackUtilError.error(error)))
            }
            guard let _ = data, let response = response as? HTTPURLResponse else {
                return completion(Result.failure(.failed))
            }
            
            if response.statusCode == 200 {
                return completion(Result.success(true))
            } else {
                return completion(Result.failure(.failed))
            }
        }
        task.resume()
    }
}
