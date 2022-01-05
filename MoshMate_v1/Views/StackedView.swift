//
//  StackedView.swift
//  MoshMate_v1
//
//  Created by Lucas Zeng on 5/1/2022.
//

import SwiftUI

struct StackedView: View {
    var body: some View {
       
        VStack{
            MapView().frame(height: 300)
            
            FindView()
        }
        
    }
}

struct StackedView_Previews: PreviewProvider {
    static var previews: some View {
        StackedView()
    }
}
