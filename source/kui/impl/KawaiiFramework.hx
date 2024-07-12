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

    public function new(regularFont: ResourceFont, boldFont: ResourceFont) {
        app = Application.getInstance();
        this.font_regular = regularFont;
        this.font_bold = boldFont;
        
        KumoUI.init();
    }

    // Input
    override public function getMouseX(): Float return app.input.getMouseX();
    override public function getMouseY(): Float return app.input.getMouseY();
    override public function getLeftMouseDown(): Bool return app.input.isMouseDown(InputMouseButton.LEFT);
    override public function getRightMouseDown(): Bool return app.input.isMouseDown(InputMouseButton.RIGHT);

    // Drawing Internals
    override public function beginDraw(): Void {}
    override public function endDraw(): Void {}

    // Drawing
    override public function drawRect(x: Float, y: Float, width: Float, height: Float, color: Int, roundness: Float = 0): Void {
        c.setColor(color);
        c.fillRoundRect(x, y, width, height, roundness);
    }

    override function drawRectOutline(x:Float, y:Float, width:Float, height:Float, color:Int, thickness:Float = 1) {
        c.setColor(color);
        c.drawRect(x, y, width, height);
    }

    override public function drawText(text: String, x: Float, y: Float, color: Int, size: Int = 16, font: FontType = FontType.REGULAR): Void {
        c.setColor(color);
        c.setFont(font == FontType.REGULAR ? font_regular : font_bold);
        c.setFontSize(size);
        c.drawText(text, x, y);
    }

    override public function measureTextWidth(text: String, size: Int = 16, font: FontType = FontType.REGULAR): Float {
        c.setFont(font == FontType.REGULAR ? font_regular : font_bold);
        c.setFontSize(size);
        return c.measureText(text);
    }

    override public function setClipRect(x: Float, y: Float, width: Float, height: Float): Void {
        c.pushClip(x, y, width, height);
    }

    override public function resetClipRect(): Void {
        c.popClip();
    }
 
    // Kawaii-specific
    public function setContext(c: Context2D) this.c = c;
    public function render(c: Context2D) {
        setContext(c);
        KumoUI.render(this, app.window.getWidth(), app.window.getHeight());
    }

}