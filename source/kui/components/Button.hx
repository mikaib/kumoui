package kui.components;

import kui.util.TextStorage;
import kui.impl.Base;

class Button extends Component {

    private var text: TextStorage = new TextStorage(null, Style.getInstance().BUTTON_TEXT_SIZE, Style.getInstance().BUTTON_TEXT_FONT);
    private var upperCase: Bool = Style.getInstance().BUTTON_TEXT_UPPERCASE;
    private var width: Float = 0;
    
    private var clicked: Bool = false;
    private var active: Bool = false;
    private var hover: Bool = false;
 
    inline public function getButtonColor(): Int {
        if (active) return Style.getInstance().BUTTON_COLOR_ACTIVE;
        if (hover) return Style.getInstance().BUTTON_COLOR_HOVER;
        return Style.getInstance().BUTTON_COLOR;
    }

    override function onDataUpdate(data: Dynamic): Dynamic {
        text.text = (upperCase ? Std.string(data.text).toUpperCase() : data.text) ?? '';
        text.size = data.size ?? Style.getInstance().BUTTON_TEXT_SIZE;
        text.font = data.font ?? Style.getInstance().BUTTON_TEXT_FONT;
        width = data.width ?? 0;
        return clicked;
    }

    override function onRender(impl: Base) {
        impl.drawRect(getBoundsX(), getBoundsY(), getBoundsWidth(), getBoundsHeight(), getButtonColor(), Style.getInstance().BUTTON_ROUNDING);
        impl.drawText(text.getText(), getBoundsX() + (getBoundsWidth()/2) - (text.getWidth(impl)/2), getBoundsY() + ((getBoundsHeight() - text.getHeight(impl)) / 2), Style.getInstance().BUTTON_TEXT_COLOR, text.getSize(), text.getFont());
    }

    override function onMouseClick(impl:Base) clicked = true;
    override function onMouseHoverEnter(impl:Base) hover = true;
    override function onMouseHoverExit(impl:Base) hover = false;
    override function onMouseDown(impl:Base) active = true;
    override function onMouseUp(impl:Base) active = false;

    override function onLayoutUpdate(impl: Base) {
        useLayoutPosition();
        
        if (width == 0) width = text.getWidth(impl) + Style.getInstance().BUTTON_INNER_PADDING;
        setSize(width, text.getHeight(impl) + Style.getInstance().BUTTON_INNER_PADDING);

        useBoundsClipRect();
        setInteractable(true);
        submitLayoutRequest();
        clicked = false;
    }

}