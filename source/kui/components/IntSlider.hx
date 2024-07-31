package kui.components;

import kui.util.TextStorage;
import kui.impl.Base;

class IntSlider extends Component {

    private var value: Int = 0;
    private var min: Int = 0;
    private var max: Int = 100;
    private var width: Float = Style.SLIDER_WIDTH;
    private var label: TextStorage = new TextStorage();

    private var active: Bool = false;
    private var hover: Bool = false;

    private var insideOfSlider: Bool = false;

    inline public function getBodyColor(): Int return active ? Style.SLIDER_BASE_COLOR_ACTIVE : (hover && insideOfSlider ? Style.SLIDER_BASE_COLOR_HOVER : Style.SLIDER_BASE_COLOR);
    inline public function getGripColor(): Int return active ? Style.SLIDER_GRIP_COLOR_ACTIVE : (hover && insideOfSlider ? Style.SLIDER_GRIP_COLOR_HOVER : Style.SLIDER_GRIP_COLOR);
    inline public function getSelectedBodyColor(): Int return active ? Style.SLIDER_SELECTED_COLOR_ACTIVE : (hover && insideOfSlider ? Style.SLIDER_SELECTED_COLOR_HOVER : Style.SLIDER_SELECTED_COLOR);
    inline public function isInsideOfSlider(x: Float) return x < getBoundsX() + width;

    override function onDataUpdate(data: Dynamic): Dynamic {
        if (!active) value = data.value ?? value;
        width = data.width ?? Style.SLIDER_WIDTH;
        label.text = data.text ?? '';
        label.size = data.size ?? Style.TEXT_DEFAULT_SIZE;
        label.font = data.font ?? Style.TEXT_DEFAULT_FONT;
        label.color = data.color ?? Style.TEXT_DEFAULT_COLOR;
        min = data.min ?? 0;
        max = data.max ?? 100;
        return value;
    }

    override function onSerialize():Dynamic return { value: value };

    override function onRender(impl: Base) {
        var offsetX = (value - min) / (max - min) * (width - Style.SLIDER_HEIGHT);
        impl.drawRect(getBoundsX() + Style.SLIDER_PADDING, getBoundsY() + Style.SLIDER_PADDING, width - Style.SLIDER_PADDING * 2, Style.SLIDER_HEIGHT - Style.SLIDER_PADDING * 2, getBodyColor(), Style.SLIDER_ROUNDING);
        impl.drawRect(getBoundsX() + Style.SLIDER_PADDING, getBoundsY() + Style.SLIDER_PADDING, offsetX + Style.SLIDER_HEIGHT / 2, Style.SLIDER_HEIGHT - Style.SLIDER_PADDING * 2, getSelectedBodyColor(), Style.SLIDER_ROUNDING);
        impl.drawCircle(getBoundsX() + offsetX + Style.SLIDER_HEIGHT / 2, getBoundsY() + Style.SLIDER_HEIGHT / 2, Style.SLIDER_HEIGHT / 2, getGripColor());
        if (label.text != '') impl.drawText(label.getText(), getBoundsX() + width + Style.GLOBAL_PADDING, getBoundsY() + (Style.SLIDER_HEIGHT - label.getHeight(impl)) / 2, label.color, label.size, label.font);
    }

    override function onMouseHoverEnter(impl:Base) hover = true;
    override function onMouseHoverExit(impl:Base) hover = false;
    override function onMouseDown(impl:Base) if (insideOfSlider) active = true;
    override function onMouseUp(impl:Base) active = false;

    override function onLayoutUpdate(impl: Base) {
        useLayoutPosition();

        if (label.text != '') setSize(width + Style.GLOBAL_PADDING + label.getWidth(impl), Style.SLIDER_HEIGHT);
        else setSize(width, Style.SLIDER_HEIGHT);

        useBoundsClipRect();
        setInteractable(true);
        setSerializable(true);
        submitLayoutRequest();

        var mouseX = impl.getMouseX();
        insideOfSlider = isInsideOfSlider(mouseX);

        if (active) {
            var offsetX = mouseX - getBoundsX();
            
            value = Math.round(min + (max - min) * (offsetX / width));

            if (value < min) value = min;
            if (value > max) value = max;
        }
    }

}
