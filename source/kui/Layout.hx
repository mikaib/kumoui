package kui;

import kui.util.Stack;

/**
 * The `Layout` class provides utility functions for managing the position and layout of UI elements.
 */
class Layout {
    
    private static var _screenw: Float = 0;
    private static var _screenh: Float = 0;
    private static var _pstack: Stack<{ x: Float, y: Float, width: Float, height: Float }> = new Stack<{ x: Float, y: Float, width: Float, height: Float }>();
    private static var _sameLine: Bool = false;
    private static var _lastWasSameLine: Bool = false;

    public static inline function getScreenWidth(): Float return _screenw;
    public static inline function getScreenHeight(): Float return _screenh;

    public static function beginParentContainer(component: Component) {
        _pstack.push({ x: 0, y: 0, width: 0, height: 0 });
        KumoUI.containerStack.push(component);
    }

    public static function endParentContainer(): Component {
        _pstack.pop();
        return KumoUI.containerStack.pop();
    }

    public static function submitLayoutComponent(component: Component) {
        var curr = _pstack.peek();
        curr.x = component.getBoundsX();
        curr.y = component.getBoundsY();
        curr.width = component.getBoundsWidth();
        curr.height = component.getBoundsHeight();

        _sameLine = false;
    }

    public static function submitAbsoluteLayoutPosition(x: Float, y: Float, width: Float, height: Float) {
        var curr = _pstack.peek();
        curr.x = x;
        curr.y = y;
        curr.width = width;
        curr.height = height;

        _sameLine = false;
    }

    public static function addHorizontalSpacing(spacing: Float) {
        var curr = _pstack.peek();
        curr.x += spacing;
    }

    public static function addVerticalSpacing(spacing: Float) {
        var curr = _pstack.peek();
        curr.y += spacing;
    }

    public static inline function beginSameLine() {
        _sameLine = true;

        if (!_lastWasSameLine) {
            var curr = _pstack.peek();

            _pstack.push({ x: curr.x, y: curr.y, width: curr.width, height: curr.height });
            _lastWasSameLine = true;
        }
    }

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
            x: curr.x + curr.width + Style.GLOBAL_PADDING,
            y: curr.y
        }

        // Otherwise, return the next line
        return {
            x: curr.x,
            y: curr.y + curr.height + Style.GLOBAL_PADDING
        }
    }

    public static function getLastPosition(): { x: Float, y: Float } {
        return _pstack.peek();
    }

    public static function reset(screenWidth: Float, screenHeight: Float) {
        // Reset the position stack
        _pstack.clear();
        _pstack.push({ x: Style.GLOBAL_PADDING, y: 0, width: 0, height: 0 });

        // Reset the screen dimensions
        _screenw = screenWidth;
        _screenh = screenHeight;
        
        // Reset the same line flag
        _sameLine = false;
        _lastWasSameLine = false;
    }
}