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
        innerOffsetY = data.innerOffsetY ?? innerOffsetY;
        targetInnerOffsetY = data.targetInnerOffsetY ?? targetInnerOffsetY;
        scrollHeightOffset = data.scrollHeightOffset ?? scrollHeightOffset;
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
        setSerializable(true);

        if (innerContentHeight > fullHeight && fullHeight > 0.1) {
            setClipRect(pos.x, pos.y, fullWidth - Style.getInstance().SCROLL_WIDTH - (Style.getInstance().SCROLL_HPADDING * 2), fullHeight);
            beginParentContainer();
            setBounds(pos.x, pos.y, fullWidth - Style.getInstance().SCROLL_WIDTH - (Style.getInstance().SCROLL_HPADDING * 2), fullHeight);
            innerContentStartY = getBoundsY() - innerOffsetY;
            if (targetInnerOffsetY < 0) targetInnerOffsetY = 0;
            if (targetInnerOffsetY > innerContentHeight - getBoundsHeight()) targetInnerOffsetY = innerContentHeight - getBoundsHeight();
            var da = Std.int(targetInnerOffsetY - innerOffsetY) * (impl.getDeltaTime() * Style.getInstance().SCROLL_SPEED);
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
        var gutterX = getBoundsX() + getBoundsWidth() + Style.getInstance().SCROLL_HPADDING;
        var gutterY = getBoundsY() + Style.getInstance().SCROLL_VPADDING;
        var gutterH = Math.max(getBoundsHeight() - (Style.getInstance().SCROLL_VPADDING * 2) - scrollHeightOffset, 0);
        impl.drawRect(gutterX, gutterY, Style.getInstance().SCROLL_WIDTH, gutterH, Style.getInstance().SCROLL_GUTTER_COLOR, Style.getInstance().SCROLL_GUTTER_ROUNDING);
        
        // scroll bar
        var percentage = innerOffsetY / innerContentHeight;
        var scrollH = Math.min(gutterH * (getBoundsHeight() / innerContentHeight), gutterH);
        var scrollY = Math.max(gutterY + gutterH * percentage, gutterY);
        impl.drawRect(gutterX, scrollY, Style.getInstance().SCROLL_WIDTH, scrollH, Style.getInstance().SCROLL_BAR_COLOR, Style.getInstance().SCROLL_BAR_ROUNDING);
    }

    public function scroll(scrollY: Float) {
        if (!enabled) return;
        targetInnerOffsetY -= scrollY;
    }

    override function onSerialize():Dynamic {
        return { 
            innerOffsetY: innerOffsetY,
            targetInnerOffsetY: targetInnerOffsetY,
            scrollHeightOffset: scrollHeightOffset
        };
    }

    override function onDebugDraw(impl:Base) impl.drawRectOutline(getBoundsX(), getBoundsY(), getBoundsWidth(), getBoundsHeight(), enabled ? 0xFFFF00 : 0x6E6E00, 2);
    
}