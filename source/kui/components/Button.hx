package kui.components;

import kui.util.TextStorage;
import kui.impl.Base;

class Button extends Component {

    private var text: TextStorage = new TextStorage(null, Style.BUTTON_TEXT_SIZE, Style.BUTTON_TEXT_FONT);
    private var upperCase: Bool = Style.BUTTON_TEXT_UPPERCASE;
    private var fullWidth: Bool = false;
    
    private var clicked: Bool = false;
    private var active: Bool = false;
    private var hover: Bool = false;
 
    inline public function getButtonColor(): Int {
        if (active) return Style.BUTTON_COLOR_ACTIVE;
        if (hover) return Style.BUTTON_COLOR_HOVER;
        return Style.BUTTON_COLOR;
    }

    override function onDataUpdate(data: Dynamic): Dynamic {
        text.text = (upperCase ? Std.string(data.text).toUpperCase() : data.text) ?? text.text; 
        text.size = data.size ?? Style.BUTTON_TEXT_SIZE;
        text.font = data.font ?? Style.BUTTON_TEXT_FONT;
        fullWidth = data.fullWidth ?? false;
        return clicked;
    }

    override function onRender(impl: Base) {
        impl.drawRect(getBoundsX(), getBoundsY(), getBoundsWidth(), getBoundsHeight(), getButtonColor(), Style.BUTTON_ROUNDING);
        impl.drawText(text.getText(), getBoundsX() + (getBoundsWidth()/2) - (text.getWidth(impl)/2), getBoundsY() + ((getBoundsHeight() - text.getHeight(impl)) / 2), Style.BUTTON_TEXT_COLOR, text.getSize(), text.getFont());
    }

    override function onMouseClick(impl:Base) clicked = true;
    override function onMouseHoverEnter(impl:Base) hover = true;
    override function onMouseHoverExit(impl:Base) hover = false;
    override function onMouseDown(impl:Base) active = true;
    override function onMouseUp(impl:Base) active = false;

    override function onLayoutUpdate(impl: Base) {
        useLayoutPosition();
    
        var width = text.getWidth(impl) + Style.BUTTON_INNER_PADDING;
        if (fullWidth) width = KumoUI.getParentWidth() - (getBoundsX() - KumoUI.getParentX()) - Style.GLOBAL_PADDING;

        setSize(width, text.getHeight(impl) + Style.BUTTON_INNER_PADDING);

        useBoundsClipRect();
        setInteractable(true);
        submitLayoutRequest();
        clicked = false;
    }

}