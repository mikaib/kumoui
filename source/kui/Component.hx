package kui;

import kui.impl.Base;

class Component {

    // bounds
    private var _boundsX: Float = 0;
    private var _boundsY: Float = 0;
    private var _boundsWidth: Float = 0;
    private var _boundsHeight: Float = 0;

    // clip
    private var _stateClipX: Float = 0;
    private var _stateClipY: Float = 0;
    private var _stateClipWidth: Float = 0;
    private var _stateClipHeight: Float = 0;

    // id / data
    private var _data: Dynamic = null;
    private var _id: String = null;

    // prio
    private var _priority: Int = 1;
    private var _computedPriority: Int = 1;

    // flags
    private var _serializable: Bool = false;
    private var _interactable: Bool = false;

    /**
     * Destroys the component along with it's data.
     * @param impl The backend implementation.
     */
    public function destroy(impl: Base): Void {
        onDestroy(impl);
    }

    /**
     * Get the x position of the component.
     * @return Float The x position of the component.
     */
    public inline function getBoundsX(): Float {
        return _boundsX;
    }

    /**
     * Get the y position of the component.
     * @return Float The y position of the component.
     */
    public inline function getBoundsY(): Float {
        return _boundsY;
    }

    /**
     * Get the width of the component.
     * @return Float The width of the component.
     */
    public inline function getBoundsWidth(): Float {
        return _boundsWidth;
    }

    /**
     * Get the height of the component.
     * @return Float The height of the component.
     */
    public inline function getBoundsHeight(): Float {
        return _boundsHeight;
    }

    /**
     * Check if the serializable flag is set, this is used to determine if the component is serializable.
     * @return Bool Whether the component is serializable.
     */
    public inline function getSerializable(): Bool {
        return _serializable;
    }

    /**
     * Tell KumoUI that this component is serializable, which will make KumoUI save the data of the component when destroyed.
     * @param value The value to set the serializable flag to.
     */
    public inline function setSerializable(value: Bool): Void {
        _serializable = value;
    }

    /**
     * Get the x position of the clip rect.
     * @return Float The x position of the clip rect.
     */
    public inline function getClipX(): Float {
        return _stateClipX;
    }

    /**
     * Get the y position of the clip rect.
     * @return Float The y position of the clip rect.
     */
    public inline function getClipY(): Float {
        return _stateClipY;
    }

    /**
     * Get the width of the clip rect.
     * @return Float The width of the clip rect.
     */
    public inline function getClipWidth(): Float {
        return _stateClipWidth;
    }

    /**
     * Get the height of the clip rect.
     * @return Float The height of the clip rect.
     */
    public inline function getClipHeight(): Float {
        return _stateClipHeight;
    }

    /**
     * This is called by KumoUI to apply the clip rect to the backend implementation.
     * @param impl The backend implementation.
     */
    public inline function applyClipToImpl(impl: Base): Void {
        impl.setClipRect(getClipX(), getClipY(), getClipWidth(), getClipHeight());
    }

    /**
     * Get the current component ID, this is used to identify the component.
     * @return String The ID of the component.
     */
    public inline function getId(): String {
        return _id;
    }

    /**
     * Get the priority weight of the component, this is used to determine the priority of the component.
     * @return Int The priority weight of the component.
     */
    public inline function getPriorityWeight(): Int {
        return _priority;
    }

    /**
     * Sets the weight of the priority, this gets summed up along with all the previous parent's priority weights to get the computed priority.  
     * By default, the priority weight is 1, meaning that the priority increases the more nested the component is.
     * @param priority The priority weight to set.
     */
    public inline function setPriorityWeight(priority: Int): Void {
        _priority = priority;
    }
    
    /**
     * Set the interactable flag of the component, this is used to determine if the component can be interacted with.  
     * When true, many events like click, hover, etc. will be enabled for the component.
     * @param value The value to set the interactable flag to.
     */
    public inline function setInteractable(value: Bool): Void {
        _interactable = value;
    }

