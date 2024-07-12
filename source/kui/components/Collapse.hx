package kui.components;

import kui.util.TextStorage;
import kui.impl.Base;

class Collapse extends Component {

    private var text: TextStorage = new TextStorage(null, Style.COLLAPSE_TEXT_SIZE, Style.COLLAPSE_TEXT_FONT);
    private var upperCase: Bool = Style.COLLAPSE_TEXT_UPPERCASE;
    
    private var active: Bool = false;
    private var hover: Bool = false;
    private var expanded: Bool = false;
 
    public inline function toRad(deg: Float): Float return deg * Math.PI / 180;

    inline public function getButtonColor(): Int {
        if (active) return Style.COLLAPSE_COLOR_ACTIVE;
        if (hover) return Style.COLLAPSE_COLOR_HOVER;
        return Style.COLLAPSE_COLOR;
    }

    override function onDataUpdate(data: Dynamic): Dynamic {
        text.text = (upperCase ? Std.string(data.text).toUpperCase() : data.text) ?? text.text; 
        text.size = data.size ?? Style.COLLAPSE_TEXT_SIZE;
        text.font = data.font ?? Style.COLLAPSE_TEXT_FONT;  
        expanded = data.expanded ?? expanded;
        return expanded;
    }

    override function onSerialize():Dynamic return { expanded: expanded };

    override function onRender(impl: Base) {
        impl.drawRect(getBoundsX(), getBoundsY(), getBoundsWidth(), getBoundsHeight(), getButtonColor(), Style.COLLAPSE_ROUNDING);
        impl.drawText(text.getText(), getBoundsX() + text.getSize() + (Style.GLOBAL_PADDING * 2), getBoundsY() + ((getBoundsHeight() - text.getHeight(impl)) / 2), Style.COLLAPSE_TEXT_COLOR, text.getSize(), text.getFont());
        impl.drawTriangle(
            getBoundsX() + Style.GLOBAL_PADDING * 2, 
            getBoundsY() + (getBoundsHeight() / 2) - (expanded ? text.getSize() / 8 : 0),
            text.getSize(), expanded ? toRad(180) : toRad(90), 
            Style.COLLAPSE_TEXT_COLOR);
    }

    override function onMouseClick(impl:Base) expanded = !expanded;
    override function onMouseHoverEnter(impl:Base) hover = true;
    override function onMouseHoverExit(impl:Base) hover = false;
    override function onMouseDown(impl:Base) active = true;
    override function onMouseUp(impl:Base) active = false;

    override function onLayoutUpdate(impl: Base) {
        useLayoutPosition();
        setSize(KumoUI.getParentWidth() - (getBoundsX() - KumoUI.getParentX()) - Style.GLOBAL_PADDING, text.getHeight(impl) + Style.COLLAPSE_INNER_PADDING);
        useBoundsClipRect();
        setInteractable(true);
        setSerializable(true);
        submitLayoutRequest();
    }

}