package kui.components;

import kui.util.TextStorage;
import kui.impl.Base;

class Separator extends Component {

    private var color: Int = Style.SEPARATOR_COLOR;
    private var thickness: Int = Style.SEPARATOR_THICKNESS;
    private var rounding: Int = Style.SEPARATOR_ROUNDING;

    override function onRender(impl: Base) impl.drawRect(getBoundsX(), getBoundsY(), getBoundsWidth(), getBoundsHeight(), color, thickness * (rounding / 100));

    override function onDataUpdate(data: Dynamic): Dynamic {
        color = data.color ?? Style.SEPARATOR_COLOR;
        thickness = data.thickness ?? Style.SEPARATOR_THICKNESS;
        return null;
    }

    override function onLayoutUpdate(impl: Base) {
        useLayoutPosition();
        setSize(KumoUI.getParentWidth() - (getBoundsX() - KumoUI.getParentX()) - Style.GLOBAL_PADDING, thickness);
        useBoundsClipRect();
        submitLayoutRequest();
    }

}