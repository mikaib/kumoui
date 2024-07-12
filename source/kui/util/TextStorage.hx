package kui.util;

import kui.impl.Base;

/**
 * This class is useful for wherever we need to know the size of a text before rendering it.
 * This class will automatically cache the text width and only recompute it when the text, size or font changes.
 * This does not benefit you if you do not require to know the text width.
 */
class TextStorage {
    
    public function new(?text: String, ?size: Int, ?font: FontType) {
        this.text = text ?? this.text;
        this.size = size ?? this.size;
        this.font = font ?? this.font;
    }

    public var color: Int = Style.TEXT_DEFAULT_COLOR;
    public var size: Int = Style.TEXT_DEFAULT_SIZE;
    public var font: FontType = Style.TEXT_DEFAULT_FONT;
    public var text: String = '';

    private var _prevSize: Int = 0;
    private var _prevFont: FontType = FontType.REGULAR;
    private var _prevText: String = '';
    private var _textWidth: Float = 0;
    private var _textHeight: Float = 0;

    public inline function getText(): String return text;
    public inline function getSize(): Int return size;
    public inline function getColor(): Int return color;
    public inline function getFont(): FontType return font;
    public inline function getHeight(impl: Base): Float {
        updateTextSize(impl);
        return _textHeight;
    }
    public inline function getWidth(impl: Base): Float {
        updateTextSize(impl);
        return _textWidth;
    }
    public inline function updateTextSize(impl: Base) {
        if (_prevSize != size || _prevFont != font || _prevText != text) {
            _textWidth = impl.measureTextWidth(text, size, font);
            _textHeight = impl.measureTextHeight(text, size, font);
            _prevSize = size;
            _prevFont = font;
            _prevText = text;
        }
    }

}