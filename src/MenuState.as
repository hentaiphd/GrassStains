package{
    import org.flixel.*;

    public class MenuState extends FlxState{
        [Embed(source="data/sprites/bg.png")] private var ImgBG:Class;
        public var p1:Number = 0;
        public var p2:Number = 0;
        public var score:FlxText;
        public var showscore:Boolean = false;
        public var bg:FlxSprite;

        public function MenuState(p1score:Number = 0, p2score:Number = 0, s:Boolean = false):void{
            p1 = p1score;
            p2 = p2score;
            showscore = s;
        }

        override public function create():void{
            FlxG.mouse.hide();

            bg = new FlxSprite(0,0,ImgBG);
            this.add(bg);

            var t1:FlxText;
            t1 = new FlxText(0,150,FlxG.width,"GRASS STAINS");
            t1.color = 0xfffffff;
            t1.size = 20;
            t1.alignment = "center";
            add(t1);

            var t:FlxText;
            t = new FlxText(0,200,FlxG.width,"SPACE to play\n\nWASD and SPACE for Player 1 // ARROW KEYS and SHIFT for Player 2");
            t.color = 0xfffffff;
            t.size = 14;
            t.alignment = "center";
            add(t);

            score = new FlxText(330,300,800,"");
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
