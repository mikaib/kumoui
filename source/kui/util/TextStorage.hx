package kui.util;

import kui.impl.Base;

/**
 * This class is useful for wherever we need to know the size of a text before rendering it.
 * This class will automatically cache the text width and only recompute it when the text, size or font changes.
 * This does not benefit you if you do not require to know the text width.
 */
class TextStorage {

    /**
     * Create a new `TextStorage` instance.
     * @param text The text to store.
     * @param size The size of the text.
     * @param font The font of the text.
     */
    public function new(?text: String, ?size: Int, ?font: FontType) {
        this.text = text ?? this.text;
        this.size = size ?? this.size;
        this.font = font ?? this.font;
    }

    // Parameters
    public var color: Int = Style.getInstance().TEXT_DEFAULT_COLOR;
    public var size: Int = Style.getInstance().TEXT_DEFAULT_SIZE;
    public var font: FontType = Style.getInstance().TEXT_DEFAULT_FONT;
    public var text: String = '';

    // Previous state
    private var _prevSize: Int = 0;
    private var _prevFont: FontType = FontType.REGULAR;
    private var _prevText: String = '';
    private var _textWidth: Float = 0;
    private var _textHeight: Float = 0;

    /**
     * Get the text.
     * @return The text.
     */
    public inline function getText(): String {
        return text;
    }
    
    /**
     * Get the size.
     * @return The size.
     */
    public inline function getSize(): Int {
        return size;
    }

    /**
     * Get the color.
     * @return The color.
     */
    public inline function getColor(): Int {
        return color;
    }

    /**
     * Get the font.
     * @return The font.
     */
    public inline function getFont(): FontType {
        return font;
    }

    /**
     * Gets the height, if the text state is outdated, it will recompute the text dimensions.
     * @param impl The implementation to use.
     * @return The height of the text.
     */
    public inline function getHeight(impl: Base): Float {
        updateTextSize(impl);
        return _textHeight;
    }

    /**
     * Gets the width, if the text state is outdated, it will recompute the text dimensions.
     * @param impl The implementation to use.
     * @return The width of the text.
     */
    public inline function getWidth(impl: Base): Float {
        updateTextSize(impl);
        return _textWidth;
    }

    /**
     * Update the text size if the text state is outdated.
     * @param impl The implementation to use.
     */
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