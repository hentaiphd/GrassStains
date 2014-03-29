package{
    import org.flixel.*;

    public class Ball extends FlxSprite{
        public var runSpeed:Number = 10;
        public var _scale:FlxPoint = new FlxPoint(1,1);
        public var _scaleFlipX:Number = 1;
        public var _scaleFlipY:Number = 1;
        public var maxSpeed:Number = 10;
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
        public var air:Number = 0;

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

            kickBall();

            this.y = this.yPos - this.air;
        }

        public function kickBall():void{
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
        }

        public function dribble(p:Player, num:Number, power:Number):void{
            if(FlxG.keys.justReleased("SHIFT")){
                kickDirection(p.facing,power);
                kicking = num;
                p.power = 0;
                this.dribbleOne = false;
                this.dribbleTwo = false;
            } else {
                this.x = p.x+20;
                this.yPos = p.y+20;
            }
        }

        public function kickDirection(d:Number, p:Number):void{
            dir = d;
            power = p;

            var rand:Number = Math.floor(Math.random()*power);

            if(dir == 1) { //left
                this.velocity.x = rand*-1;
                this.scale.x = _scaleFlipX;
                this.scale.y = _scaleFlipY;
            } else if(dir == 16){ //right
                this.velocity.x = rand;
                this.scale.x = -_scaleFlipX;
                this.scale.y = _scaleFlipY;
            } else if(dir == 256){ //up
                this.velocity.y = rand*-1;
            } else if(dir == 4096){ //down
                this.velocity.y = rand;
            }
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