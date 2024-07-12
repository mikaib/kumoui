package kui;

import kui.util.Stack;

/**
 * The `Layout` class provides utility functions for managing the position and layout of UI elements.
 */
class Layout {

    public static var prevX(get, set): Float;
    public static var prevY(get, set): Float;
    public static var prevWidth(get, set): Float;
    public static var prevHeight(get, set): Float;

    public static var sameLine(get, set): Bool;
    public static var sameLineReturnX(get, set): Float;
    public static var sameLineReturnY(get, set): Float;
    public static var lastWasSameline(get, set): Bool;
    
    public static var screenW: Float = 0;
    public static var screenH: Float = 0;

    private static var _outOfView: Bool = false;
    public static var positionalStack: Stack<{ prevX: Float, prevY: Float, prevWidth: Float, prevHeight: Float, sameLine: Bool, sameLineReturnX: Float, sameLineReturnY: Float, lastWasSameline: Bool }> = new Stack<{ prevX: Float, prevY: Float, prevWidth: Float, prevHeight: Float, sameLine: Bool, sameLineReturnX: Float, sameLineReturnY: Float, lastWasSameline: Bool }>();

    /**
     * Updates the screen bounds for the layout system.
     * @param width The width of the screen.
     * @param height The height of the screen.
     */
    public static function updateScreenBounds(width: Float, height: Float): Void {
        screenW = width;
        screenH = height;
    }

    /**
     * Gets the next position for the UI element based on the previous position and layout settings.
     * @return An object containing the next X and Y positions.
     */
    public static function getPosition(): {x: Float, y: Float} {
        var x = prevX + (sameLine ? prevWidth + Style.GLOBAL_PADDING : 0);
        var y = prevY + (sameLine ? 0 : prevHeight + Style.GLOBAL_PADDING);

        if (!sameLine && lastWasSameline) {
            x = sameLineReturnX;
            y = sameLineReturnY;
            lastWasSameline = false;
        }

        if (sameLine && !lastWasSameline) {
            sameLineReturnX = prevX;
            sameLineReturnY = prevY + prevHeight + Style.GLOBAL_PADDING;
            lastWasSameline = true;
        }

        return {x: x, y: y};
    }

    /**
     * Updates the previous width and height of the UI element.
     * @param width The new width of the UI element.
     * @param height The new height of the UI element.
     */
    public static function updateBounds(width: Float, height: Float): Void {
        prevWidth = width;
        prevHeight = height;
    }

    /**
     * Enables the same line layout for the UI elements.
     */
    public static function enableSameline(): Void {
        sameLine = true;
    }

    /**
     * Updates the previous position of the UI element.
     * @param x The new X position of the UI element.
     * @param y The new Y position of the UI element.
     */
    public static function updatePosition(x: Float, y: Float): Void {
        prevX = x;
        prevY = y;
        _outOfView = x + prevWidth > screenW || y + prevHeight > screenH;
    }

    /**
     * Forces the next UI element to be placed at a specific position.
     * @param x The X position of the UI element.
     * @param y The Y position of the UI element.
     */
    public static function setPositionAbsolute(x: Float, y: Float): Void {
        updatePosition(x, y);
        updateBounds(0, 0);
        sameLine = false;
    }

    /**
     * Resets the layout settings to their initial values.
     */
    public static function reset(): Void {
        positionalStack.clear();
        createPositionalBranch();
    }

    /**
     * Check if the next component is out of view.
     */
    public static function isOutOfView(): Bool {
        return _outOfView;
    }

    public static function createPositionalBranch(absX: Float = 0, absY: Float = 0): Void {
        positionalStack.push({ prevX: absX, prevY: absY, prevWidth: 0, prevHeight: 0, sameLine: false, sameLineReturnX: 0, sameLineReturnY: 0, lastWasSameline: false });
    }

    public static function endPositionalBranch(): Void {
        positionalStack.pop();
    }

    static function set_prevHeight(value:Float):Float {
        return positionalStack.peek().prevHeight = value;
    }

	static function get_prevHeight():Float {
        return positionalStack.peek().prevHeight;
	}

    static function set_prevWidth(value:Float):Float {
        return positionalStack.peek().prevWidth = value;
    }

    static function get_prevWidth():Float {
        return positionalStack.peek().prevWidth;
    }

    static function set_prevY(value:Float):Float {
        return positionalStack.peek().prevY = value;
    }

    static function get_prevY():Float {
        return positionalStack.peek().prevY;
    }

    static function set_prevX(value:Float):Float {
        return positionalStack.peek().prevX = value;
    }

    static function get_prevX():Float {
        return positionalStack.peek().prevX;
    }

    static function set_sameLine(value:Bool):Bool {
        return positionalStack.peek().sameLine = value;
    }

    static function get_sameLine():Bool {
        return positionalStack.peek().sameLine;
    }

    static function set_sameLineReturnX(value:Float):Float {
        return positionalStack.peek().sameLineReturnX = value;
    }

    static function get_sameLineReturnX():Float {
        return positionalStack.peek().sameLineReturnX;
    }

    static function set_sameLineReturnY(value:Float):Float {
        return positionalStack.peek().sameLineReturnY = value;
    }

    static function get_sameLineReturnY():Float {
        return positionalStack.peek().sameLineReturnY;
    }

    static function set_lastWasSameline(value:Bool):Bool {
        return positionalStack.peek().lastWasSameline = value;
    }

    static function get_lastWasSameline():Bool {
        return positionalStack.peek().lastWasSameline;
    }

}