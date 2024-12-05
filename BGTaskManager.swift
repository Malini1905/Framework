//
//  Untitled.swift
//  Periodic Background Tasks
//
//  Created by malini-17745 on 07/10/24.
//
import Foundation
import BackgroundTasks

class BGTaskManager{
    
    static var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .long
        return formatter
      }()
    
    func refresh(){
        let formattedDate = Self.dateFormatter.string(from: Date())
          UserDefaults.standard.set(
            formattedDate,
            forKey: "UserDefaultsKeys.lastRefreshDateKey")
          print("refresh occurred")
    }

    
    func scheduleAppRefresh() {
      let request = BGAppRefreshTaskRequest(
        identifier: "AppRefresh")
        request.earliestBeginDate = Date(timeIntervalSinceNow: 1*60)
      do {
        try BGTaskScheduler.shared.submit(request)
        print("background refresh scheduled")
      } catch {
        print("Couldn't schedule app refresh \(error.localizedDescription)")
      }
    }

    
    func fetchData(completion: @escaping(Data?) -> ()) {
           let url = URL(string: "https://fake-json-api.mock.beeceptor.com/companies")!
           let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
               guard let data = data, error == nil else {
                   print("Error fetching data: \(error?.localizedDescription ?? "Unknown error")")
                   completion(nil)
                   return
               }
               completion(data)
               
               // Process the fetched data
               print("Fetched data: \(data)")
           }
           task.resume()
       }
}
