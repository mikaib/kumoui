package kui.components;

import kui.impl.Base;

class Window extends Component {

    public var x: Float = 0;
    public var y: Float = 0;
    public var width: Float = 250;
    public var height: Float = 350;
    public var title: String = "";
    public var id: String = null;
    
    private var _isMoving: Bool = false;
    private var _mouseOffsetX: Float = 0;
    private var _mouseOffsetY: Float = 0;

    override function update(args:Dynamic) {
        this.x = args.x ?? this.x;
        this.y = args.y ?? this.y;
        this.width = args.width ?? this.width;
        this.height = args.height ?? this.height;
        this.title = args.title ?? "New Window";    
        this.id = args.id ?? null;
    }

    override function isInteractable():Bool return true;
    override function getPriority():Int return -1;
    override function getId():String return id;

    override function onMouseDown(impl: Base) {
        if (_isMoving) return;
        _mouseOffsetX = impl.getMouseX() - x;
        _mouseOffsetY = impl.getMouseY() - y;
        _isMoving = true;
    }

    override function onMouseUp(impl:Base) {
        _isMoving = false;    
    }

    override function render(impl:Base) {
        impl.drawRect(x, y, width, height, 0x212833, 5);
        impl.drawRect(x, y, width, 32, 0x14181F, 5);
        impl.drawText(title, x + 8, y + 8, 0xffffff, 16, FontType.BOLD);

        updateComponentBounds(x, y, width, height);
        startContainer();
        setContainerClip(x, y, width, height);
        setAbsolutePosition(x + 8, y + 32);

        if (_isMoving) {
            this.x = impl.getMouseX() - _mouseOffsetX;
            this.y = impl.getMouseY() - _mouseOffsetY;
        }
    }

}