package kui.impl;

import RayLib.FontRef;
import RayLib.Vector2;
import RayLib.ColorRef;
import RayLib.Color;
import RayLib.Rectangle;
import RayLib.MouseButton;

class RayLibImpl extends Base {

    public var font_regular: FontRef;
    public var font_bold: FontRef;

    public function new(regularFont: FontRef, boldFont: FontRef) {
        this.font_regular = regularFont;
        this.font_bold = boldFont;

        KumoUI.init();
    }

    // Input
    override public function getMouseX(): Float return std.RayLib.GetMouseX();
    override public function getMouseY(): Float return std.RayLib.GetMouseY();
    override public function getLeftMouseDown(): Bool return std.RayLib.IsMouseButtonDown(MouseButton.LEFT);
    override public function getRightMouseDown(): Bool return std.RayLib.IsMouseButtonDown(MouseButton.RIGHT);

    // Drawing Internals
    override public function beginDraw(): Void {}
    override public function endDraw(): Void {}

    private function rlColor(color: Int): ColorRef {
        if (color > 0xFFFFFF) {
            var a = (color >> 24) & 0xFF;
            var r = (color >> 16) & 0xFF;
            var g = (color >> 8) & 0xFF;
            var b = color & 0xFF;

            return Color.create(r, g, b, a);
        } else {
            var r = (color >> 16) & 0xFF;
            var g = (color >> 8) & 0xFF;
            var b = color & 0xFF;

            return Color.create(r, g, b, 255);
        }
    }

    // Drawing
    override public function drawRect(x: Float, y: Float, width: Float, height: Float, color: Int, roundness: Float = 0): Void {
        std.RayLib.DrawRectangle(Std.int(x), Std.int(y), Std.int(width), Std.int(height), rlColor(color));
    }

    override function drawRectOutline(x:Float, y:Float, width:Float, height:Float, color:Int, thickness:Float = 1) {
        std.RayLib.DrawRectangleLinesEx(Rectangle.create(x, y, width, height), thickness, rlColor(color));
    }

    override public function drawText(text: String, x: Float, y: Float, color: Int, size: Int = 16, font: FontType = FontType.REGULAR): Void {
        std.RayLib.DrawTextEx(font == FontType.REGULAR ? font_regular : font_bold, text, Vector2.create(x, y), size, 0, rlColor(color));
    }

    override public function measureTextWidth(text: String, size: Int = 16, font: FontType = FontType.REGULAR): Float {
        return std.RayLib.MeasureTextEx(font == FontType.REGULAR ? font_regular : font_bold, text, size, 0).x;
    }

    override public function setClipRect(x: Float, y: Float, width: Float, height: Float): Void {
        std.RayLib.BeginScissorMode(Std.int(x), Std.int(y), Std.int(width), Std.int(height));
    }

    override public function resetClipRect(): Void {
        std.RayLib.EndScissorMode();
    }
 
    // Kawaii-specific
    public function render() {
        KumoUI.render(this, std.RayLib.GetScreenWidth(), std.RayLib.GetScreenHeight());
    }

}