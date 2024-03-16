//
//  TeamView.swift
//  AIAR
//
//  Created by Peter Sheehan on 16/03/2024.
//  (This is modified code based on code written by Ruoxin Chen)
//

import SwiftUI

private struct DeveloperInfoView: View {
    
    private let imageName: String
    private let name: String
    
    init(imageName: String, name: String) {
        self.imageName = imageName
        self.name = name
    }
    
    var body: some View {
        VStack {
            Image(imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 150, height: 200)
                    
            Text(name)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(.primary)
        }
    }
}

struct TeamView: View {
    var body: some View {
        VStack {
            HStack {
                Text("Meet the Team!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundStyle(.primary)
            }
            
            Spacer()
            
            Group {
                HStack(spacing: 20) {
                    DeveloperInfoView(imageName: "Louie", name: "Louie Sinadjan")
                    DeveloperInfoView(imageName: "Rxc", name: "Ruoxin Chen")
                }
                .padding()
                
                HStack(spacing: 20) {
                    DeveloperInfoView(imageName: "peter", name: "Peter Sheehan")
                    DeveloperInfoView(imageName: "zak", name: "Zak Mansuri")
                }
                .padding()
            }
            
            Spacer()
        }
    }
}

#Preview {
    TeamView()
}
