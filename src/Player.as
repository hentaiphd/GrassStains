package{
    import org.flixel.*;

    public class Player extends FlxSprite{
        public var runSpeed:Number = 1;
        public var _scale:FlxPoint = new FlxPoint(1,1);
        public var _scaleFlipX:Number = 1;
        public var _scaleFlipY:Number = 1;
        public var maxSpeed:Number = 1.5;
        public var velocityScale:Number = .05;
        public var accelerationScale:Number = .5;
        public var playerNum:Number;
        public var power:Number = 0;
        public var powerCap:Number = 100;
        public var debugText:FlxText;

        public function Player(x:Number, y:Number, player:Number):void{
            super(x,y);
            playerNum = player;
            makeGraphic(10,10);
            debugText = new FlxText(x-20,y-30,100,"");
            FlxG.state.add(debugText);
        }


        override public function update():void{
            super.update();
            borderCollide();
            debugText.text = power.toString();
            debugText.x = this.x-20;
            debugText.y = this.y-30;

            if(playerNum == 1){
                playerOneMovement();

                if(FlxG.keys.pressed("SHIFT")){
                    power++;
                    if(power > powerCap){
                        power = powerCap;
                    }
                }
            }

            if(playerNum == 2){
                playerTwoMovement();
                if(FlxG.keys.pressed("SPACE")){
                    power++;
                    if(power > powerCap){
                        power = powerCap;
                    }
                }
            }

        }

        public function playerOneMovement():void{
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
            //pos.x += velo.x;
            //pos.y += velo.y;
            this.x += velocity.x;
            this.y += velocity.y;

            if(Math.abs(this.velocity.x) >= maxSpeed){
                this.velocity.x = (this.velocity.x/Math.abs(this.velocity.x))*maxSpeed;
            }
            if(Math.abs(this.velocity.y) >= maxSpeed){
                this.velocity.y = (this.velocity.y/Math.abs(this.velocity.y))*maxSpeed;
            }

            //this.x = pos.x;
            //this.y = pos.y;

            if(FlxG.keys.LEFT) {
                this.facing = LEFT;
                this.acceleration.x = runSpeed*-1;
                this.scale.x = _scaleFlipX;
                this.scale.y = _scaleFlipY;
            } else if(FlxG.keys.RIGHT){
                this.facing = RIGHT;
                this.acceleration.x = runSpeed;
                this.scale.x = -_scaleFlipX;
                this.scale.y = _scaleFlipY;
            } else if(FlxG.keys.UP){
                this.facing = UP;
                this.acceleration.y = runSpeed*-1;
            } else if(FlxG.keys.DOWN){
                this.facing = DOWN;
                this.acceleration.y = runSpeed;
            }
        }

        public function playerTwoMovement():void{
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
            //pos.x += velo.x;
            //pos.y += velo.y;
            this.x += velocity.x;
            this.y += velocity.y;

            if(Math.abs(this.velocity.x) >= maxSpeed){
                this.velocity.x = (this.velocity.x/Math.abs(this.velocity.x))*maxSpeed;
            }
            if(Math.abs(this.velocity.y) >= maxSpeed){
                this.velocity.y = (this.velocity.y/Math.abs(this.velocity.y))*maxSpeed;
            }

            //this.x = pos.x;
            //this.y = pos.y;

            if(FlxG.keys.A) {
                this.acceleration.x = runSpeed*-1;
                this.scale.x = _scaleFlipX;
                this.scale.y = _scaleFlipY;
            } else if(FlxG.keys.D){
                this.acceleration.x = runSpeed;
                this.scale.x = -_scaleFlipX;
                this.scale.y = _scaleFlipY;
            } else if(FlxG.keys.W){
                this.acceleration.y = runSpeed*-1;
            } else if(FlxG.keys.S){
                this.acceleration.y = runSpeed;
            }
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

