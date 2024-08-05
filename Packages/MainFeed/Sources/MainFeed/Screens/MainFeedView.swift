//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 04/08/2024.
//

import SwiftUI

struct MainFeedListView: View {
    @Environment(PexelAPIService.self) var pexelAPIService: PexelAPIService
    
    var body: some View {
        List {
            Text("Hello World")
        }
    }
}


public struct MainFeedView: View {
    @Environment(PexelAPIService.self) var pexelAPIService: PexelAPIService
    
    public init() {
        
    }
    
    public var body: some View {
        NavigationStack {
            MainFeedListView()
        }
    }
}
