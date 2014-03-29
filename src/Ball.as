package{
    import org.flixel.*;

    public class Ball extends FlxSprite{
        public var runSpeed:Number = 0;
        public var _scale:FlxPoint = new FlxPoint(1,1);
        public var _scaleFlipX:Number = 1;
        public var _scaleFlipY:Number = 1;
        public var maxSpeed:Number = 10;
        public var velocityScale:Number = 0;
        public var accelerationScale:Number = 0;
        public var timeFrame:Number = 0;
        public var timeSec:Number = 0;
        public var dir:Number = 0;
        public var kicking:Boolean = false;
        public var power:Number = 0;

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

            /*if(kicking == true){
                timeFrame++;
                if(timeFrame%50 == 0){
                    timeSec++;
                }
                if(timeSec == 3){
                    kicking = false;
                }

                kickBall();
            }*/

            kickBall();

            //this.y = this.yPos + this.air;
        }

        public function kickBall():void{
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

            if(this.acceleration.x > 0){
                this.acceleration.x -= accelerationScale;
            } else if(this.acceleration.x < 0){
                this.acceleration.x += accelerationScale;
            }

            if(this.acceleration.y > 0){
                this.acceleration.y -= accelerationScale;
            } else if(this.acceleration.y < 0){
                this.acceleration.y += accelerationScale;
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
            if(dir == 1) { //left
                this.acceleration.x = runSpeed*-1;
                this.scale.x = _scaleFlipX;
                this.scale.y = _scaleFlipY;
            } else if(dir == 16){ //right
                this.acceleration.x = runSpeed;
                this.scale.x = -_scaleFlipX;
                this.scale.y = _scaleFlipY;
            } else if(dir == 256){ //up
                this.acceleration.y = runSpeed*-1;
            } else if(dir == 4096){ //down
                this.acceleration.y = runSpeed;
            }

            
        }

        public function kickDirection(d:Number, p:Number):void{
            dir = d;
            power = p;
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