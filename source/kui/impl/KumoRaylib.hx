package kui.impl;

import cpp.NativeArray;
import Raylib.TextureFilter;
import Raylib.Shader;
import Raylib.Image;
import Raylib.RlGlyphInfo;
import Raylib.RlFont;
import Raylib.Vector2;
import Raylib.Font;
import Raylib.Color;
import Raylib.Rectangle;
import Raylib.MouseButton;
import kui.KeyboardInput;
import kui.impl.Base;
import kui.FontType;
import kui.KumoUI;

class KumoRaylib extends Base {

    public var fontBold: Font;
    public var fontRegular: Font;
    public var shader: Shader;

    /**
     * 
     * precision mediump float;

uniform sampler2D u_texture;
uniform vec4 u_color;
uniform float u_buffer;
uniform float u_gamma;

varying vec2 v_texcoord;

void main() {
    float dist = texture2D(u_texture, v_texcoord).r;
    float alpha = smoothstep(u_buffer - u_gamma, u_buffer + u_gamma, dist);
    gl_FragColor = vec4(u_color.rgb, alpha * u_color.a);
}
     */
    public var src_fs = '
#version 330

in vec2 fragTexCoord;
in vec4 fragColor;

uniform sampler2D texture0;
uniform vec4 colDiffuse;

const float u_buffer = 0.45;
const float u_gamma = 0.40;

out vec4 finalColor;

void main()
{
    float dist = texture2D(texture0, fragTexCoord).a;
    float alpha = smoothstep(u_buffer - u_gamma, u_buffer + u_gamma, dist);
    finalColor = vec4(fragColor.rgb, alpha * fragColor.a);
}   
    ';

    public var keyMap: Map<Raylib.Keys, kui.Key> = [
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
        ZERO => KEY_0,
        ONE => KEY_1,
        TWO => KEY_2,
        THREE => KEY_3,
        FOUR => KEY_4,
        FIVE => KEY_5,
        SIX => KEY_6,
        SEVEN => KEY_7,
        EIGHT => KEY_8,
        NINE => KEY_9,

        // Symbols
        MINUS => KEY_MINUS,
        EQUAL => KEY_EQUALS,
        LEFT_BRACKET => KEY_OPEN_BRACKET,
        RIGHT_BRACKET => KEY_CLOSE_BRACKET,
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
        RIGHT_CONTROL => KEY_CTRL,
        LEFT_CONTROL => KEY_CTRL
    ];

    public function new(fontRegular: Font, fontBold: Font, usingSdf: Bool, debugDraw: Bool = false) {
        super();

        this.fontBold = fontBold;
        this.fontRegular = fontRegular;
        shader = Raylib.loadShaderFromMemory(null, src_fs);

        KumoUI.init(this, debugDraw);
    }

    // NOTE: This code WILL break at some point, either if haxe, hxcpp or raylib-hx changes, this is GOD AWFUL code.
    public static function loadFontSDF(path: String): Font {
        var fontBytes = sys.io.File.getBytes(path);
        var fontPtr: cpp.Pointer<cpp.UInt8> = NativeArray.address(fontBytes.getData(), 0);

        // NOTE: this is the hackiest code i've ever written, PERIOD.
        // This was needed because I just want to create an empty font, but the API doesn't allow it
        // Thus we use the underlying bits of raylib-hx to create a font with the data we want
        // But loadFontData returns a pointer to the data, and RLGlyphInfo is not one, using cpp.Star<RlGlyphInfo> instead causes it to try and get the pointer to the pointer, which is not what we want
        // So we use this BIG HACK to make sure the haxe compiler can't do anything with this code.
        var fontData: cpp.Star<RlGlyphInfo> = untyped __cpp__("{0}", Raylib.loadFontData(cast fontPtr, fontBytes.length, 64, 0, 0, Raylib.FontType.SDF));

        // Again, we cannot init an empty font, so we have to create it with the data we want
        var font: RlFont = untyped __cpp__("{ 0 }");
        font.baseSize = 64;
        font.glyphCount = 95;
        font.glyphs = fontData;

        // haxe wants to be smart again.
        var glyphs: cpp.Star<RlGlyphInfo> = untyped __cpp__("{0}", font.glyphs);

        // Create the atlas, make a Rectangle ** and stuff
        var atlas: Image = Raylib.genImageFontAtlas(glyphs, untyped __cpp__("&{0}", font.recs), 95, 64, 4, 1);

        // Set the texture to the font
        font.texture = Raylib.loadTextureFromImage(atlas);
        Raylib.setTextureFilter(font.texture, TextureFilter.BILINEAR);
        //Raylib.genTextureMipmaps(font.texture);

        // Finally, unload the image
        Raylib.unloadImage(atlas);

        // Done with this mess!
        return font;
    }

    // Input
    override public function getMouseX(): Float return Raylib.getMouseX();
    override public function getMouseY(): Float return Raylib.getMouseY();
    override public function getLeftMouseDown(): Bool return Raylib.isMouseButtonDown(MouseButton.LEFT);
    override public function getRightMouseDown(): Bool return Raylib.isMouseButtonDown(MouseButton.RIGHT);
    override public function getScrollDelta():Float return Raylib.getMouseWheelMove() * 50;

    // Drawing Internals
    override public function beginDraw(): Void {}
    override public function endDraw(): Void {}
    override public function getDeltaTime(): Float return Raylib.getFrameTime();

    // Utils
    inline public function getRoundingPixels(surfaceWidth: Float, surfaceHeight: Float, rounding: Float) {
        var minAxis = Math.min(surfaceWidth, surfaceHeight);
        var roundness = rounding / (minAxis / 2);
        return roundness;
    }

