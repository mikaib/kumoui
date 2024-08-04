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
 
    inline public function getBodyColor(): Int return hover && insideOfToggle ? Style.getInstance().TOGGLE_BASE_COLOR_HOVER : Style.getInstance().TOGGLE_BASE_COLOR;
    inline public function getEnabledBodyColor(): Int return hover && insideOfToggle ? Style.getInstance().TOGGLE_ENABLED_COLOR_HOVER : Style.getInstance().TOGGLE_ENABLED_COLOR;
    inline public function getGripColor(): Int return hover && insideOfToggle ? Style.getInstance().TOGGLE_GRIP_COLOR_HOVER : Style.getInstance().TOGGLE_GRIP_COLOR;
    inline public function getAnimTargetOffsetX(): Float return toggled ? Style.getInstance().TOGGLE_WIDTH - Style.getInstance().TOGGLE_HEIGHT : 0;
    inline public function isInsideOfToggle(x: Float) return x < getBoundsX() + Style.getInstance().TOGGLE_WIDTH;

    override function onDataUpdate(data: Dynamic): Dynamic {
        if (!changedLastFrame) toggled = data.value ?? toggled;
        label.text = data.text ?? '';
        label.size = data.size ?? Style.getInstance().TEXT_DEFAULT_SIZE;
        label.font = data.font ?? Style.getInstance().TEXT_DEFAULT_FONT;
        label.color = data.color ?? Style.getInstance().TEXT_DEFAULT_COLOR;
        return toggled;
    }

    override function onSerialize():Dynamic return { value: toggled };

    override function onRender(impl: Base) {
        impl.drawRect(getBoundsX() + Style.getInstance().TOGGLE_PADDING, getBoundsY() + Style.getInstance().TOGGLE_PADDING, Style.getInstance().TOGGLE_WIDTH - Style.getInstance().TOGGLE_PADDING * 2, Style.getInstance().TOGGLE_HEIGHT - Style.getInstance().TOGGLE_PADDING * 2, getBodyColor(), Style.getInstance().TOGGLE_ROUNDING);
        impl.drawRect(getBoundsX() + Style.getInstance().TOGGLE_PADDING, getBoundsY() + Style.getInstance().TOGGLE_PADDING, animOffsetX + Style.getInstance().TOGGLE_HEIGHT / 2, Style.getInstance().TOGGLE_HEIGHT - Style.getInstance().TOGGLE_PADDING * 2, getEnabledBodyColor(), Style.getInstance().TOGGLE_ROUNDING);
        impl.drawCircle(getBoundsX() + animOffsetX + Style.getInstance().TOGGLE_HEIGHT / 2, getBoundsY() + Style.getInstance().TOGGLE_HEIGHT / 2, Style.getInstance().TOGGLE_HEIGHT / 2, getGripColor());
        if (label.text != '') impl.drawText(label.getText(), getBoundsX() + Style.getInstance().TOGGLE_WIDTH + Style.getInstance().GLOBAL_PADDING, getBoundsY() + (Style.getInstance().TOGGLE_HEIGHT - label.getHeight(impl)) / 2, label.color, label.size, label.font);
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
        if (label.text != '') setSize(Style.getInstance().TOGGLE_WIDTH + Style.getInstance().GLOBAL_PADDING + label.getWidth(impl), Style.getInstance().TOGGLE_HEIGHT);
        else setSize(Style.getInstance().TOGGLE_WIDTH, Style.getInstance().TOGGLE_HEIGHT);
        useBoundsClipRect();
        setInteractable(true);
        setSerializable(true);
        submitLayoutRequest();
        
        var da = (getAnimTargetOffsetX() - animOffsetX) * (impl.getDeltaTime() * Style.getInstance().TOGGLE_SPEED);
        animOffsetX += Math.isNaN(da) ? 0 : da;

        changedLastFrame = false;
        insideOfToggle = isInsideOfToggle(impl.getMouseX());
    }

}