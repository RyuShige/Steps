import SwiftUI
import HealthKit

struct StepsView: View {
    
    private var healthStore: HealthStore?
    @State private var steps: [Step] = []
    @State private var circleSteps: [CGFloat] = Array(repeating : 0, count : 15)
    @State private var hourSteps: [CGFloat] = Array(repeating : 0, count : 48)
    @State private var dayOfWeeks: [Int] = []
    @State private var refresh: Bool = false
    @AppStorage("aimStep") private var aimStep = 7000

    private let hour: Int = Calendar.current.component(.hour, from: Date())
    
    init() {
        healthStore = HealthStore()
    }
    
    private func updateUIFromStatistics(_ statisticsCollection: HKStatisticsCollection, isDaily: Bool) {
        let calendar = Calendar.current
        let startDate = calendar.date(byAdding: .day, value: isDaily ? -7 : -2, to: Date())!
        let endDate = Date()
            
        statisticsCollection.enumerateStatistics(from: startDate, to: endDate) { (statistics, stop) in
                
            let count = statistics.sumQuantity()?.doubleValue(for: .count())
            let step = Step(count: Int(count ?? 0), date: statistics.startDate)
                
            if isDaily {
                steps.append(step)
                circleSteps.append(CGFloat(step.count))
                dayOfWeeks.append(calendar.component(.weekday, from: step.date))
                circleSteps.removeFirst()
            } else {
                hourSteps.append(CGFloat(step.count))
                hourSteps.removeFirst()
            }
        }
        
        if isDaily {
            steps.reverse()
            if steps.count > 8 {
                steps = Array(steps.prefix(8))
            }
        }
    }
    
    private func stepsCount(_ steps: [CGFloat]) -> CGFloat {
        var step: [CGFloat] = steps
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: Date())
        let timeLeft = 24-(hour+2)
        
        step.removeSubrange(0...timeLeft)
        step.removeSubrange((24-timeLeft-1)...)
        
        return step.reduce(0, +)
    }

    private func stepsCountAveToPred(_ steps: CGFloat) -> CGFloat {
        let step: CGFloat = steps
        let hour = Calendar.current.component(.hour, from: Date())
        return 24 * step / CGFloat(hour)
    }
    
    private func requestDataFromHealthStore() {
        if let healthStore = healthStore {
            healthStore.requestAuthorization { success in
                if success {
                    healthStore.calculateSteps { statisticsCollection in
                        if let statisticsCollection = statisticsCollection {
                            updateUIFromStatistics(statisticsCollection, isDaily: true)
                        }
                    }
                    
                    healthStore.calculateHourSteps { statisticsCollection in
                        if let statisticsCollection = statisticsCollection {
                            updateUIFromStatistics(statisticsCollection, isDaily: false)
                        }
                    }
                }
            }
        }
    }
    
    var body: some View{
            ScrollView {
                VStack {
                    ZStack {
                        Circle()
                            .trim(from: 0, to: circleSteps[13]/CGFloat(aimStep))
                            .stroke(Color.orange.opacity(0.25),
                                    style: StrokeStyle(
                                        lineWidth: 15,
                                        lineCap: .round)
                            )
                            .rotationEffect(.degrees(-90))
                            .animation(.default, value: circleSteps[13]/CGFloat(aimStep))
                            .frame(width:250, height:350)
                        
                        CircularProgressView(step: stepsCount(hourSteps), maxStep: CGFloat(aimStep), color: Color.orange)
                            .frame(width:250, height:350)
                    
                        CircularProgressView(step: circleSteps[14], maxStep: CGFloat(aimStep), color: Color.green)
                            .frame(width:200, height:300)
                        
                        VStack {
                            Text("\(Int(circleSteps[14]))")
                                .animation(.default, value: circleSteps[14])
                                .font(.system(size: 40))
                                .fontWeight(.heavy)
                                .foregroundColor(.green)
                            
                            Text("\(Int(stepsCount(hourSteps)))")
                                .animation(.default, value: stepsCount(hourSteps))
                                .font(.system(size: 25))
                                .fontWeight(.heavy)
                                .foregroundColor(.orange)
                        }
                    }
                    HStack {
                        Circle()
                            .fill(.green)
                            .frame(width: 16, height: 16)
                        Text("today  ")
                        Circle()
                            .fill(.orange)
                            .frame(width: 16, height: 16)
                        Text("yesterday, until \(hour+1):00")
                    }
                    HStack {
                        Circle()
                            .fill(.orange.opacity(0.25))
                            .frame(width: 16, height: 16)
                        Text("yesterday, total")
                    }
                    VStack(alignment: .leading) { // ListをVStackに変更
                        ForEach(steps, id: \.id) { step in
                            VStack(alignment: .leading) {
                                Text("\(step.count)")
                                Text(step.date, style: .date)
                                    .opacity(0.5)
                            }
                            Divider()  // 区切り線を追加
                        }
                    }
                    .padding()  // この行を追加：VStackの周囲に余白を追加
                    .background(
                        Color(UIColor.systemBackground)
                            .cornerRadius(10)  // 角を少し丸める
                            .shadow(color: .gray.opacity(0.2), radius: 5, x: 0, y: 2)  // シャドウを追加
                    )
                    .padding(.horizontal, 20) // 横方向の余白を追加
                    //                    .navigationTitle("Your Steps")
                    //                }
                    .onAppear(perform: requestDataFromHealthStore)
                }
            }
            .refreshable(action: requestDataFromHealthStore)
    }
    
    struct StepsView_Previews: PreviewProvider {
        static var previews: some View {
            StepsView()
        }
    }
}

