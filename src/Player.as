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
        public var fell:Boolean = false;

        public var pos:FlxPoint;
        public var shakeMod:FlxPoint = new FlxPoint(0,0);

        public var state:String = "idle";

        [Embed(source="data/sprites/ninaSheet.png")] private var ImgNina:Class;

        public function Player(x:Number, y:Number, player:Number):void{
            super(x,y);
            pos = new FlxPoint(x,y);
            playerNum = player;
            makeGraphic(10,10);
            debugText = new FlxText(x-20,y-30,100,"");
            FlxG.state.add(debugText);

            switch (playerNum)
            {
                case 1:
                this.loadGraphic(ImgNina,true,false,76,136);
                break;
                case 2:
                this.loadGraphic(ImgNina,true,false,76,136);
                break;
            }

            offset.x = width/4;
            width = width/2;


            this.addAnimation("idle",[0]);
            this.addAnimation("run",[1,2],10)
        }


        override public function update():void{
            super.update();
            borderCollide();

            if(fell){
                debugText.text = "I fell!";
            } else {
                debugText.text = power.toString();
                debugText.x = this.x-20;
                debugText.y = this.y-30;
            }

            if(!fell){
                if(playerNum == 1){
                    playerOneMovement();

                    if(FlxG.keys.pressed("SHIFT")){
                        power++;

                        var shake:Number = (Math.random() * power/20) - (power/40);

                        shakeMod = new FlxPoint(shake, shake);

                        if(power > powerCap){
                            power = powerCap;
                        }
                    }
                    else
                    {
                        shakeMod = new FlxPoint(0,0);
                    }
                }

                if(playerNum == 2){
                    playerTwoMovement();
                    if(FlxG.keys.pressed("SPACE")){

                        var shake2:Number = (Math.random() * power/20) - (power/40);

                        shakeMod = new FlxPoint(shake2, shake2);

                        power++;
                        if(power > powerCap){
                            power = powerCap;
                        }
                    }
                    else
                    {
                        shakeMod = new FlxPoint(0,0);
                    }
                }
            }

            play(state);
            x = pos.x + shakeMod.x;
            y = pos.y + shakeMod.y;
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

            this.pos.x += velocity.x;
            this.pos.y += velocity.y;

            if(Math.abs(this.velocity.x) >= maxSpeed){
                this.velocity.x = (this.velocity.x/Math.abs(this.velocity.x))*maxSpeed;
            }
            if(Math.abs(this.velocity.y) >= maxSpeed){
                this.velocity.y = (this.velocity.y/Math.abs(this.velocity.y))*maxSpeed;
            }

            if(FlxG.keys.LEFT) {
                this.facing = LEFT;
                this.acceleration.x = runSpeed*-1;
                this.scale.x = _scaleFlipX;
                this.scale.y = _scaleFlipY;
                state = "run"
            } else if(FlxG.keys.RIGHT){
                this.facing = RIGHT;
                this.acceleration.x = runSpeed;
                this.scale.x = -_scaleFlipX;
                this.scale.y = _scaleFlipY;
                state = "run"
            } else if(FlxG.keys.UP){
                this.facing = UP;
                this.acceleration.y = runSpeed*-1;
                state = "run"
            } else if(FlxG.keys.DOWN){
                this.facing = DOWN;
                this.acceleration.y = runSpeed;
                state = "run"
            }
            else
            {
                state = "idle"
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

            this.pos.x += velocity.x;
            this.pos.y += velocity.y;

            if(Math.abs(this.velocity.x) >= maxSpeed){
                this.velocity.x = (this.velocity.x/Math.abs(this.velocity.x))*maxSpeed;
            }
            if(Math.abs(this.velocity.y) >= maxSpeed){
                this.velocity.y = (this.velocity.y/Math.abs(this.velocity.y))*maxSpeed;
            }

            if(FlxG.keys.A) {
                this.facing = LEFT;
                this.acceleration.x = runSpeed*-1;
                this.scale.x = _scaleFlipX;
                this.scale.y = _scaleFlipY;
                state = "run"
            } else if(FlxG.keys.D){
                this.facing = RIGHT;
                this.acceleration.x = runSpeed;
                this.scale.x = -_scaleFlipX;
                this.scale.y = _scaleFlipY;
                state = "run"
            } else if(FlxG.keys.W){
                this.facing = UP;
                this.acceleration.y = runSpeed*-1;
                state = "run"
            } else if(FlxG.keys.S){
                this.facing = DOWN;
                this.acceleration.y = runSpeed;
                state = "run"
            }
            else
            {
                state = "idle"
            }
        }

        public function borderCollide():void{
            if(this.pos.x >= FlxG.width - width)
                this.pos.x = FlxG.width - width;
            if(this.pos.x <= 0)
                this.pos.x = 0;
            if(this.pos.y >= FlxG.height - height)
                this.pos.y = FlxG.height - height;
            if(this.pos.y <= PlayState.groundHeight)
                this.pos.y = PlayState.groundHeight;
        }
    }
}

