import SwiftUI

struct ContentView: View {
    @State private var selectedFunction = 0
    @State private var a: Double = 1.0
    @State private var b: Double = 0.0
    @State private var c: Double = 0.0
    
    let functions = ["Линейная", "Квадратичная", "Синус"]
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Построитель графиков")
                .font(.title)
                .fontWeight(.bold)
                .padding(.top, 40)
            
            Picker("Функция", selection: $selectedFunction) {
                ForEach(0..<functions.count, id: \.self) { index in
                    Text(functions[index])
                }
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)
            .padding(.top, 10)
            
            VStack(spacing: 15) {
                ParameterSlider(value: $a, range: -5...5, label: "a =", color: .blue)
                ParameterSlider(value: $b, range: -5...5, label: "b =", color: .green)
                ParameterSlider(value: $c, range: -5...5, label: "c =", color: .orange)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 15)
            
            GraphView(function: getFunction(), a: a, b: b, c: c)
                .frame(height: 400)
                .background(Color.white)
                .cornerRadius(12)
                .shadow(radius: 5)
                .padding(.horizontal)
                .padding(.top, 10)
            
            Spacer(minLength: 20)
        }
        .padding(.bottom, 20)
    }
    
    func getFunction() -> (Double) -> Double {
        switch selectedFunction {
        case 0:
            return { x in a * x + b }
        case 1:
            return { x in a * x * x + b * x + c }
        case 2:
            return { x in a * sin(b * x + c) }
        default:
            return { x in x }
        }
    }
}

struct ParameterSlider: View {
    @Binding var value: Double
    let range: ClosedRange<Double>
    let label: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(label)
                    .fontWeight(.medium)
                Text(String(format: "%.2f", value))
                    .foregroundColor(color)
                    .fontWeight(.bold)
            }
            
            Slider(value: $value, in: range)
                .accentColor(color)
        }
    }
}

struct GraphView: View {
    let function: (Double) -> Double
    let a: Double
    let b: Double
    let c: Double
    
    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            let height = geometry.size.height
            let centerX = width / 2
            let centerY = height / 2
            let scale: CGFloat = 50
            
            ZStack {
                Path { path in
                    path.move(to: CGPoint(x: 0, y: centerY))
                    path.addLine(to: CGPoint(x: width, y: centerY))
                    
                    path.move(to: CGPoint(x: centerX, y: 0))
                    path.addLine(to: CGPoint(x: centerX, y: height))
                }
                .stroke(Color.gray, lineWidth: 1)
                
              
                ForEach(-5...5, id: \.self) { i in
                    let x = centerX + CGFloat(i) * scale
                    if x >= 0 && x <= width {
                        Path { path in
                            path.move(to: CGPoint(x: x, y: 0))
                            path.addLine(to: CGPoint(x: x, y: height))
                        }
                        .stroke(Color.gray.opacity(0.3), lineWidth: 0.5)
                    }
                    
                    let y = centerY - CGFloat(i) * scale
                    if y >= 0 && y <= height {
                        Path { path in
                            path.move(to: CGPoint(x: 0, y: y))
                            path.addLine(to: CGPoint(x: width, y: y))
                        }
                        .stroke(Color.gray.opacity(0.3), lineWidth: 0.5)
                    }
                }
                
          
                Path { path in
                    var firstPoint = true
                    for x in stride(from: -5, through: 5, by: 0.05) {
                        let y = function(x)
                        let screenX = centerX + CGFloat(x) * scale
                        let screenY = centerY - CGFloat(y) * scale
                        
                        if screenY >= 0 && screenY <= height && screenX >= 0 && screenX <= width {
                            if firstPoint {
                                path.move(to: CGPoint(x: screenX, y: screenY))
                                firstPoint = false
                            } else {
                                path.addLine(to: CGPoint(x: screenX, y: screenY))
                            }
                        } else {
                            firstPoint = true
                        }
                    }
                }
                .stroke(Color.blue, lineWidth: 2)
            }
        }
    }
}

#Preview {
    ContentView()
}
