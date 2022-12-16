//
//  GroupedLabels.swift
//  CoffeeBreak
//
//  Created by Alexander Tokarev on 15/12/22.
//

import SwiftUI

struct GroupedLabels: View {
    private let labels: [String]
    private let labelsPerRow: Int
    private let numberOfRows: Int

    init(labels: [String], labelsPerRow: Int) {
        self.labels = labels
        self.labelsPerRow = max(labelsPerRow, 1)
        self.numberOfRows = (labels.count + 1) / labelsPerRow
    }

    var body: some View {
        if numberOfRows > 0 {
            VStack() {
                ForEach(0 ..< numberOfRows, id: \.self) { row in
                    interestsRow(labels, row)
                }
            }
        }
    }

    private func interestsRow(_ labels: [String], _ row: Int) -> some View {
        HStack {
            ForEach(0 ..< labelsPerRow, id: \.self) { column in
                let i = (row * labelsPerRow) + column
                if let text = labels[safe: i] {
                    interestLabel(text)
                }
            }
        }
    }

    private func interestLabel(_ text: String) -> some View {
        Text(text)
            .foregroundColor(.gray)
            .bold()
            .padding(.horizontal, 24)
            .padding(.vertical, 10)
            .background(Rectangle().fill(CoffeeColors.innerBox).cornerRadius(10))
    }
}

// MARK: - Previews

struct GroupedLabels_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Spacer()
            GroupedLabels(labels: ["Gaming", "Hiking", "UX Design"], labelsPerRow: 2)
            Spacer()
            GroupedLabels(labels: ["Gaming", "Hiking", "UX Design"], labelsPerRow: 3)
            Spacer()
            GroupedLabels(labels: ["Gaming", "Hiking", "UX Design"], labelsPerRow: 1)
            Spacer()
            GroupedLabels(labels: ["Gaming", "Hiking", "UX Design"], labelsPerRow: -1)
            Spacer()
            GroupedLabels(labels: [], labelsPerRow: Int.max)
        }
        .padding()
    }
}
