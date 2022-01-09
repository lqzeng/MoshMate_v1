//
//  TextFieldView.swift
//  MoshMate_v1
//
//  Created by Lucas Zeng on 8/1/2022.
//

import SwiftUI

struct TextFieldView: View {
    
    @State var textFieldText: String = ""
    
    var body: some View {
        
        VStack {
            TextField("Enter location: ", text: $textFieldText)
                .padding()
                .background(Color.gray.opacity(0.3).cornerRadius(10))
                .foregroundColor(.red)
                .font(.headline)
            
            Button(action : {
            
            }, label: {
                Text("Save".uppercased())
                    .padding()
                    .background(Color.blue.cornerRadius(10))
                    .foregroundColor(.red)
                    .font(.headline)
            })
        }
    }
}

struct TextFieldView_Previews: PreviewProvider {
    static var previews: some View {
        TextFieldView()
    }
}
