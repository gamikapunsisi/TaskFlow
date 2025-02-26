import SwiftUI

struct VerificationView: View {
    @State private var code = Array(repeating: "", count: 4)
    @State private var currentIndex = 0
    @State private var timerRemaining = 20
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            HStack {
                Button(action: {
                    // Action to go back
                }) {
                    Image(systemName: "chevron.left")
                }
                Spacer()
            }
            .padding()
            
            Text("Verification")
                .font(.title)
                .bold()

            Text("We've sent you the verification code on +1 620 0323 7631")
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .padding()

            HStack(spacing: 20) {
                ForEach(0..<4, id: \.self) { index in
                    TextField("-", text: $code[index])
                        .frame(width: 44, height: 44)
                        .multilineTextAlignment(.center)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(5)
                }
            }
            .padding()

            Button(action: {
                // Action for continue button
            }) {
                HStack {
                    Text("CONTINUE")
                    Image(systemName: "arrow.right")
                }
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue)
                .cornerRadius(10)
            }
            .padding()

            Text("Re-send code in: \(timerRemaining)")
                .onReceive(timer) { _ in
                    if timerRemaining > 0 {
                        timerRemaining -= 1
                    }
                }

            Spacer()

            NumericPad(numbers: ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"], code: $code, currentIndex: $currentIndex)

        }
        .padding()
    }
}

struct NumericPad: View {
    let numbers: [String]
    @Binding var code: [String]
    @Binding var currentIndex: Int

    var body: some View {
        VStack(spacing: 15) {
            ForEach(0..<3, id: \.self) { row in
                HStack(spacing: 15) {
                    ForEach(0..<3, id: \.self) { column in
                        let index = row * 3 + column
                        Button(numbers[index]) {
                            if currentIndex < code.count {
                                code[currentIndex] = numbers[index]
                                if currentIndex < code.count - 1 {
                                    currentIndex += 1
                                }
                            }
                        }
                        .frame(width: 60, height: 60)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(30)
                        .foregroundColor(.black)
                    }
                }
            }
        }
    }
}

struct VerificationView_Previews: PreviewProvider {
    static var previews: some View {
        VerificationView()
    }
}
