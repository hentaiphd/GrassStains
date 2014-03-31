package{
    import org.flixel.*;

    public class MenuState extends FlxState{
        public var p1:Number = 0;
        public var p2:Number = 0;
        public var score:FlxText;
        public var showscore:Boolean = false;

        public function MenuState(p1score:Number = 0, p2score:Number = 0, s:Boolean = false):void{
            p1 = p1score;
            p2 = p2score;
            showscore = s;
        }

        override public function create():void{
            FlxG.mouse.hide();

            var t:FlxText;
            t = new FlxText(200,200,100,"SPACE to play");
            t.color = 0xfffffff;
            t.size = 14;
            add(t);

            score = new FlxText(200,300,800,"");
            score.color = 0xfffffff;
            score.size = 14;
            add(score);
        }

        override public function update():void{
            super.update();

            if(showscore){
                score.text = "You got called inside for dinner! Playtime is over!\n\nPlayer 1 scored " + p1.toString() + " goals!\n Player 2 scored " + p2.toString() + " goals!";
            }

            if(FlxG.keys.pressed("SPACE")){
                FlxG.switchState(new PlayState());
            }
        }
    }
}
