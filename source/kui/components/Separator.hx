package kui.components;

import kui.util.TextStorage;
import kui.impl.Base;

class Separator extends Component {

    private var color: Int = Style.getInstance().SEPARATOR_COLOR;
    private var thickness: Int = Style.getInstance().SEPARATOR_THICKNESS;
    private var rounding: Int = Style.getInstance().SEPARATOR_ROUNDING;

    override function onRender(impl: Base) impl.drawRect(getBoundsX(), getBoundsY(), getBoundsWidth(), getBoundsHeight(), color, thickness * (rounding / 100));

    override function onDataUpdate(data: Dynamic): Dynamic {
        color = data.color ?? Style.getInstance().SEPARATOR_COLOR;
        thickness = data.thickness ?? Style.getInstance().SEPARATOR_THICKNESS;
        return null;
    }

    override function onLayoutUpdate(impl: Base) {
        useLayoutPosition();
        setSize(KumoUI.getParentWidth() - (getBoundsX() - KumoUI.getParentX()) - Style.getInstance().GLOBAL_PADDING, thickness);
        useBoundsClipRect();
        submitLayoutRequest();
    }

}