    /**
     * Get the interactable flag of the component, this is used to determine if the component can be interacted with.
     * @return Bool The interactable flag of the component.
     */
    public inline function getInteractable(): Bool {
        return _interactable;
    }

    /**
     * This will update the computed priority of the component, this is used to update the priority of the component based on the parent's priority.
     */
    public inline function updateComputedPriority(): Void {
        var parent = KumoUI.getParent();
        _computedPriority = parent != null ? parent.getComputedPriority() + getPriorityWeight() : getPriorityWeight();
    }

    /**
     * Get the computed priority of the component, will sum up the current priority weight with all previous parent's priority weights.
     * @return Int The computed priority of the component.
     */
    public inline function getComputedPriority(): Int {
        return _computedPriority;
    }

    /**
     * Set the data of the component, this is used to set the data of the component.  
     * This is only allowed IF the interactable flag is set to true.
     * @param data 
     */
    public inline function setDataInteractable(data: Dynamic): Void {
        if (getInteractable()) _data = data;
    }
    
    /**
     * Returns the public data of the component, many components will avoid using this in order to avoid problems with Dynamic data being modified.
     * @return Dynamic The data of the component.
     */
    public inline function getDataInteractable(): Dynamic {
        return _data;
    }
    
    /**
     * Set the x position of the component.
     * @param value The value to set the x position to.
     */
    public inline function setBoundsX(value: Float): Void {
        _boundsX = value;
    }

    /**
     * Set the y position of the component.
     * @param value The value to set the y position to.
     */
    public inline function setBoundsY(value: Float): Void {
        _boundsY = value;
    }

    /**
     * Set the width of the component.
     * @param value The value to set the width to.
     */
    public inline function setBoundsWidth(value: Float): Void {
        _boundsWidth = value;
    }

    /**
     * Set the height of the component.
     * @param value The value to set the height to.
     */
    public inline function setBoundsHeight(value: Float): Void {
        _boundsHeight = value;
    }

    /**
     * This will set the ID of the component, KumoUI will call this for you.
     * @param value The value to set the ID to.
     */
    public inline function setId(value: String): Void {
        _id = value;
    }

    /**
     * Will set the clip rect to the bounds of the component (which is very common, and you should do by default).
     * @return Void Set the clip rect to the bounds of the component.
     */
    public inline function useBoundsClipRect(): Void {
        setClipRect(getBoundsX(), getBoundsY(), getBoundsWidth(), getBoundsHeight());
    }
    
    /**
     * Tell the com
     * @return Void Ise the clip rect of the screen.  
     * Note that if the component is in a parent container, it will be clipped to the parent's clip rect.
     */
    public inline function useScreenClipRect(): Void {
        setClipRect(0, 0, Layout.getScreenWidth(), Layout.getScreenHeight());
    }

    /**
     * Begin a new parent container, tells the Layout to begin a new flow of components.
     */
    public inline function beginParentContainer(): Void {
        Layout.beginParentContainer(this);
    }

    /**
     * End the current parent container.
     * @return Component The component that was ended.
     */
    public inline function endParentContainer(): Component {
        return Layout.endParentContainer();
    }

    /**
     * Check if a point is inside the component.
     * @param x The x position of the point.
     * @param y The y position of the point.
     * @return Bool Whether the point is inside the component.
     */
    public inline function pointInside(x: Float, y: Float): Bool return (x >= getBoundsX() && x <= getBoundsX() + getBoundsWidth() && y >= getBoundsY() && y <= getBoundsY() + getBoundsHeight()) && (x >= getClipX() && x <= getClipX() + getClipWidth() && y >= getClipY() && y <= getClipY() + getClipHeight());
    