    inline public function getColorFromInt(color: Int) {
        if (color > 0xFFFFFF) return Color.create(
            (color >> 16) & 0xFF,
            (color >> 8) & 0xFF,
            color & 0xFF,
            (color >> 24) & 0xFF
        ) else return Color.create(
            (color >> 16) & 0xFF,
            (color >> 8) & 0xFF,
            color & 0xFF,
            255
        );
    }

    inline public function rotatePoint(px:Float, py:Float, cx:Float, cy:Float, cosTheta:Float, sinTheta:Float):Vector2 {
        var dx = px - cx;
        var dy = py - cy;
        var newX = cx + dx * cosTheta - dy * sinTheta;
        var newY = cy + dx * sinTheta + dy * cosTheta;
        return Vector2.create(newX, newY);
    }

    inline public function signedArea(x1:Float, y1:Float, x2:Float, y2:Float, x3:Float, y3:Float):Float {
        return (x1 - x3) * (y2 - y3) - (x2 - x3) * (y1 - y3);
    }

    // Drawing
    override public function drawRect(x: Float, y: Float, width: Float, height: Float, color: Int, roundness: Float = 0): Void {
        if (roundness > 0) Raylib.drawRectangleRounded(Rectangle.create(x, y, width, height), getRoundingPixels(width, height, roundness), 15, getColorFromInt(color));
        else Raylib.drawRectangle(Std.int(x), Std.int(y), Std.int(width), Std.int(height), getColorFromInt(color));
    }

    override function drawRectOutline(x:Float, y:Float, width:Float, height:Float, color:Int, thickness:Float = 1, roundness:Float = 0) {
        // NOTE: drawRectangleLines doesn't have thickness, wat?
        Raylib.drawRectangleRoundedLines(Rectangle.create(x, y, width, height), getRoundingPixels(width, height, roundness), 15, Std.int(thickness), getColorFromInt(color));
    }

    override public function drawText(text: String, x: Float, y: Float, color: Int, size: Int = 16, font: FontType = FontType.REGULAR): Void {
        Raylib.beginShaderMode(shader);
        Raylib.drawTextEx(font == FontType.REGULAR ? fontRegular : fontBold, text, Vector2.create(Std.int(x), Std.int(y)), size, 0, getColorFromInt(color));
        Raylib.endShaderMode();
    }

    override public function measureTextWidth(text: String, size: Int = 16, font: FontType = FontType.REGULAR): Float {
        var res = Raylib.measureTextEx(font == FontType.REGULAR ? fontRegular : fontBold, text, size, 0);
        return res.x; // NOTE: doing this inline doesn't work?
    }

    override public function drawLine(x1: Float, y1: Float, x2: Float, y2: Float, color: Int, thickness: Float = 1): Void {
        Raylib.drawLineEx(Vector2.create(x1, y1), Vector2.create(x2, y2), thickness, getColorFromInt(color));
    }

    override public function setClipRect(x: Float, y: Float, width: Float, height: Float): Void {
        Raylib.beginScissorMode(Std.int(x), Std.int(y), Std.int(width), Std.int(height));
    }

    override function drawTriangle(cx:Float, cy:Float, len: Float, rotation:Float, color:Int) {
        var height = Math.sqrt(3) / 2 * len;

        var x1 = cx - len / 2;
        var y1 = cy + height / 3;
        var x2 = cx + len / 2;
        var y2 = cy + height / 3;
        var x3 = cx;
        var y3 = cy - 2 * height / 3;

        var cosTheta = Math.cos(rotation);
        var sinTheta = Math.sin(rotation);

        var p1 = rotatePoint(x1, y1, cx, cy, cosTheta, sinTheta);
        var p2 = rotatePoint(x2, y2, cx, cy, cosTheta, sinTheta);
        var p3 = rotatePoint(x3, y3, cx, cy, cosTheta, sinTheta);

        Raylib.drawTriangle(p1, p2, p3, getColorFromInt(color));
    }

    override function drawTrianglePoints(x1:Float, y1:Float, x2:Float, y2:Float, x3:Float, y3:Float, color:Int) {
        // NOTE: Raylib requires the points to be in counter-clockwise order, so we check the signed area to determine the order of the input and then draw the points in the correct order (CCW)
        if (signedArea(x1, y1, x2, y2, x3, y3) < 0) Raylib.drawTriangle(Vector2.create(x1, y1), Vector2.create(x2, y2), Vector2.create(x3, y3), getColorFromInt(color));
        else Raylib.drawTriangle(Vector2.create(x1, y1), Vector2.create(x3, y3), Vector2.create(x2, y2), getColorFromInt(color));
    }

    override public function drawCircle(cx: Float, cy: Float, radius: Float, color: Int): Void {
        Raylib.drawCircle(Std.int(cx), Std.int(cy), radius, getColorFromInt(color));
    }

    override public function resetClipRect(): Void {
        Raylib.endScissorMode();
    }
    
    override public function setClipboard(text: String): Void Raylib.setClipboardText(text);
    override public function getClipboard(): String return Raylib.getClipboardText();

    // Begin-end
    public function begin() {
        KumoUI.begin(Raylib.getScreenWidth(), Raylib.getScreenHeight());
        KeyboardInput.setCurrentShiftMod(Raylib.isKeyDown(Raylib.Keys.LEFT_SHIFT) || Raylib.isKeyDown(Raylib.Keys.RIGHT_SHIFT));
        KeyboardInput.setCurrentCapsMod(Raylib.isKeyDown(Raylib.Keys.CAPS_LOCK));
        
        // NOTE: getCharPressed would be ideal, but it makes it really annoying to work with.
        for (key in keyMap.keys()) {
            if (Raylib.isKeyDown(key)) KeyboardInput.reportKey(keyMap.get(key));
        }

        KeyboardInput.submit();
    }

    public function end() {
        KumoUI.render();
    }

}