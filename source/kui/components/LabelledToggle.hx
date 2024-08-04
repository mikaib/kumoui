package kui.components;

import kui.impl.Base;
import kui.util.TextStorage;

class LabelledToggle extends Toggle {

    private var text: TextStorage = new TextStorage();
    
    override function onDataUpdate(data:Dynamic):Dynamic {
        text.text = data.text ?? '';
        text.size = data.size ?? Style.getInstance().TEXT_DEFAULT_SIZE;
        text.color = data.color ?? Style.getInstance().TEXT_DEFAULT_COLOR;
        return super.onDataUpdate(data);
    }

    override function onLayoutUpdate(impl:Base) {
        super.onLayoutUpdate(impl);
        setSize(Style.getInstance().TOGGLE_WIDTH + Style.getInstance().GLOBAL_PADDING + text.getWidth(impl), Style.getInstance().TOGGLE_HEIGHT);
        useBoundsClipRect();
        submitLayoutRequest();
    }

    override function onRender(impl:Base) {
        super.onRender(impl);
        impl.drawText(text.getText(), getBoundsX() + Style.getInstance().TOGGLE_WIDTH + Style.getInstance().GLOBAL_PADDING, getBoundsY() + (Style.getInstance().TOGGLE_HEIGHT / 2) - (text.getHeight(impl) / 2), text.color, text.size, text.font);
    }
}