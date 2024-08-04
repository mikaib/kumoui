package kui.components;

import kui.util.TextStorage;
import kui.impl.Base;

class FloatSlider extends Component {

    private var value: Float = 0;
    private var min: Float = 0;
    private var max: Float = 1;
    private var width: Float = Style.getInstance().SLIDER_WIDTH;
    private var label: TextStorage = new TextStorage();

    private var active: Bool = false;
    private var hover: Bool = false;

    private var insideOfSlider: Bool = false;
 
    inline public function getBodyColor(): Int return active ? Style.getInstance().SLIDER_BASE_COLOR_ACTIVE : (hover && insideOfSlider ? Style.getInstance().SLIDER_BASE_COLOR_HOVER : Style.getInstance().SLIDER_BASE_COLOR);
    inline public function getGripColor(): Int return active ? Style.getInstance().SLIDER_GRIP_COLOR_ACTIVE : (hover && insideOfSlider ? Style.getInstance().SLIDER_GRIP_COLOR_HOVER : Style.getInstance().SLIDER_GRIP_COLOR);
    inline public function getSelectedBodyColor(): Int return active ? Style.getInstance().SLIDER_SELECTED_COLOR_ACTIVE : (hover && insideOfSlider ? Style.getInstance().SLIDER_SELECTED_COLOR_HOVER : Style.getInstance().SLIDER_SELECTED_COLOR);
    inline public function isInsideOfSlider(x: Float) return x < getBoundsX() + width;

    override function onDataUpdate(data: Dynamic): Dynamic {
        if (!active) value = data.value ?? value;
        width = data.width ?? Style.getInstance().SLIDER_WIDTH;
        label.text = data.text ?? '';
        label.size = data.size ?? Style.getInstance().TEXT_DEFAULT_SIZE;
        label.font = data.font ?? Style.getInstance().TEXT_DEFAULT_FONT;
        label.color = data.color ?? Style.getInstance().TEXT_DEFAULT_COLOR;
        min = data.min ?? 0;
        max = data.max ?? 1;
        return value;
    }

    override function onSerialize():Dynamic return { value: value };

    override function onRender(impl: Base) {
        var offsetX = (value - min) / (max - min) * (width - Style.getInstance().SLIDER_HEIGHT);
        impl.drawRect(getBoundsX() + Style.getInstance().SLIDER_PADDING, getBoundsY() + Style.getInstance().SLIDER_PADDING, width - Style.getInstance().SLIDER_PADDING * 2, Style.getInstance().SLIDER_HEIGHT - Style.getInstance().SLIDER_PADDING * 2, getBodyColor(), Style.getInstance().SLIDER_ROUNDING);
        impl.drawRect(getBoundsX() + Style.getInstance().SLIDER_PADDING, getBoundsY() + Style.getInstance().SLIDER_PADDING, offsetX + Style.getInstance().SLIDER_HEIGHT / 2, Style.getInstance().SLIDER_HEIGHT - Style.getInstance().SLIDER_PADDING * 2, getSelectedBodyColor(), Style.getInstance().SLIDER_ROUNDING);
        impl.drawCircle(getBoundsX() + offsetX + Style.getInstance().SLIDER_HEIGHT / 2, getBoundsY() + Style.getInstance().SLIDER_HEIGHT / 2, Style.getInstance().SLIDER_HEIGHT / 2, getGripColor());
        if (label.text != '') impl.drawText(label.getText(), getBoundsX() + width + Style.getInstance().GLOBAL_PADDING, getBoundsY() + (Style.getInstance().SLIDER_HEIGHT - label.getHeight(impl)) / 2, label.color, label.size, label.font);
    }

    override function onMouseHoverEnter(impl:Base) hover = true;
    override function onMouseHoverExit(impl:Base) hover = false;
    override function onMouseDown(impl:Base) if (insideOfSlider) active = true;
    override function onMouseUp(impl:Base) active = false;

    override function onLayoutUpdate(impl: Base) {
        useLayoutPosition();

        if (label.text != '') setSize(width + Style.getInstance().GLOBAL_PADDING + label.getWidth(impl), Style.getInstance().SLIDER_HEIGHT);
        else setSize(width, Style.getInstance().SLIDER_HEIGHT);

        useBoundsClipRect();
        setInteractable(true);
        setSerializable(true);
        submitLayoutRequest();

        var mouseX = impl.getMouseX();
        insideOfSlider = isInsideOfSlider(mouseX);

        if (active) {
            var offsetX = mouseX - getBoundsX();
            
            value = min + (max - min) * (offsetX / width);

            if (value < min) value = min;
            if (value > max) value = max;
        }
    }

}