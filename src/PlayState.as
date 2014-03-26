package
{
    import org.flixel.*;

    import Box2D.Dynamics.*;
    import Box2D.Collision.*;
    import Box2D.Collision.Shapes.*;
    import Box2D.Common.Math.*;
    import Box2D.Dynamics.Joints.*;

    import flash.display.*;

    public class PlayState extends FlxState
    {
        public var playerOne:Player;
        public var playerTwo:Player;
        public var ball:Ball;
        public var debugText:FlxText;
        public var timeFrame:Number = 0;
        public var timeSec:Number = 0;

        override public function create():void
        {
            FlxG.mouse.show();
            debugText = new FlxText(100,100,100,"");
            this.add(debugText);

            playerOne = new Player(200,200,1);
            this.add(playerOne);

            playerTwo = new Player(100,100,2);
            this.add(playerTwo);

            ball = new Ball(350,350);
            this.add(ball);
        }

        override public function update():void
        {
            super.update();
            timeFrame++;
            if(timeFrame%50 == 0){
                timeSec++;
            }

            FlxG.collide(playerOne,ball,kickCallback);
            FlxG.collide(playerTwo,ball,kickCallback);

            debugText.text = playerOne.power.toString();
        }

        public function kickCallback(p:Player,b:Ball):void{
            b.kickDirection(p.facing,1);
        }
    }
}
