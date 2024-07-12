package kui.components;

import kui.util.TextStorage;
import kui.impl.Base;

class TreeCollapse extends Component {

    private var text: TextStorage = new TextStorage(null, Style.TREECOLLAPSE_TEXT_SIZE, Style.TREECOLLAPSE_TEXT_FONT);
    private var upperCase: Bool = Style.TREECOLLAPSE_TEXT_UPPERCASE;
    
    private var active: Bool = false;
    private var hover: Bool = false;
    public var expanded: Bool = false;
    public var innerContentHeight: Float = 0;
 
    public inline function toRad(deg: Float): Float return deg * Math.PI / 180;

    override function onDataUpdate(data: Dynamic): Dynamic {
        text.text = (upperCase ? Std.string(data.text).toUpperCase() : data.text) ?? text.text; 
        text.size = data.size ?? Style.TEXT_DEFAULT_SIZE;
        text.font = data.font ?? Style.TEXT_DEFAULT_FONT;
        expanded = data.expanded ?? expanded;
        return expanded;
    }
    
    override function onRender(impl: Base) {
        impl.drawText(text.getText(), getBoundsX() + text.getSize() + Style.GLOBAL_PADDING * 2, getBoundsY(), Style.TREECOLLAPSE_TEXT_COLOR, text.getSize(), text.getFont());
        impl.drawTriangle(
            getBoundsX() + Style.GLOBAL_PADDING * 2, 
            getBoundsY() + (getBoundsHeight() / 2) - (expanded ? text.getSize() / 8 : 0),
            text.getSize(), expanded ? toRad(180) : toRad(90), 
            Style.TREECOLLAPSE_TEXT_COLOR);
    }

    override function onSerialize():Dynamic return { expanded: expanded };

    override function onMouseClick(impl:Base) expanded = !expanded;
    override function onMouseHoverEnter(impl:Base) hover = true;
    override function onMouseHoverExit(impl:Base) hover = false;
    override function onMouseDown(impl:Base) active = true;
    override function onMouseUp(impl:Base) active = false;

    override function onLayoutUpdate(impl: Base) {
        useLayoutPosition();
        setSize(text.getWidth(impl) + text.getSize() + Style.GLOBAL_PADDING * 3, text.getHeight(impl));
        setInteractable(true);
        setSerializable(true);
        submitLayoutRequest();
        setClipRect(getBoundsX(), getBoundsY(), Math.POSITIVE_INFINITY, getBoundsHeight() + (expanded ? innerContentHeight : 0)); // Gets
        beginParentContainer();
        submitAbsolutePositioningRequest(getBoundsX() + Style.TREECOLLAPSE_INDENT, getBoundsY() + getBoundsHeight(), 0, 0);
    }

}