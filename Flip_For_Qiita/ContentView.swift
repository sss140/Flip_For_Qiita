//

import SwiftUI

struct Flip:View{
    //アニメーションの時間
    var animation:Animation = Animation.linear(duration: 3.0)
    //各軸の回転方向
    var axis:(x:CGFloat,y:CGFloat,z:CGFloat) = (x:0.0,y:1.0,z:0.0)
    //回転角度
    @State private var angle:Double = 0.0
    
    var body:some View{
        ZStack{
            Rectangle()
                .cornerRadius(20.0)
                //角度90度〜270度（π/2〜3π/2）で色を変更
                .foregroundColor(cos(self.angle)>0 ? Color.gray:Color.blue)
            //角度90度〜270度（π/2〜3π/2）でテキストを変更
            Text(cos(self.angle)>0 ? "GRAY":"BLUE")
                .font(.custom("Arial", size: 100.0))
        }
        .frame(width: 300.0, height: 200.0)
        .rotation3DEffect(Angle(radians: self.angle), axis: (x:axis.x,y:axis.y,z:axis.z))
        .animation(self.animation)
        .onTapGesture {
            //タップしたら180度加算
            self.angle += .pi
        }
    }
}

struct ContentView: View {
    var body: some View {
        Flip()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
