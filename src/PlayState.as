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

        public var gameDurationSeconds:Number = 180;
        public var timeFrame:Number = 0;
        public var timeSec:Number = 0;

        public var netBack:FlxSprite;
        public var netFront:FlxSprite;
        public var net2Back:FlxSprite;
        public var net2Front:FlxSprite;

        public var dinnerBubble:FlxSprite;
        public var maxDinnerDisplay:Number = 3;
        public var dinnerDisplay:Number = maxDinnerDisplay;
        private var callingDinner:Boolean = false;
        private var fadingDisplay:Boolean = false;

        public var goalLeft:Goal;
        public var goalRight:Goal;
        public var net1Text:FlxText;
        public var net2Text:FlxText;

        public var scoreAlert:FlxText;
        public var alertTimer:Boolean = false;

        public static var groundHeight:Number = 80;

        public var bg:FlxSprite;

         [Embed(source="data/sprites/bg.png")] private var ImgBG:Class;
         [Embed(source="data/sprites/shadow.png")] private var ImgShadow:Class;
         [Embed(source="data/sprites/net_back.png")] private var ImgNetBack:Class;
         [Embed(source="data/sprites/net_top.png")] private var ImgNetFront:Class;
         [Embed(source="data/sprites/dinnerSheet.png")] private var ImgDinner:Class;
         [Embed(source="../assets/music/bgm2.mp3")] private var Bgm:Class;

        override public function create():void
        {
            //FlxG.playMusic(Bgm);

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

            playerOne = new Player(400,200,1);
            this.add(playerOne);

            playerTwo = new Player(200,200,2);
            this.add(playerTwo);

            ball = new Ball(350,350);
            this.add(ball);

            add(netFront);
            add(net2Front);

            net1Text = new FlxText(FlxG.width-250,FlxG.height-50,250,"");
            net1Text.size = 14;
            net1Text.alignment = "center";
            add(net1Text);

            net2Text = new FlxText(-10,FlxG.height-50,250,"");
            net2Text.size = 14;
            net2Text.alignment = "center";
            add(net2Text);

            dinnerBubble = new FlxSprite(150,15);
            dinnerBubble.loadGraphic(ImgDinner,true,false,370,181)
            dinnerBubble.addAnimation("appear",[0,1,2,3,4,5,6,7,8,9,10,11,12],10,false)
            dinnerBubble.addAnimation("hold",[12]);
            dinnerBubble.addAnimation("disappear",[5,4,3,2,1,0],10,false)
            dinnerBubble.visible = false;
            add(dinnerBubble);

            scoreAlert = new FlxText(300,200,200,"");
            scoreAlert.size = 40;
            add(scoreAlert);
        }

        override public function update():void
        {
            super.update();

            if(ball.dribbleOne){
                debugText.text = "";
            }

            if(ball.dribbleTwo){
                debugText.text = "";
            }

            if(alertTimer){
                scoreAlert.text = "Score!"
                if(timeFrame%50 == 0){
                    scoreAlert.text = "";
                    alertTimer = false;
                }
            }

            net2Text.text = "P1 Score: " + goalLeft.score.toString() + "\nMove: WASD / Kick: SPACE";
            net1Text.text = "P2 Score: " + goalRight.score.toString() + "\nMove: ARROWS / Kick: SHIFT";

            timeFrame++;
            if(timeFrame%50 == 0){
                timeSec++;
            }

            if(timeSec == gameDurationSeconds){
                displayDinner();
            }

            if (callingDinner)
            {
                if (dinnerBubble.finished)
                {
                    dinnerBubble.play("hold");
                }

                if (dinnerDisplay > 0)
                {
                    dinnerDisplay -= FlxG.elapsed;
                }
                else
                {
                    fadingDisplay = true;
                    callingDinner = false;
                    dinnerBubble.play("disappear");
                }
            }

            if (fadingDisplay && dinnerBubble.finished)
            {
                FlxG.switchState(new MenuState(goalLeft.score,goalRight.score,true));
            }

            //realign shadows w/ locations of objects

            p1Shadow.x = playerOne.x - p1Shadow.width/2 + playerOne.width/2;
            p1Shadow.y = playerOne.y - p1Shadow.height/2 + playerOne.height;

            p2Shadow.x = playerTwo.x - p2Shadow.width/2 + playerTwo.width/2;
            p2Shadow.y = playerTwo.y - p2Shadow.height/2 + playerTwo.height;

            ballShadow.x = ball.x - ballShadow.width/2;
            ballShadow.y = ball.yPos + ball.height * .75;


            FlxG.overlap(ball,goalRight,score);
            FlxG.overlap(ball,goalLeft,score);
            FlxG.overlap(playerOne,ball,playerOneGrab);
            FlxG.overlap(playerTwo,ball,playerTwoGrab);
            FlxG.overlap(playerTwo,playerOne,helpStand);

            if(ball.dribbleOne){
                ball.dribble(playerOne,playerOne.power);
                FlxG.log("shit is dribbling1");
            }
            if(ball.dribbleTwo){
                ball.dribble(playerTwo,playerTwo.power);
                FlxG.log("shit is dribbling2");
            }
        }

        public function helpStand(p1:Player,p2:Player):void{
            if (p1.state == "fell")
            {
                p1.state = "idle";
            }

            if (p2.state == "fell")
            {
                p2.state = "idle";
            }
        }

        public function displayDinner():void
        {

            dinnerBubble.visible = true;
            dinnerBubble.play("appear");
            callingDinner = true;

        }

        public function score(b:Ball,g:Goal):void{
            if(!b.dribbleOne){
                if(!b.dribbleTwo){
                    g.score++;
                    FlxG.shake(.001,1);
                    b.resetBall();
                    alertTimer = true;
                }
            }
        }

        public function playerOneGrab(p:Player,b:Ball):void{

            if (p.state != "falling" && p.state != "fell")
            {
                if(b.runSpeed > 0)
                {
                    if(b.kicking == 2)
                    {
                        if(b.velocity.x > 3 || b.velocity.x < -3)
                        {
                            p.fall(b.velocity);
                        }
                        else
                        {
                            b.dribbleOne = true;
                        }
                    }
                    else if (!b.JUST_KICKED)
                    {
                        b.dribbleOne = true;
                    }
                }

                if (FlxG.keys.justReleased("SHIFT") && !ball.dribbleTimer){
                    if(!ball.dribbleOne){
                        ball.dribbleTwo = false;
                        ball.dribbleOne = true;
                    }
                }
            }
        }

        public function playerTwoGrab(p:Player,b:Ball):void
        {
            if (p.state != "falling" && p.state != "fell")
            {
                if(b.runSpeed > 0)
                {
                    if(b.kicking == 1)
                    {
                        if(b.velocity.x > 3 || b.velocity.x < -3){
                            p.fall(b.velocity);
                        }
                        else
                        {
                            b.dribbleTwo = true;
                        }
                    }
                    else if (!b.JUST_KICKED)
                    {
                        b.dribbleTwo = true;
                    }
                }

                if (FlxG.keys.justReleased("SPACE") && !ball.dribbleTimer){
                    if(!ball.dribbleTwo){
                        ball.dribbleOne = false;
                        ball.dribbleTwo = true;
                    }
                }
            }
        }
    }
}
