package{
    import org.flixel.*;

    public class Goal extends FlxSprite{
        public var player:Number = 0;
        public var score:Number = 0;

        public function Goal(x:Number, y:Number, p:Number):void{
            super(x,y);
            makeGraphic(100,100,0xffffffff);
            player = p;
        }

        override public function update():void{
            super.update();

        }
    }
}