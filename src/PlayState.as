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
        public var netBack:FlxSprite;
        public var netFront:FlxSprite;
        public var net2Back:FlxSprite;
        public var net2Front:FlxSprite;
        public var goalLeft:Goal;
        public var goalRight:Goal;
        public var net1Text:FlxText;
        public var net2Text:FlxText;

        public static var groundHeight:Number = 80;

        public var bg:FlxSprite;

         [Embed(source="data/sprites/bg.png")] private var ImgBG:Class;
         [Embed(source="data/sprites/shadow.png")] private var ImgShadow:Class;
         [Embed(source="data/sprites/net_back.png")] private var ImgNetBack:Class;
         [Embed(source="data/sprites/net_top.png")] private var ImgNetFront:Class;



        override public function create():void
        {
            bg = new FlxSprite(0,0,ImgBG);
            this.add(bg);

            FlxG.mouse.show();
            debugText = new FlxText(100,100,100,"");
            this.add(debugText);

            netBack = new FlxSprite(0,110,ImgNetBack);
            netFront = new FlxSprite(0,110,ImgNetFront);
            add(netBack);

            net2Back = new FlxSprite(0,110,ImgNetBack);
            net2Front = new FlxSprite(0,110,ImgNetFront);
            net2Back.scale.x *= -1;
            net2Front.scale.x *= -1;
            net2Back.x = FlxG.width - net2Back.width;
            net2Front.x = FlxG.width - net2Front.width;
            add(net2Back);

            ballShadow = new FlxSprite(0,0,ImgShadow);
            add(ballShadow);

            p1Shadow = new FlxSprite(0,0,ImgShadow);
            add(p1Shadow);

            p2Shadow = new FlxSprite(0,0,ImgShadow);
            add(p2Shadow);

            goalLeft = new Goal(0,215,1);
            this.add(goalLeft);

            goalRight = new Goal(FlxG.width,215,2);
            goalRight.x -= goalRight.width;
            this.add(goalRight);

            playerOne = new Player(200,200,1);
            this.add(playerOne);

            playerTwo = new Player(400,200,2);
            this.add(playerTwo);

            ball = new Ball(350,350);
            this.add(ball);

            add(netFront);
            add(net2Front);

            net1Text = new FlxText(FlxG.width-100,FlxG.height-30,500,"");
            net1Text.size = 14;
            add(net1Text);

            net2Text = new FlxText(20,FlxG.height-30,500,"");
            net2Text.size = 14;
            add(net2Text);
        }

        override public function update():void
        {
            super.update();
            debugText.text = ball.velocity.x.toString();

            net2Text.text = "P1 Score: " + goalLeft.score.toString();
            net1Text.text = "P2 Score: " + goalRight.score.toString();

            timeFrame++;
            if(timeFrame%50 == 0){
                timeSec++;
            }

            if(timeSec == 180){
                FlxG.switchState(new MenuState(goalLeft.score,goalRight.score,true));
            }

            //realign shadows w/ locations of objects

            p1Shadow.x = playerOne.x - p1Shadow.width/2;
            p1Shadow.y = playerOne.y; - p1Shadow.height/2 + playerOne.height;

            p2Shadow.x = playerTwo.x - p2Shadow.width/2;
            p2Shadow.y = playerTwo.y - p2Shadow.height/2;

            ballShadow.x = ball.x - ballShadow.width/2;
            ballShadow.y = ball.yPos + ball.height * .75;


            FlxG.overlap(ball,goalRight,score);
            FlxG.overlap(ball,goalLeft,score);
            FlxG.overlap(playerOne,ball,playerOneGrab);
            FlxG.overlap(playerTwo,ball,playerTwoGrab);
            FlxG.overlap(playerTwo,playerOne,helpStand);

            if(ball.dribbleOne){
                ball.dribble(playerOne,playerOne.power);
            }
            if(ball.dribbleTwo){
                ball.dribble(playerTwo,playerTwo.power);
            }
        }

        public function helpStand(p1:Player,p2:Player):void{
            p1.fell = false;
            p2.fell = false;
        }

        public function score(b:Ball,g:Goal):void{
            if(!b.dribbleOne){
                if(!b.dribbleTwo){
                    g.score++;
                    FlxG.shake(.001,1);
                    b.resetBall();
                }
            }
        }

        public function playerOneGrab(p:Player,b:Ball):void{
            if(b.runSpeed > 0){
                if(b.kicking == 2){
                    if(b.velocity.x > 3){
                        p.fell = true;
                    }
                }
            }

            if(!b.dribbleOne){
                if(!b.dribbleTwo){
                    if (!b.JUST_KICKED || b.kicking == 2)
                        {
                             b.dribbleOne = true;
                        }
                }
            }
        }

        public function playerTwoGrab(p:Player,b:Ball):void{
            if(b.runSpeed > 0){
                if(b.kicking == 1){
                    if(b.velocity.x > 3){
                        p.fell = true;
                    }
                }
            }

            if(!b.dribbleOne){
                if(!b.dribbleTwo){
                    if (!b.JUST_KICKED || b.kicking == 2)
                    {
                         b.dribbleTwo = true;
                    }
                }
            }
        }
    }
}
