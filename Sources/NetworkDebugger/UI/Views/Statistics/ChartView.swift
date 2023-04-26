//
//  ChartView.swift
//  
//
//  Created by Michael Artes on 19.03.23.
//

import Charts
import SwiftUI

fileprivate enum ChartViewConstants {
    static let BAR_HEIGHT: CGFloat = 50
}

@available(iOS 16.0, *)
struct ChartView<Content: View, Subview: View>: View {
    typealias Key = String
    typealias Value = Double
    
    @EnvironmentObject var statisticsService: StatisticsService
    @State private var selectedKey = ""
    @State private var isSubviewPresented = false
    
    let limitedHeight: Bool
    let elements: [Dictionary<Key, Value>.Element]
    let annotationForKey: (Key) -> Content
    
    let hasSubview: Bool
    let subviewForKey: () -> Subview
    
    init(limitedHeight: Bool, elements: Dictionary<Key, Value>, @ViewBuilder annotationForKey: @escaping (Key) -> Content, @ViewBuilder subviewForKey: @escaping () -> Subview) {
        self.init(limitedHeight: limitedHeight, elements: elements, annotationForKey: annotationForKey, hasSubview: true, subviewForKey: subviewForKey)
    }
    
    fileprivate init(limitedHeight: Bool, elements: Dictionary<Key, Value>, @ViewBuilder annotationForKey: @escaping (Key) -> Content, hasSubview: Bool, @ViewBuilder subviewForKey: @escaping () -> Subview) {
        self.limitedHeight = limitedHeight
        self.elements = elements.sorted(by: { $0.value > $1.value })
        self.annotationForKey = annotationForKey
        self.hasSubview = hasSubview
        self.subviewForKey = subviewForKey
    }
    
    private var totalValue: Value {
        elements.reduce(0) { $0 + $1.value }
    }
    
    var body: some View {
        Group {
            if limitedHeight {
                scrollView.frame(maxHeight: 400)
            } else {
                scrollView
            }
        }
        .sheet(isPresented: $isSubviewPresented) {
            NavigationStack {
                List {
                    Section {
                        subviewForKey()
                            .toolbar {
                                ToolbarItem(placement: .primaryAction) {
                                    Button("Done") {
                                        isSubviewPresented = false
                                    }
                                }
                            }
                    } header: {
                        Text(statisticsService.selectedHost)
                    }
                }
                .navigationTitle(statisticsService.selectedHost)
                .navigationBarTitleDisplayMode(.inline)
                .ensureNavigationBarVisible()
            }
        }
    }
    
    private var scrollView: some View {
        ScrollView(.vertical) {
            Chart {
                BarMark(
                    x: .value("Value", totalValue),
                    y: .value("Key", "Total")
                )
                ForEach(elements, id: \.key) { (key, value) in
                    BarMark(
                        x: .value("Value", value),
                        y: .value("Key", key)
                    )
                    .annotation(position: .trailing) {
                        annotationForKey(key).font(.caption)
                    }
                }
            }
            .chartPlotStyle { plotArea in
                plotArea.frame(height: CGFloat(elements.count) * ChartViewConstants.BAR_HEIGHT)
            }
            .chartXAxis {
                AxisMarks(preset: .automatic, position: .top)
            }
            .chartOverlay { proxy in
                GeometryReader { geometry in
                    Rectangle().fill(.clear).contentShape(Rectangle()).onTapGesture { location in
                        let offsetLocation = CGPoint(
                            x: location.x,
                            y: location.y - (ChartViewConstants.BAR_HEIGHT / 2)
                        )
                        guard let (_, key) = proxy.value(at: offsetLocation, as: (Value, Key).self),
                              key != "Total",
                              hasSubview
                        else {
                            return
                        }
                        statisticsService.selectedHost = key
                        isSubviewPresented = true
                    }
                }
            }
        }
    }
}

@available(iOS 16.0, *)
extension ChartView where Subview == EmptyView {
    init(limitedHeight: Bool, elements: Dictionary<Key, Value>, @ViewBuilder annotationForKey: @escaping (Key) -> Content) {
        self.init(limitedHeight: limitedHeight, elements: elements, annotationForKey: annotationForKey, hasSubview: false) {
            EmptyView()
        }
    }
}
