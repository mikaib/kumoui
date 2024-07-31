package kui.components;

import kui.impl.Base;

class ScrollableContainer extends Component {
    
    public var innerContentHeight: Float = 0;
    public var innerContentStartY: Float = 0;
    public var innerContentEndY: Float = 0;
    public var innerOffsetY: Float = 0;
    public var targetInnerOffsetY: Float = 0;
    public var scrollHeightOffset: Float = 0;
    public var fullWidth: Float = 0;
    public var enabled: Bool = false;

    override function onDataUpdate(data:Dynamic): Dynamic {
        scrollHeightOffset = data.scrollHeightOffset ?? 0;
        return null;
    }

    override function onLayoutUpdate(impl:Base) {
        var pos = Layout.getLastPosition();
        var xOff = pos.x - KumoUI.getParentX();
        var yOff = pos.y - KumoUI.getParentY();
        var parentWidth = KumoUI.getParentWidth();
        var parentHeight = KumoUI.getParentHeight();
        var fullHeight = parentHeight - yOff;
        fullWidth = parentWidth - xOff;

        if (innerContentHeight > fullHeight && fullHeight > 0.1) {
            setClipRect(pos.x, pos.y, fullWidth - Style.SCROLL_WIDTH - (Style.GLOBAL_PADDING * 2), fullHeight);
            beginParentContainer();
            setBounds(pos.x, pos.y, fullWidth - Style.SCROLL_WIDTH - (Style.GLOBAL_PADDING * 2), fullHeight);
            innerContentStartY = getBoundsY() - innerOffsetY;
            if (targetInnerOffsetY < 0) targetInnerOffsetY = 0;
            if (targetInnerOffsetY > innerContentHeight - getBoundsHeight()) targetInnerOffsetY = innerContentHeight - getBoundsHeight();
            var da = Std.int(targetInnerOffsetY - innerOffsetY) * (impl.getDeltaTime() * Style.SCROLL_SPEED);
            innerOffsetY += Math.isNaN(da) ? 0 : da;
            enabled = true;
        } else {
            setClipRect(pos.x, pos.y, fullWidth, fullHeight);
            beginParentContainer();
            setBounds(pos.x, pos.y, fullWidth, fullHeight);
            innerContentStartY = getBoundsY();
            enabled = false;
        }        

        submitAbsolutePositioningRequest(getBoundsX(), Std.int(innerContentStartY), 0, 0);
    }

    override function onRender(impl:Base) {
        // enabled
        if (!enabled) return;

        // gutter
        var gutterX = getBoundsX() + getBoundsWidth() + Style.SCROLL_PADDING;
        var gutterY = getBoundsY() + Style.GLOBAL_PADDING;
        var gutterH = Math.max(getBoundsHeight() - (Style.GLOBAL_PADDING * 2) - scrollHeightOffset, 0);
        impl.drawRect(gutterX, gutterY, Style.SCROLL_WIDTH, gutterH, Style.SCROLL_GUTTER_COLOR, Style.SCROLL_GUTTER_ROUNDING);
        
        // scroll bar
        var percentage = innerOffsetY / innerContentHeight;
        var scrollH = Math.min(gutterH * (getBoundsHeight() / innerContentHeight), gutterH);
        var scrollY = Math.max(gutterY + gutterH * percentage, gutterY);
        impl.drawRect(gutterX, scrollY, Style.SCROLL_WIDTH, scrollH, Style.SCROLL_BAR_COLOR, Style.SCROLL_BAR_ROUNDING);
    }

    public function scroll(scrollY: Float) {
        if (!enabled) return;
        targetInnerOffsetY -= scrollY;
    }

    override function onDebugDraw(impl:Base) impl.drawRectOutline(getBoundsX(), getBoundsY(), getBoundsWidth(), getBoundsHeight(), enabled ? 0xFFFF00 : 0x6E6E00, 2);
    
}