package kui.impl;

import kawaii.input.InputKey;
import kawaii.resources.ResourceFont;
import kawaii.input.InputMouseButton;
import kawaii.Application;
import kawaii.rendering.Context2D;

class KawaiiFramework extends Base {

    public var c: Context2D;
    public var app: Application;

    public var font_regular: ResourceFont;
    public var font_bold: ResourceFont;

    private var keyMap: Map<kawaii.input.InputKey, kui.Key> = [
        // Letters
        A => KEY_A,
        B => KEY_B,
        C => KEY_C,
        D => KEY_D,
        E => KEY_E,
        F => KEY_F,
        G => KEY_G,
        H => KEY_H,
        I => KEY_I,
        J => KEY_J,
        K => KEY_K,
        L => KEY_L,
        M => KEY_M,
        N => KEY_N,
        O => KEY_O,
        P => KEY_P,
        Q => KEY_Q,
        R => KEY_R,
        S => KEY_S,
        T => KEY_T,
        U => KEY_U,
        V => KEY_V,
        W => KEY_W,
        X => KEY_X,
        Y => KEY_Y,
        Z => KEY_Z,
    
        // Numbers
        ONE => KEY_1,
        TWO => KEY_2,
        THREE => KEY_3,
        FOUR => KEY_4,
        FIVE => KEY_5,
        SIX => KEY_6,
        SEVEN => KEY_7,
        EIGHT => KEY_8,
        NINE => KEY_9,
        ZERO => KEY_0,
    
        // Symbols (if needed you can add more)
        MINUS => KEY_MINUS,
        EQUALS => KEY_EQUALS,
        LEFTBRACKET => KEY_OPEN_BRACKET,
        RIGHTBRACKET => KEY_CLOSE_BRACKET,
        BACKSLASH => KEY_BACKSLASH,
        SEMICOLON => KEY_SEMICOLON,
        APOSTROPHE => KEY_SINGLE_QUOTE,
        GRAVE => KEY_GRAVE,
        COMMA => KEY_COMMA,
        PERIOD => KEY_PERIOD,
        SLASH => KEY_SLASH,
    
        // Special keys
        ESCAPE => KEY_ESCAPE,
        SPACE => KEY_SPACE,
        ENTER => KEY_ENTER,
        TAB => KEY_TAB,
        BACKSPACE => KEY_BACKSPACE,
        LEFT => KEY_LEFT,
        RIGHT => KEY_RIGHT,
        UP => KEY_UP,
        DOWN => KEY_DOWN,
        END => KEY_END,
        HOME => KEY_HOME,
    ];
    

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
        c.setColor(color);
        c.fillRoundRect(x, y, width, height, roundness);
    }

    override function drawRectOutline(x:Float, y:Float, width:Float, height:Float, color:Int, thickness:Float = 1, roundness:Float = 0) {
        c.setColor(color);
        c.setThickness(thickness);
        c.drawRoundRect(x, y, width, height, roundness);
        c.setThickness(1);
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

    override public function drawLine(x1: Float, y1: Float, x2: Float, y2: Float, color: Int, thickness: Float = 1): Void {
        c.setColor(color);
        c.setThickness(thickness);
        c.drawLine(x1, y1, x2, y2);
        c.setThickness(1);
    }

    override public function setClipRect(x: Float, y: Float, width: Float, height: Float): Void {
        c.setClip(x, y, width, height);
    }

    override function drawTriangle(cx:Float, cy:Float, len: Float, rotation:Float, color:Int) {
        c.setColor(color);
        var height = Math.sqrt(3) / 2 * len;
    
        var x1 = cx - len / 2;
        var y1 = cy + height / 3;
        var x2 = cx + len / 2;
        var y2 = cy + height / 3;
        var x3 = cx;
        var y3 = cy - 2 * height / 3;

        c.pushTranslation(cx, cy);
        c.pushRotation(rotation);
        c.popTranslation();
    
        c.fillTriangle(
            x1, y1,
            x2, y2,
            x3, y3
        );
    
        c.popRotation();
    }

    override function drawTrianglePoints(x1:Float, y1:Float, x2:Float, y2:Float, x3:Float, y3:Float, color:Int) {
        c.setColor(color);
        c.fillTriangle(x1, y1, x2, y2, x3, y3);
    }

    override public function drawCircle(cx: Float, cy: Float, radius: Float, color: Int): Void {
        c.setColor(color);
        c.fillCircle(cx, cy, radius);
    }

    override public function resetClipRect(): Void {
        c.resetClip();
    }
    
    override public function setClipboard(text: String): Void app.window.setClipboardText(text);
    override public function getClipboard(): String return app.window.getClipboardText();

    // Kawaii-specific
    public function setContext(c: Context2D) this.c = c;
    public function begin(c: Context2D) {
        setContext(c);
        KumoUI.begin(app.window.getWidth(), app.window.getHeight());

        KeyboardInput.setCurrentShiftMod(app.input.isShiftDown());
        KeyboardInput.setCurrentCapsMod(app.input.isCapsLockEnabled());
        if (app.input.isCtrlDown()) KeyboardInput.reportKey(KEY_CTRL);
        for (keyDown in app.input.getAllDownKeys()) KeyboardInput.reportKey(keyMap[keyDown]);
        KeyboardInput.submit();
    }
    public function end() {
        KumoUI.render();
    }

}