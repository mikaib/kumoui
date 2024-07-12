package kui;

import kui.impl.Base;

class Component {

    private var _boundsX: Float = 0;
    private var _boundsY: Float = 0;
    private var _boundsWidth: Float = 0;
    private var _boundsHeight: Float = 0;

    private var _stateClipX: Float = 0;
    private var _stateClipY: Float = 0;
    private var _stateClipWidth: Float = 0;
    private var _stateClipHeight: Float = 0;
    private var _interactable: Bool = false;

    private var _data: Dynamic = null;
    private var _id: String = null;
    private var _priority: Int = 1;
    private var _computedPriority: Int = 1;
    private var _serializable: Bool = false;

    public function destroy(impl: Base) onDestroy(impl);

    public inline function getBoundsX(): Float return _boundsX;
    public inline function getBoundsY(): Float return _boundsY;
    public inline function getBoundsWidth(): Float return _boundsWidth;
    public inline function getBoundsHeight(): Float return _boundsHeight;
    public inline function getSerializable(): Bool return _serializable;
    public inline function setSerializable(value: Bool): Void _serializable = value;
    public inline function getClipX(): Float return _stateClipX;
    public inline function getClipY(): Float return _stateClipY;
    public inline function getClipWidth(): Float return _stateClipWidth;
    public inline function getClipHeight(): Float return _stateClipHeight;
    public inline function applyClipToImpl(impl: Base): Void impl.setClipRect(getClipX(), getClipY(), getClipWidth(), getClipHeight());
    public inline function getId(): String return _id;
    public inline function getPriorityWeight(): Int return _priority;
    public inline function setPriorityWeight(priority: Int): Void _priority = priority;
    public inline function setInteractable(value: Bool): Void _interactable = value;
    public inline function getInteractable(): Bool return _interactable;
    public inline function updateComputedPriority(): Void {
        var parent = KumoUI.getParent();
        _computedPriority = parent != null ? parent.getComputedPriority() + getPriorityWeight() : getPriorityWeight();
    }
    public inline function getComputedPriority(): Int return _computedPriority;
    public inline function setDataInteractable(data: Dynamic): Void if (getInteractable()) _data = data;
    public inline function getDataInteractable(): Dynamic return _data;
    public inline function setBoundsX(value: Float): Void _boundsX = value;
    public inline function setBoundsY(value: Float): Void _boundsY = value;
    public inline function setBoundsWidth(value: Float): Void _boundsWidth = value;
    public inline function setBoundsHeight(value: Float): Void _boundsHeight = value;
    public inline function setId(value: String): Void _id = value;
    public inline function useBoundsClipRect(): Void setClipRect(getBoundsX(), getBoundsY(), getBoundsWidth(), getBoundsHeight());
    public inline function useScreenClipRect(): Void setClipRect(0, 0, Layout.getScreenWidth(), Layout.getScreenHeight());
    public inline function beginParentContainer(): Void Layout.beginParentContainer(this);
    public inline function endParentContainer(): Component return Layout.endParentContainer();
    public inline function pointInside(x: Float, y: Float): Bool return (x >= getBoundsX() && x <= getBoundsX() + getBoundsWidth() && y >= getBoundsY() && y <= getBoundsY() + getBoundsHeight()) && (x >= getClipX() && x <= getClipX() + getClipWidth() && y >= getClipY() && y <= getClipY() + getClipHeight());
    
    public inline function setBounds(x: Float, y: Float, width: Float, height: Float): Void {
        _boundsX = x;
        _boundsY = y;
        _boundsWidth = width;
        _boundsHeight = height;
    }

    public inline function setSize(width: Float, height: Float): Void {
        _boundsWidth = width;
        _boundsHeight = height;
    }

    public inline function setPosition(x: Float, y: Float): Void {
        _boundsX = x;
        _boundsY = y;
    }

    public inline function useLayoutPosition(): Void {
        var pos = Layout.getNextPosition();
        setPosition(pos.x, pos.y);
    }

    public inline function submitLayoutRequest(): Void Layout.submitLayoutComponent(this);
    public inline function submitAbsolutePositioningRequest(x: Float, y: Float, width: Float, height: Float): Void Layout.submitAbsoluteLayoutPosition(x, y, width, height);
    
    public inline function useParentBounds(): Void {
        var parent = KumoUI.containerStack.peek();
        if (parent != null) {
            setBounds(parent.getBoundsX(), parent.getBoundsY(), parent.getBoundsWidth(), parent.getBoundsHeight());
        }
    }

    public function setClipRect(x: Float, y: Float, width: Float, height: Float): Void {
        // Set the clip rect for this component
        _stateClipX = x;
        _stateClipY = y;
        _stateClipWidth = width;
        _stateClipHeight = height;
        
        // If there is a parent container, we need to also take into account the parent's bounds
        if (KumoUI.hasParent()) {
            var parent = KumoUI.getParent();
            if (parent == this) return; // We don't want to clip to ourselves if we are the parent

            _stateClipX = Math.max(x, parent.getClipX());
            _stateClipY = Math.max(y, parent.getClipY());
            _stateClipWidth = Math.max(0, Math.min(width, parent.getClipWidth() - Math.max(0, x - parent.getClipX())));
            _stateClipHeight = Math.max(0, Math.min(height, parent.getClipHeight() - Math.max(0, y - parent.getClipY())));
        }
    }

    public inline function isVisible() {
        if (
            getBoundsX() + getBoundsWidth() <= getClipX() ||
            getBoundsY() + getBoundsHeight() <= getClipY() ||
            getBoundsX() >= getClipX() + getClipWidth() ||
            getBoundsY() >= getClipY() + getClipHeight()
        ) return false;
        return true;
    }    

    public function onMouseHoverEnter(impl: Base) {}
    public function onMouseHoverExit(impl: Base) {}
    public function onMouseClick(impl: Base) {}
    public function onMouseClickOutside(impl: Base) {}
    public function onMouseDown(impl: Base) {}
    public function onMouseUp(impl: Base) {}
    public function onDataUpdate(data: Dynamic): Dynamic return null;
    public function onLayoutUpdate(impl: Base) {}
    public function onDebugDraw(impl: Base) impl.drawRectOutline(getBoundsX(), getBoundsY(), getBoundsWidth(), getBoundsHeight(), isVisible() ? 0xFF0000 : 0x0000FF, 2);
    public function onRender(impl: Base) {}
    public function onDestroy(impl: Base) {}

    public function onSerialize(): Dynamic return getDataInteractable();
    public function onDeserialize(data: Dynamic) {
        setDataInteractable(data);
        onDataUpdate(data);
    }

}