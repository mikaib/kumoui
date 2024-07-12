package kui.components;

import kui.impl.Base;

class Button extends Component {

    public var text: String = "";
    public var fontType: FontType = FontType.BOLD;
    public var textSize: Int = 16;
    public var isClicked: Bool = false;

    override function isInteractable():Bool return true;
    override function getReturnValue():Dynamic return isClicked;

    override function update(args:Dynamic) {
        this.text = args.text ?? this.text;
        this.fontType = args.fontType ?? this.fontType;
        this.textSize = args.textSize ?? this.textSize;
    }

    override function onMouseClick(impl:Base) {
        isClicked = true;
    }

    override function render(impl:Base) {
        var pos = Layout.getPosition();
        var text = this.text.toUpperCase();
        var innerWidth = impl.measureTextWidth(text, textSize, fontType);

        impl.drawRect(pos.x, pos.y, innerWidth + 20, textSize + 20, 0x14181F, 5);
        impl.drawText(text, pos.x + 10, pos.y + 10, 0xffffff, textSize, fontType);

        updateAllBounds(pos.x, pos.y, innerWidth + 20, textSize + 20);
        isClicked = false;
    }

}