    /**
     * Set the bounds of the component.
     * @param x The x position.
     * @param y The y position.
     * @param width The width.
     * @param height The height.
     */
    public inline function setBounds(x: Float, y: Float, width: Float, height: Float): Void {
        _boundsX = x;
        _boundsY = y;
        _boundsWidth = width;
        _boundsHeight = height;
    }

    /**
     * Set the size of the component.
     * @param width The width.
     * @param height The height.
     */
    public inline function setSize(width: Float, height: Float): Void {
        _boundsWidth = width;
        _boundsHeight = height;
    }

    /**
     * Will set the position of the component to the specified x and y coordinates.
     * @param x The x position.
     * @param y The y position.
     */
    public inline function setPosition(x: Float, y: Float): Void {
        _boundsX = x;
        _boundsY = y;
    }

    /**
     * This will use the position of where the layout would like the component to be placed.
     */
    public inline function useLayoutPosition(): Void {
        var pos = Layout.getNextPosition();
        setPosition(pos.x, pos.y);
    }

    /**
     * will submit the current component to the layout to make other components aware of it.
     */
    public inline function submitLayoutRequest(): Void {
        Layout.submitLayoutComponent(this);
    }

    /**
     * Will submit an absolute positioning request to the layout, this is comparable to creating a "ghost" component at an absolute position with your desired width and height.
     * @param x The x position.
     * @param y The y position.
     * @param width The width.
     * @param height The height.
     */
    public inline function submitAbsolutePositioningRequest(x: Float, y: Float, width: Float, height: Float): Void {
        Layout.submitAbsoluteLayoutPosition(x, y, width, height);
    }
    
    /**
     * This function will apply the bounds of the parent to the component.  
     * If no parent is found, this function will not apply any bounds.
     */
    public inline function useParentBounds(): Void {
        var parent = KumoUI.containerStack.peek();
        if (parent != null) {
            setBounds(parent.getBoundsX(), parent.getBoundsY(), parent.getBoundsWidth(), parent.getBoundsHeight());
        }
    }

    /**
     * This will define the clip rect for the component.  
     * Any children will also be clipped to this rect, including the component itself.
     * @param x The x position of the clip rect.
     * @param y The y position of the clip rect.
     * @param width The width of the clip rect.
     * @param height The height of the clip rect.
     */
    public function setClipRect(x: Float, y: Float, width: Float, height: Float): Void {
        _stateClipX = x;
        _stateClipY = y;
        _stateClipWidth = width;
        _stateClipHeight = height;
    
        if (KumoUI.hasParent()) {
            var parent = KumoUI.getParent();
            if (parent == this) return; // we don't want this lol
    
            var parentClipX = parent.getClipX();
            var parentClipY = parent.getClipY();
            var parentClipWidth = parent.getClipWidth();
            var parentClipHeight = parent.getClipHeight();
    
            // ensure that the clip rect is within the parent's clip rect, else it looks funky.
            // i've reiterated on this multiple times... it's a bit of a mess.
            _stateClipX = Math.max(x, parentClipX);
            _stateClipY = Math.max(y, parentClipY);
    
            if (x < parentClipX) {
                _stateClipWidth -= parentClipX - x;
            }
            if (y < parentClipY) {
                _stateClipHeight -= parentClipY - y;
            }
    
            var maxClipWidth = parentClipWidth - (_stateClipX - parentClipX);
            var maxClipHeight = parentClipHeight - (_stateClipY - parentClipY);
    
            _stateClipWidth = Math.max(0, Math.min(_stateClipWidth, maxClipWidth));
            _stateClipHeight = Math.max(0, Math.min(_stateClipHeight, maxClipHeight));
        }
    }      

    /**
     * Checks if the component is visible.  
     * This function will use the bounds AND clip rect to determine if the component is visible.
     * @return Bool Whether the component is visible.
     */
    public inline function isVisible(): Bool {
        if (
            getBoundsX() + getBoundsWidth() <= getClipX() ||
            getBoundsY() + getBoundsHeight() <= getClipY() ||
            getBoundsX() >= getClipX() + getClipWidth() ||
            getBoundsY() >= getClipY() + getClipHeight()
        ) return false;
        return true;
    }    

