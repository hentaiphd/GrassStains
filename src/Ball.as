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

        public function Ball(x:Number, y:Number):void{
            super(x,y);

        }

        override public function update():void{
            super.update();
            borderCollide();

            if(power > 0){
                runSpeed = .01;
                velocityScale = .001;
                accelerationScale = .001;
            } else if(power > 3){
                runSpeed = .1;
                velocityScale = .01;
                accelerationScale = .01;
            }else if(power > 5){
                runSpeed = 1;
                velocityScale = .1;
                accelerationScale = .1;
            }

            kickBall();
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
            this.y += velocity.y;

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
                this.x = FlxG.width - width;
            if(this.x <= 0)
                this.x = 0;
            if(this.y >= FlxG.height - height)
                this.y = FlxG.height - height;
            if(this.y <= 0)
                this.y = 0;
        }
    }
}