package kui.components;

import kui.Component;
import kui.impl.Base;
import kui.KumoUI;

class Container extends Component {
    private var backgroundColor: Int = Style.getInstance().CONTAINER_BACKGROUND_COLOR;
    private var containerWidth: Float = 0;
    private var containerHeight: Float = Style.getInstance().CONTAINER_DEFAULT_HEIGHT;

    public function new() {}

    public function setBackgroundColor(color: Int) {
        this.backgroundColor = color;
    }

    public function setContainerHeight(height: Float) {
        this.containerHeight = height;
    }

    override function onRender(impl: Base) {
        impl.drawRect(getBoundsX(), getBoundsY(), containerWidth, containerHeight, backgroundColor, Style.getInstance().CONTAINER_ROUNDING);
    }

    override function onLayoutUpdate(impl: Base) {
        useLayoutPosition();

        containerWidth = containerWidth == 0 ? KumoUI.getInnerWidth() : containerWidth;
        setSize(containerWidth, containerHeight);
        submitLayoutRequest();
        setClipRect(getBoundsX(), getBoundsY(), getBoundsWidth(), getBoundsHeight());
        beginParentContainer();
        submitAbsolutePositioningRequest(getBoundsX(), getBoundsY(), 0, 0);
    }

    override function onDataUpdate(data: Dynamic): Dynamic {
        backgroundColor = data.backgroundColor ?? Style.getInstance().CONTAINER_BACKGROUND_COLOR;
        containerHeight = data.containerHeight ?? Style.getInstance().CONTAINER_DEFAULT_HEIGHT;
        containerWidth = data.containerWidth ?? 0;
        return null;
    }
}