    /**
     * When the mouse is hovering over the component.
     * @param impl The backend
     */
    public function onMouseHoverEnter(impl: Base) {}

    /**
     * When the mouse hover goes away from the component.
     * @param impl The backend
     */
    public function onMouseHoverExit(impl: Base) {}

    /**
     * When the user is clicked, by default this means the mouse is pressed down AND released WITHIN the component.  
     * Some options or modifications may change this to be triggered when the mouse is down for a more "responsive" feel
     * For the sake of future-proofing, it is recommended to ALWAYS use this event for click events.
     * @param impl The backend
     */
    public function onMouseClick(impl: Base) {}
    
    /**
     * When the mouse is clicked outside of the component, after previously being clicked inside of it, useful to blur focus or similar.
     * @param impl The backend
     */
    public function onMouseClickOutside(impl: Base) {}

    /**
     * This event is called when the mouse is pressed down.
     * @param impl The backend
     */
    public function onMouseDown(impl: Base) {}

    /**
     * This event is called when the mouse is released.
     * @param impl The backend
     */
    public function onMouseUp(impl: Base) {}

    /**
     * Called for EVERY component, EVERY frame, regardless of visibility.  
     * This is called before onLayoutUpdate, this function is used to take in input and return a result for the component.
     * This makes the component have a lifecylce of sorts. (onCreate->(onSerialize)->[onDataUpdate->onLayoutUpdate->onRender]->(onDeserialize)->onDestroy)
     * @param data The data to update with.
     * @return Dynamic, depends on the component, but usually null if no data is returned.
     */
    public function onDataUpdate(data: Dynamic): Dynamic {
        return null;
    }

    /**
     * Called for EVERY component, EVERY frame, regardless of visibility.
     * This is called before onRender, so you can use this to update data that will be rendered in onRender.  
     * Alongside this, it is expected that you update your bounds, input, events and other things here.  
     * If possible, try to minimize the amount of code in this function if your component is not visible (use isVisible() to check after setting your bounds)  
     * If you have too much code it will slow down the process alot as soon as your component is in the UI "tree"
     * @param impl 
     */
    public function onLayoutUpdate(impl: Base) {}

    /**
     * Called when we are ready to draw debug information. 
     * By default this will draw a rectangle around the bounds, so very few components will need to override this unless you want to draw extra debug information.
     * @param impl The backend
     */
    public function onDebugDraw(impl: Base) {
        impl.drawRectOutline(getBoundsX(), getBoundsY(), getBoundsWidth(), getBoundsHeight(), isVisible() ? 0xFF0000 : 0x0000FF, 2);
    }

    /**
     * Called every frame, when we are ready to render things.  
     * Note that onRender is only called if it is visible, any currently out-of-view components will not have this event called.
     * @param impl The backend
     */
    public function onRender(impl: Base) {}

    /**
     * This event is called when a component is destroyed.  
     * Use this event to free up any resources or sprites that were created.
     * @param impl The backend
     */
    public function onDestroy(impl: Base) {}

    /**
     * When a component is serialized, this event is called to get the data to serialize.  
     * By default this will call getDataInteractable, so usually there is no need to override this.  
     * This event is called right before a component is destroyed.
     * @return Dynamic return getDataInteractable()
     */
    public function onSerialize(): Dynamic {
        return getDataInteractable();
    }

    /**
     * This event is called when data is deserialized (when a previously destroyed component is recreated).  
     * By default this will call onDataUpdate with the deserialized data, so usually there is no need to override this.
     * @param data The data to deserialize.
     */
    public function onDeserialize(data: Dynamic) {
        setDataInteractable(data);
        onDataUpdate(data);
    }

}