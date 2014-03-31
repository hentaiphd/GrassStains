package{
    import org.flixel.*;
    [SWF(width="720", height="480", backgroundColor="#000000")]
    [Frame(factoryClass="Preloader")]

    public class GrassStains extends FlxGame{

        public function GrassStains(){
            super(720,480,MenuState);
            FlxG.debug=true;
        }
    }
}
