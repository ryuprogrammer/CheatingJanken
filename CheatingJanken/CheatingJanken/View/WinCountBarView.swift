import SwiftUI

struct WinCountBarView: View {
    @Binding var userWinCount: Int
    @Binding var enemyWinCount: Int
    var body: some View {
        ZStack {
            // 背景
            Capsule()
                .foregroundColor(.white.opacity(0.6))
                .frame(width: 300, height: 38)
                .shadow(color: Color.white.opacity(0.5), radius: 20)

            // ユーザーのポイント
            Capsule()
                .foregroundColor(.clear)
                .frame(width: 300, height: 38)
                .overlay(alignment: .leading) {
                    Rectangle()
                        .fill(.blue.opacity(0.8))
                        .frame(width: CGFloat(300 * userWinCount)/CGFloat((userWinCount + enemyWinCount)))
                }
                .cornerRadius(20)

            // 敵のポイント
            Capsule()
                .foregroundColor(.clear)
                .frame(width: 300, height: 38)
                .overlay(alignment: .trailing) {
                    Rectangle()
                        .fill(.red.opacity(0.8))
                        .frame(width: CGFloat(300 * enemyWinCount)/CGFloat((enemyWinCount + userWinCount)))
                }
                .cornerRadius(20)
        }
    }
}

// あとでプレビュー表示
// struct WinCountBarView_Previews: PreviewProvider {
//    static var previews: some View {
//        WinCountBarView()
//    }
// }
