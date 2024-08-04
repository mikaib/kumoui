package kui;

import kui.util.Stack;

/**
 * The `Layout` class provides utility functions for managing the position and layout of UI elements.
 */
class Layout {
    
    // Screen dimensions
    private static var _screenw: Float = 0;
    private static var _screenh: Float = 0;

    // The position stack
    private static var _pstack: Stack<{ x: Float, y: Float, width: Float, height: Float }> = new Stack<{ x: Float, y: Float, width: Float, height: Float }>();
    
    // Default state of position stack
    private static var defaultState: { x: Float, y: Float, width: Float, height: Float } = { x: Style.getInstance().GLOBAL_PADDING, y: 0, width: 0, height: 0 };
    
    // Sameline parameters
    private static var _sameLine: Bool = false;
    private static var _lastWasSameLine: Bool = false;

    /**
     * Get the current screen width.
     * @return Float return _screenw
     */
    public static inline function getScreenWidth(): Float {
        return _screenw;
    }

    /**
     * Get the current screen height.
     * @return Float return _screenh
     */
    public static inline function getScreenHeight(): Float {
        return _screenh;
    }

    /**
     * Begin a new parent container.
     * @param component The component to begin the container for.
     */
    public static function beginParentContainer(component: Component) {
        pushPosition(0, 0, 0, 0);
        KumoUI.containerStack.push(component);
    }

    /**
     * End the current parent container.
     * @return Component The component that was ended.
     */
    public static function endParentContainer(): Component {
        _pstack.pop();
        return KumoUI.containerStack.pop();
    }

    /**
     * Submit a layout component, and add it to the position stack.
     * @param component The component to submit.
     */
    public static function submitLayoutComponent(component: Component) {
        var curr = _pstack.peek();
        curr.x = component.getBoundsX();
        curr.y = component.getBoundsY();
        curr.width = component.getBoundsWidth();
        curr.height = component.getBoundsHeight();

        _sameLine = false;
    }

    /**
     * Instead of submitting a layout component, submit an absolute layout position. A "Ghost" component of sorts.
     * @param x The x position.
     * @param y The y position.
     * @param width The width (0 if you desire absolute positioning at x/y)
     * @param height The height (0 if you desire absolute positioning at x/y)
     */
    public static function submitAbsoluteLayoutPosition(x: Float, y: Float, width: Float, height: Float) {
        var curr = _pstack.peek();
        curr.x = x;
        curr.y = y;
        curr.width = width;
        curr.height = height;

        _sameLine = false;
    }

    /**
     * Add horizontal spacing to the current position.
     * @param spacing The amount of spacing to add.
     */
    public static function addHorizontalSpacing(spacing: Float) {
        var curr = _pstack.peek();
        curr.x += spacing;
    }

    /**
     * Add vertical spacing to the current position.
     * @param spacing The amount of spacing to add.
     */
    public static function addVerticalSpacing(spacing: Float) {
        var curr = _pstack.peek();
        curr.y += spacing;
    }

    /**
     * Begin a same line layout.
     */
    public static inline function beginSameLine() {
        _sameLine = true;

        if (!_lastWasSameLine) {
            var curr = _pstack.peek();

            pushPosition(curr.x, curr.y, curr.width, curr.height);
            _lastWasSameLine = true;
        }
    }

    /**
     * Push pos item to pstack using data pool
     * @param x The x position.
     * @param y The y position.
     * @param width The width (0 if you desire absolute positioning at x/y)
     * @param height The height (0 if you desire absolute positioning at x/y)
     */
    public static function pushPosition(x: Float, y: Float, width: Float, height: Float) {
        var data = KumoUI.acquireDataPoolItem();
        data.x = x;
        data.y = y;
        data.width = width;
        data.height = height;

        _pstack.push(data);
    }
    
    /**
     * Get the next position in the layout.
     * @return { x: Float, y: Float } The next position.
     */
    public static function getNextPosition(): { x: Float, y: Float } {
        // Handle return to beginning of next line (if same line was used)
        if (!_sameLine && _lastWasSameLine) {
            _pstack.pop();
            _lastWasSameLine = false;
        }

        // Current position stack
        var curr = _pstack.peek();

        // Do slightly different stuff if we're on the same line
        if (_sameLine) return {
            x: curr.x + curr.width + Style.getInstance().GLOBAL_PADDING,
            y: curr.y
        }

        // Otherwise, return the next line
        return {
            x: curr.x,
            y: curr.y + curr.height + Style.getInstance().GLOBAL_PADDING
        }
    }

    /**
     * Get the last position in the layout.
     * @return { x: Float, y: Float } The last position.
     */
    public static function getLastPosition(): { x: Float, y: Float } {
        return _pstack.peek();
    }

    /**
     * Reset the layout manager.
     * @param screenWidth The new screen width.
     * @param screenHeight The new screen height.
     */
    public static function reset(screenWidth: Float, screenHeight: Float) {
        // Reset the position stack
        _pstack.clear();
        pushPosition(defaultState.x, defaultState.y, defaultState.width, defaultState.height);

        // Reset the screen dimensions
        _screenw = screenWidth;
        _screenh = screenHeight;
        
        // Reset the same line flag
        _sameLine = false;
        _lastWasSameLine = false;
    }
    
}