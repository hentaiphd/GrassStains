package{
    import org.flixel.*;

    public class Ball extends FlxSprite{
        public var runSpeed:Number = 10;
        public var _scale:FlxPoint = new FlxPoint(1,1);
        public var _scaleFlipX:Number = 1;
        public var _scaleFlipY:Number = 1;
        public var maxSpeed:Number = 100;
        public var velocityScale:Number = 0;
        public var accelerationScale:Number = 0;
        public var timeFrame:Number = 0;
        public var timeSec:Number = 0;
        public var dir:Number = 0;
        public var kicking:Number = 0;
        public var power:Number = 0;
        public var dribbleOne:Boolean = false;
        public var dribbleTwo:Boolean = false;

        public var yPos:Number;
        public var air:Number = 50;
        public var fallSpeed:Number = 0;
        public var gravity:Number = .9;

        public var maxKickStrength = 15;

        public var JUST_KICKED:Boolean = false;
        public var kickTimer:Number = 0;
        public var maxKickTimer:Number = 1;

        // out of 1. 1 means the ball loses no velocity when bouncing.
        public var bounciness:Number = .75;

        [Embed(source="data/sprites/ball_whole.png")] private var ImgBall:Class;

        public function Ball(x:Number, y:Number):void{
            super(x,y,ImgBall);
            this.yPos = y;

        }

        override public function update():void{
            super.update();
            borderCollide();

            ballMovement();

            if (kickTimer > 0)
            {
                kickTimer -= FlxG.elapsed;
            }
            else
            {
                kickTimer = 0;
                JUST_KICKED = false;
            }
        }

        public function resetBall():void{
            kicking = 0;
            this.velocity.x = 0;
            this.velocity.y = 0;
            this.x = 350;
            this.y = 350;
        }

        public function ballMovement():void{
            this.acceleration.x = 0;
            this.acceleration.y = 0;
            this.drag.x = .5;
            this.drag.y = .5;

            if(this.velocity.x > 0){
                this.velocity.x -= velocityScale;
            } else if(this.velocity.x < 0){
                this.velocity.x += velocityScale;
            }

            if(this.velocity.y > 0){
                this.velocity.y -= velocityScale;
            } else if(this.velocity.y < 0){
                this.velocity.y += velocityScale;
            }

            this.velocity.x += this.acceleration.x;
            this.velocity.y += this.acceleration.y;

            this.x += velocity.x;
            this.yPos += velocity.y;

            if(Math.abs(this.velocity.x) >= maxSpeed){
                this.velocity.x = (this.velocity.x/Math.abs(this.velocity.x))*maxSpeed;
            }
            if(Math.abs(this.velocity.y) >= maxSpeed){
                this.velocity.y = (this.velocity.y/Math.abs(this.velocity.y))*maxSpeed;
            }

            if (air > 0)
            {
                fallSpeed += gravity;

            }
            else if (fallSpeed > 3)
            {
                air = 0;
                fallSpeed *= -bounciness;
            }
            else
            {
                air = 0;
                fallSpeed = 0;
            }

            air -= fallSpeed;

            this.y = this.yPos - this.air;
        }

        public function dribble(p:Player,power:Number):void{
            if(dribbleOne){
                if(FlxG.keys.justReleased("SHIFT")){
                    kickBall(p,power);
                    kicking = 1;
                    p.power = 0;
                    this.dribbleOne = false;
                    this.dribbleTwo = false;
                } else {
                    this.x = p.pos.x+ (p.scale.x * -40);
                    this.yPos = (p.pos.y+p.height)-25;
                }
            }

            if(dribbleTwo){
                if(FlxG.keys.justReleased("SPACE")){
                    kickBall(p,power);
                    kicking = 2;
                    p.power = 0;
                    this.dribbleOne = false;
                    this.dribbleTwo = false;
                } else {
                    this.x = p.pos.x+(p.scale.x * -10);
                    this.yPos = (p.pos.y+p.height)-30;
                }
            }
        }

        public function kickBall(player:Player, p:Number):void{
            power = p;

            var rand:Number = maxKickStrength * (power/100);

            if(player.facing == LEFT) { //left
                this.velocity.x = rand*-1;
                this.scale.x = _scaleFlipX;
                this.scale.y = _scaleFlipY;
            } else if(player.facing == RIGHT){ //right
                this.velocity.x = rand;
                this.scale.x = -_scaleFlipX;
                this.scale.y = _scaleFlipY;
            } else if(player.facing == UP){ //up
                this.velocity.y = rand*-1;
            } else if(player.facing == DOWN){ //down
                this.velocity.y = rand;
            }

            this.air = 1;
            this.fallSpeed = -(p/5);

            kickTimer = maxKickTimer;
            JUST_KICKED = true;
        }

        public function borderCollide():void{
            if(this.x >= FlxG.width - width)
            {
                this.x = FlxG.width - width;
                this.velocity.x *= -bounciness;
            }
            else if(this.x <= 0)
            {
                this.x = 0;
                this.velocity.x *= -bounciness;
            }
            if(this.yPos >= FlxG.height - height)
            {
                this.yPos = FlxG.height - height;
                this.velocity.y *= -bounciness;
            }
            else if(this.yPos <= PlayState.groundHeight)
            {
                this.yPos = PlayState.groundHeight;
                this.velocity.y *= -bounciness;
            }
        }
    }
}