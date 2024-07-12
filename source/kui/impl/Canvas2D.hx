package kui.impl;

import kawaii.resources.ResourceFont;
import kawaii.input.InputMouseButton;
import kawaii.Application;
import kawaii.rendering.Context2D;

class KawaiiFramework extends Base {

    public var c: Context2D;
    public var app: Application;

    public var font_regular: ResourceFont;
    public var font_bold: ResourceFont;

    public function new(regularFont: ResourceFont, boldFont: ResourceFont, debugDraw: Bool = false) {
        super();

        app = Application.getInstance();
        this.font_regular = regularFont;
        this.font_bold = boldFont;
        
        KumoUI.init(this, debugDraw);
    }

    // Input
    override public function getMouseX(): Float return app.input.getMouseX();
    override public function getMouseY(): Float return app.input.getMouseY();
    override public function getLeftMouseDown(): Bool return app.input.isMouseDown(InputMouseButton.LEFT);
    override public function getRightMouseDown(): Bool return app.input.isMouseDown(InputMouseButton.RIGHT);
    override public function getScrollDelta():Float return app.input.getMouseScrollY() * 50;

    // Drawing Internals
    override public function beginDraw(): Void {}
    override public function endDraw(): Void {}
    override public function getDeltaTime(): Float return 1 / app.fps;

    // Drawing
    override public function drawRect(x: Float, y: Float, width: Float, height: Float, color: Int, roundness: Float = 0): Void {

    }

    override function drawRectOutline(x:Float, y:Float, width:Float, height:Float, color:Int, thickness:Float = 1, roundness:Float = 0) {

    }

    override public function drawText(text: String, x: Float, y: Float, color: Int, size: Int = 16, font: FontType = FontType.REGULAR): Void {

    }

    override public function measureTextWidth(text: String, size: Int = 16, font: FontType = FontType.REGULAR): Float {
    
    }

    override public function drawLine(x1: Float, y1: Float, x2: Float, y2: Float, color: Int, thickness: Float = 1): Void {

    }

    override public function setClipRect(x: Float, y: Float, width: Float, height: Float): Void {

    }

    override function drawTriangle(cx:Float, cy:Float, len: Float, rotation:Float, color:Int) {
    
    }

    override public function drawCircle(cx: Float, cy: Float, radius: Float, color: Int): Void {

    }

    override public function resetClipRect(): Void {
        
    }
    
    // Kawaii-specific
    public function setContext(c: Context2D) this.c = c;

    public function begin(c: Context2D) {
        setContext(c);
        //KumoUI.begin(app.window.getWidth(), app.window.getHeight());
    }

    public function end() {}

}