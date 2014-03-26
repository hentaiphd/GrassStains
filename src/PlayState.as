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

        override public function create():void
        {
            FlxG.mouse.show();

            playerOne = new Player(200,200,1);
            this.add(playerOne);

            playerTwo = new Player(100,100,2);
            this.add(playerTwo);

        }

        override public function update():void
        {
            super.update();
        }
    }
}
