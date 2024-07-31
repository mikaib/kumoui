package kui.components;

import kui.util.TextStorage;
import kui.impl.Base;

class Toggle extends Component {

    private var label: TextStorage = new TextStorage();

    private var toggled: Bool = false;
    private var hover: Bool = false;
    private var changedLastFrame: Bool = false;
    private var insideOfToggle: Bool = false;

    private var animOffsetX: Float = 0;
 
    inline public function getBodyColor(): Int return hover && insideOfToggle ? Style.TOGGLE_BASE_COLOR_HOVER : Style.TOGGLE_BASE_COLOR;
    inline public function getEnabledBodyColor(): Int return hover && insideOfToggle ? Style.TOGGLE_ENABLED_COLOR_HOVER : Style.TOGGLE_ENABLED_COLOR;
    inline public function getGripColor(): Int return hover && insideOfToggle ? Style.TOGGLE_GRIP_COLOR_HOVER : Style.TOGGLE_GRIP_COLOR;
    inline public function getAnimTargetOffsetX(): Float return toggled ? Style.TOGGLE_WIDTH - Style.TOGGLE_HEIGHT : 0;
    inline public function isInsideOfToggle(x: Float) return x < getBoundsX() + Style.TOGGLE_WIDTH;

    override function onDataUpdate(data: Dynamic): Dynamic {
        if (!changedLastFrame) toggled = data.value ?? toggled;
        label.text = data.text ?? '';
        label.size = data.size ?? Style.TEXT_DEFAULT_SIZE;
        label.font = data.font ?? Style.TEXT_DEFAULT_FONT;
        label.color = data.color ?? Style.TEXT_DEFAULT_COLOR;
        return toggled;
    }

    override function onSerialize():Dynamic return { value: toggled };

    override function onRender(impl: Base) {
        impl.drawRect(getBoundsX() + Style.TOGGLE_PADDING, getBoundsY() + Style.TOGGLE_PADDING, Style.TOGGLE_WIDTH - Style.TOGGLE_PADDING * 2, Style.TOGGLE_HEIGHT - Style.TOGGLE_PADDING * 2, getBodyColor(), Style.TOGGLE_ROUNDING);
        impl.drawRect(getBoundsX() + Style.TOGGLE_PADDING, getBoundsY() + Style.TOGGLE_PADDING, animOffsetX + Style.TOGGLE_HEIGHT / 2, Style.TOGGLE_HEIGHT - Style.TOGGLE_PADDING * 2, getEnabledBodyColor(), Style.TOGGLE_ROUNDING);
        impl.drawCircle(getBoundsX() + animOffsetX + Style.TOGGLE_HEIGHT / 2, getBoundsY() + Style.TOGGLE_HEIGHT / 2, Style.TOGGLE_HEIGHT / 2, getGripColor());
        if (label.text != '') impl.drawText(label.getText(), getBoundsX() + Style.TOGGLE_WIDTH + Style.GLOBAL_PADDING, getBoundsY() + (Style.TOGGLE_HEIGHT - label.getHeight(impl)) / 2, label.color, label.size, label.font);
    }

    override function onMouseClick(impl:Base) {
        if (!insideOfToggle) return;
        toggled = !toggled;
        changedLastFrame = true;
    }
    override function onMouseHoverEnter(impl:Base) hover = true;
    override function onMouseHoverExit(impl:Base) hover = false;

    override function onLayoutUpdate(impl: Base) {
        useLayoutPosition();
        if (label.text != '') setSize(Style.TOGGLE_WIDTH + Style.GLOBAL_PADDING + label.getWidth(impl), Style.TOGGLE_HEIGHT);
        else setSize(Style.TOGGLE_WIDTH, Style.TOGGLE_HEIGHT);
        useBoundsClipRect();
        setInteractable(true);
        setSerializable(true);
        submitLayoutRequest();
        
        var da = (getAnimTargetOffsetX() - animOffsetX) * (impl.getDeltaTime() * Style.TOGGLE_SPEED);
        animOffsetX += Math.isNaN(da) ? 0 : da;

        changedLastFrame = false;
        insideOfToggle = isInsideOfToggle(impl.getMouseX());
    }

}