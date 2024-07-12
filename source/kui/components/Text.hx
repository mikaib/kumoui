package kui.components;

class Text extends Component {

    public var text: String = "";
    public var font: FontType = FontType.REGULAR;
    public var size: Int = 16;
    public var color: Int = 0xffffff;

    override function update(args:Dynamic) {
        this.text = args.text ?? this.text;
        this.font = args.font ?? this.font;
        this.size = args.size ?? this.size;
        this.color = args.color ?? this.color;
    }

    override function render(impl:kui.impl.Base) {
        var pos = Layout.getPosition();

        impl.drawText(text, pos.x, pos.y, color, size, font);
        updateAllBounds(pos.x, pos.y, impl.measureTextWidth(text, size, font), size);
    }

}