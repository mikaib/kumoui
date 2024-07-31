package kui.components;

import kui.impl.Base;

class Window extends Component {

    private var title: String = '';
    private var x: Float = 0;
    private var y: Float = 0;
    private var width: Float = 300;
    private var height: Float = 200;
    private var collapsed: Bool = false;

    private var isDragging: Bool = false;
    private var dragOffsetX: Float = 0;
    private var dragOffsetY: Float = 0;

    private var resizeGripOver: Bool = false;
    private var isResizing: Bool = false;
    private var resizeOffsetX: Float = 0;
    private var resizeOffsetY: Float = 0;

    private var animTargetHeight: Float = 0;
    private var animCurrentHeight: Null<Float> = null;

    public inline function toRad(deg: Float): Float return deg * Math.PI / 180;

    override function onDataUpdate(data: Dynamic): Dynamic {
        title = data.title ?? '';
        x = data.x ?? x;
        y = data.y ?? y;
        width = data.width ?? width;
        height = data.height ?? height;
        if (data.collapsed != null) setCollapsedState(data.collapsed);

        if (animCurrentHeight == null) {
            animCurrentHeight = height;
            animTargetHeight = height;
        }

        return null;
    }

    override function onLayoutUpdate(impl: Base) {
        if (isDragging) {
            x = impl.getMouseX() - dragOffsetX;
            y = impl.getMouseY() - dragOffsetY;
        }

        if (isResizing) {
            width = Math.max(impl.getMouseX() - x + resizeOffsetX, Style.WINDOW_MIN_WIDTH);
            height = Math.max(impl.getMouseY() - y + resizeOffsetY, Style.WINDOW_HEADER_HEIGHT);
            animTargetHeight = height;
            animCurrentHeight = height;
        }

        var da = (animTargetHeight - animCurrentHeight) * (impl.getDeltaTime() * Style.WINDOW_COLLAPSE_SPEED);
        animCurrentHeight += Math.isNaN(da) ? 0 : da;

        setPriorityWeight(KumoUI.getWindowPriorityWeight(this));
        beginParentContainer();
        setBounds(x, y, width, animCurrentHeight);
        setInteractable(true);
        setSerializable(true);

        resizeGripOver = impl.getMouseX() > getBoundsX() + getBoundsWidth() - Style.WINDOW_RESIZE_SIZE && impl.getMouseY() > getBoundsY() + getBoundsHeight() - Style.WINDOW_RESIZE_SIZE && impl.getMouseX() < getBoundsX() + getBoundsWidth() && impl.getMouseY() < getBoundsY() + getBoundsHeight();

        submitAbsolutePositioningRequest(getBoundsX() + Style.GLOBAL_PADDING, getBoundsY() + Style.WINDOW_HEADER_HEIGHT, 0, 0);
        useBoundsClipRect();
    }

    public function setCollapsedState(collapsed: Bool) {
        if (this.collapsed == collapsed) return;
        this.collapsed = collapsed;
        animTargetHeight = collapsed ? Style.WINDOW_HEADER_HEIGHT : height;
    }

    override function onMouseDown(impl:Base) {
        // collapse
        if (impl.getMouseX() < getBoundsX() + (Style.GLOBAL_PADDING * 2) + Style.WINDOW_COLLAPSE_SIZE && impl.getMouseY() < getBoundsY() + Style.WINDOW_HEADER_HEIGHT) return setCollapsedState(!collapsed);

        // resize
        if (resizeGripOver && !collapsed) {
            isResizing = true;
            resizeOffsetX = getBoundsWidth() + getBoundsX() - impl.getMouseX();
            resizeOffsetY = getBoundsHeight() + getBoundsY() - impl.getMouseY();
            return;
        }

        // dragging
        isDragging = true;
        dragOffsetX = impl.getMouseX() - x;
        dragOffsetY = impl.getMouseY() - y; 
    }

    override function onMouseUp(impl:Base) {
        // release dragging and resizing
        isDragging = false;
        isResizing = false;
    }

    override function onSerialize():Dynamic return {
        title: title,
        x: x,
        y: y,
        width: width,
        height: height,
        collapsed: collapsed
    };

    override function onRender(impl:Base) {
        // window body
        impl.drawRect(getBoundsX(), getBoundsY(), getBoundsWidth(), animCurrentHeight, Style.WINDOW_BODY_COLOR, Style.WINDOW_BODY_ROUNDING);

        // resize grip
        var resizeX = getBoundsX() + getBoundsWidth() - Style.WINDOW_RESIZE_SIZE;
        var resizeY = getBoundsY() + getBoundsHeight() - Style.WINDOW_RESIZE_SIZE;
        var resizeColor = resizeGripOver ? Style.WINDOW_RESIZE_COLOR_HOVER : Style.WINDOW_RESIZE_COLOR;
        impl.drawRect(resizeX, resizeY, Style.WINDOW_RESIZE_SIZE, Style.WINDOW_RESIZE_SIZE, resizeColor, Style.WINDOW_BODY_ROUNDING);
        impl.drawRect(resizeX + Style.WINDOW_RESIZE_SIZE / 2, resizeY, Style.WINDOW_RESIZE_SIZE / 2, Style.WINDOW_RESIZE_SIZE / 2, resizeColor, 0);
        impl.drawRect(resizeX, resizeY + Style.WINDOW_RESIZE_SIZE / 2, Style.WINDOW_RESIZE_SIZE / 2, Style.WINDOW_RESIZE_SIZE / 2, resizeColor, 0);

        // window header
        impl.drawRect(getBoundsX(), getBoundsY(), getBoundsWidth(), Style.WINDOW_HEADER_HEIGHT, Style.WINDOW_HEADER_COLOR, Style.WINDOW_HEADER_ROUNDING);
        impl.drawText(title, getBoundsX() + Style.WINDOW_HEADER_TEXT_HPADDING, getBoundsY() + Style.WINDOW_HEADER_TEXT_VPADDING, Style.WINDOW_HEADER_TEXT_COLOR, Style.WINDOW_HEADER_TEXT_SIZE, Style.WINDOW_HEADER_TEXT_FONT);

        // collapse
        impl.drawTriangle(
            getBoundsX() + Style.GLOBAL_PADDING + (Style.WINDOW_COLLAPSE_SIZE / 2), 
            getBoundsY() + (Style.WINDOW_HEADER_HEIGHT / 2) - (collapsed ? 0 : Style.WINDOW_COLLAPSE_SIZE / 8), 
            Style.WINDOW_COLLAPSE_SIZE, 
            collapsed ? toRad(90) : toRad(180), 
            Style.WINDOW_COLLAPSE_COLOR
        );
    }

}