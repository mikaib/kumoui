package kui.impl;

class Base {

    public function new() {}

    // Input
    public function getMouseX(): Float { return 0; }
    public function getMouseY(): Float { return 0; }
    public function getLeftMouseDown(): Bool { return false; }
    public function getRightMouseDown(): Bool { return false; }
    public function getScrollDelta(): Float { return 0; }

    // Drawing internals
    public function beginDraw(): Void {}
    public function endDraw(): Void {}
    public function getDeltaTime(): Float { return 0; }

    // Drawing
    public function drawRect(x: Float, y: Float, width: Float, height: Float, color: Int, roundness: Float = 0): Void {}
    public function drawRectOutline(x: Float, y: Float, width: Float, height: Float, color: Int, thickness: Float = 1, roundness: Float = 0): Void {}
    public function drawText(text: String, x: Float, y: Float, color: Int, size: Int = 16, font: FontType = FontType.REGULAR): Void {}
    public function drawLine(x1: Float, y1: Float, x2: Float, y2: Float, color: Int, thickness: Float = 1): Void {}
    public function measureTextWidth(text: String, size: Int = 16, font: FontType = FontType.REGULAR): Float { return 0; }
    public function measureTextHeight(text: String, size: Int = 16, font: FontType = FontType.REGULAR): Float { return size; }
    public function drawTrianglePoints(x1: Float, y1: Float, x2: Float, y2: Float, x3: Float, y3: Float, color: Int): Void {}
    public function drawTriangle(cx: Float, cy: Float, len: Float, rotation: Float, color: Int): Void {}
    public function setClipRect(x: Float, y: Float, width: Float, height: Float): Void {}
    public function drawCircle(cx: Float, cy: Float, radius: Float, color: Int): Void {}
    public function resetClipRect(): Void {}

    // Clipboard
    public function setClipboard(text: String): Void {}
    public function getClipboard(): String { return ''; }

}