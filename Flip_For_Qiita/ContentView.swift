//

import SwiftUI

struct StringLetters:View{
    var letters:[Character] = []
    init(string:String){
        for char in string{
            self.letters.append(char)
        }
    }
    
    var body:some View{
        HStack{
            ForEach(0..<self.letters.count, id: \.self){ num in
                Image(systemName: "\(self.letters[num]).square.fill")
                    .font(.largeTitle)
                    .foregroundColor(Color.white)
            }
        }
    }
}



struct Flip1:View{
    let images = [StringLetters(string: "red"),StringLetters(string: "blue")]
    //アニメーションの時間
    let animation:Animation = Animation.linear(duration: 3.0)
    //各軸の回転方向
    let axis:(x:CGFloat,y:CGFloat,z:CGFloat) = (x:0.0,y:1.0,z:0.0)
    //回転角度
    @State private var angle:Double = 0.0
    var body:some View{
        VStack{
            Text("rotation3DEffectを使用した回転")
            ZStack{
                Rectangle()
                .frame(width: 300.0, height: 200.0)
                .cornerRadius(20.0)
                //角度90度〜270度（π/2〜3π/2）で色を変更
                .foregroundColor(cos(self.angle)>0 ? Color.red:Color.blue)
                
                images[cos(self.angle)>0 ? 0:1]
            }.rotation3DEffect(Angle(radians: self.angle), axis: (x:axis.x,y:axis.y,z:axis.z))
                .onTapGesture {
                    //タップしたら180度加算
                    withAnimation(self.animation){
                        self.angle += .pi
                    }
            }
        }
    }
}




struct Flip2:View{
    let images = [StringLetters(string: "red"),StringLetters(string: "blue")]
    //アニメーションの時間
    var animation:Animation = Animation.linear(duration: 3.0)
    
    //回転角度 CGFloat
    @State private var angle:CGFloat = 0.0
    //裏のカードが表示されたか
    @State var flipped:Bool = true
    var body:some View{
        VStack{
            Text("ProjectionTransformを使用した回転")
            ZStack{
                Rectangle()
                    .frame(width: 300.0, height: 200.0)
                    .cornerRadius(20.0)
                    .foregroundColor(self.flipped ? Color.red:Color.blue)
                images[self.flipped ? 0:1]
                
            }.modifier(FlipEffect(angle: self.angle, flipped: self.$flipped))
                .onTapGesture {
                    //タップしたら180度加算
                    withAnimation(self.animation){
                        self.angle += .pi
                    }
            }
        }
    }
}

struct FlipEffect:GeometryEffect{
    var angle:CGFloat
    @Binding var flipped:Bool
    //各軸の回転方向
    let axis:(x:CGFloat,y:CGFloat,z:CGFloat) = (x:0.0,y:1.0,z:0.0)
    
    var animatableData:CGFloat{
        get{return angle}
        set{angle = newValue
        }
    }
    /*
     var animatableData: AnimatablePair<CGPoint.AnimatableData, CGPoint.AnimatableData> {
     get { AnimatablePair(start.animatableData, end.animatableData) }
     set { (start.animatableData, end.animatableData) = (newValue.first, newValue.second) }
     }
     */
    
    func effectValue(size: CGSize) -> ProjectionTransform {
        let center:CGPoint = CGPoint(x: size.width/2.0, y: size.height/2.0)
        DispatchQueue.main.async {
            self.flipped = cos(self.angle)>0
        }
        var transform3d:CATransform3D = CATransform3DIdentity
        transform3d.m34 = -1/max(size.width, size.height)
        transform3d = CATransform3DRotate(transform3d, self.angle , axis.x, axis.y, axis.z)
        transform3d = CATransform3DTranslate(transform3d, -center.x, -center.y, 0)
        let affineTransform = ProjectionTransform(CGAffineTransform(translationX: center.x , y: center.y ))
        //print(transform3d.m31)
        return ProjectionTransform(transform3d).concatenating(affineTransform)
    }
}



struct ContentView: View {
    var body: some View {
        VStack{
            Spacer()
            Flip1()
            Spacer()
            Flip2()
            Spacer()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
