//
//  GraphView.swift
//  Views
//
//  Created by Frederik Christensen on 26/05/2018.
//  Copyright © 2018 Frederik Christensen. All rights reserved.
//

import Foundation
import Charts

public class GraphView: LineChartView {
    public init() {
        super.init(frame: CGRect.zero)
        self.drawGridBackgroundEnabled = false
        self.drawBordersEnabled = false
        self.drawMarkers = false
        self.chartDescription?.text = nil
        self.rightAxis.enabled = false
        self.legend.enabled = false
        self.leftAxis.enabled = false
        self.xAxis.drawLabelsEnabled = false
        self.xAxis.drawGridLinesEnabled = false
        self.xAxis.drawAxisLineEnabled = false
        self.isUserInteractionEnabled = false
        self.noDataText = ""
        self.minOffset = 0
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createLabels(labelCount: Int, interval: Double) -> [String] {
        return Array.init(repeating: 0, count: labelCount).enumerated().map {
            let value = interval * Double($0.offset)
            let hour:Int = Int((value/60).rounded(.down)) + 8
            let minutes:Int = Int(value) % 60
            let hourString = "\(hour)".count == 1 ? "0\(hour)" : "\(hour)"
            let minutesString = "\(minutes)".count == 1 ? "0\(minutes)" : "\(minutes)"
            return "\(hourString):\(minutesString)"
        }
    }
    
    public func setData(interval: Double, data: [Int]) {
        let labels = createLabels(labelCount: data.count, interval: interval)
        let dataEntries: [ChartDataEntry] = data.enumerated().map {
            return ChartDataEntry(x: interval * Double($0.offset), y: Double($0.element))
        }
        let dataSet: LineChartDataSet = LineChartDataSet(values: dataEntries, label: nil)
        dataSet.mode = .linear
        dataSet.drawFilledEnabled = true
        dataSet.drawCirclesEnabled = false
        dataSet.drawIconsEnabled = false
        dataSet.drawValuesEnabled = true
        dataSet.valueFormatter = ValueFormatter(labels: labels, interval: interval)
        dataSet.drawVerticalHighlightIndicatorEnabled = false
        dataSet.drawHorizontalHighlightIndicatorEnabled = false
        self.data = LineChartData(dataSet: dataSet)
        self.fitScreen()
    }
}

private class ValueFormatter: IValueFormatter {
    let labels: [String]
    let interval: Double
    init(labels: [String], interval: Double) {
        self.labels = labels
        self.interval = interval
    }
    func stringForValue(_ value: Double, entry: ChartDataEntry, dataSetIndex: Int, viewPortHandler: ViewPortHandler?) -> String {
        return labels[Int(entry.x/interval)]
    }
}
