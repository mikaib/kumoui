package kui.impl;

class Base {

    // Input
    public function getMouseX(): Float { return 0; }
    public function getMouseY(): Float { return 0; }
    public function getLeftMouseDown(): Bool { return false; }
    public function getRightMouseDown(): Bool { return false; }

    // Drawing internals
    public function beginDraw(): Void {}
    public function endDraw(): Void {}

    // Drawing
    public function drawRect(x: Float, y: Float, width: Float, height: Float, color: Int, roundness: Float = 0): Void {}
    public function drawRectOutline(x: Float, y: Float, width: Float, height: Float, color: Int, thickness: Float = 1): Void {}
    public function drawText(text: String, x: Float, y: Float, color: Int, size: Int = 16, font: FontType = FontType.REGULAR): Void {}
    public function measureTextWidth(text: String, size: Int = 16, font: FontType = FontType.REGULAR): Float { return 0; }
    public function setClipRect(x: Float, y: Float, width: Float, height: Float): Void {}
    public function resetClipRect(): Void {}
    
}