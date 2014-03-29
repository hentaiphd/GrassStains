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
        public var ballShadow:FlxSprite;
        public var p1Shadow:FlxSprite;
        public var p2Shadow:FlxSprite;
        public var debugText:FlxText;
        public var timeFrame:Number = 0;
        public var timeSec:Number = 0;
        public var goalLeft:FlxSprite;
        public var goalRight:FlxSprite;

        public static var groundHeight:Number = 80;

        public var bg:FlxSprite;

         [Embed(source="data/sprites/bg.png")] private var ImgBG:Class;
         [Embed(source="data/sprites/shadow.png")] private var ImgShadow:Class;


        override public function create():void
        {
            bg = new FlxSprite(0,0,ImgBG);
            this.add(bg);

            FlxG.mouse.show();
            debugText = new FlxText(100,100,100,"");
            this.add(debugText);

            ballShadow = new FlxSprite(0,0,ImgShadow);
            add(ballShadow);

            p1Shadow = new FlxSprite(0,0,ImgShadow);
            add(p1Shadow);

            p2Shadow = new FlxSprite(0,0,ImgShadow);
            add(p2Shadow);

            goalLeft = new FlxSprite(0,300);
            goalLeft.makeGraphic(100,100,0xffffffff);
            goalLeft.immovable = true;
            this.add(goalLeft);

            goalRight = new FlxSprite(650,300);
            goalRight.makeGraphic(100,100,0xffffffff);
            goalRight.immovable = true;
            this.add(goalRight);

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

            //realign shadows w/ locations of objects

            p1Shadow.x = playerOne.x - p1Shadow.width/2;
            p1Shadow.y = playerOne.y; - p1Shadow.height/2;

            p2Shadow.x = playerTwo.x - p2Shadow.width/2;
            p2Shadow.y = playerTwo.y - p2Shadow.height/2;

            ballShadow.x = ball.x - ballShadow.width/2;
            ballShadow.y = ball.y - ballShadow.height/2;

            FlxG.collide(playerOne,ball,playerOneKick);
            FlxG.collide(playerTwo,ball,playerTwoKick);

            if(ball.dribbleOne){
                ball.dribble(playerOne,1,playerOne.power);
            }
            if(ball.dribbleTwo){
                ball.dribble(playerTwo,2,playerOne.power);
            }
        }

        public function playerOneKick(p:Player,b:Ball):void{
            if(b.runSpeed > 0){
                if(b.kicking == 2){
                    FlxG.switchState(new MenuState());
                }
            }

            b.dribbleOne = true;
        }

        public function playerTwoKick(p:Player,b:Ball):void{
            if(b.runSpeed > 0){
                if(b.kicking == 1){
                    FlxG.switchState(new MenuState());
                }
            }

            b.dribbleTwo = true;
        }
    }
}
