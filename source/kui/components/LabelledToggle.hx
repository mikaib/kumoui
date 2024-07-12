package kui.components;

import kui.impl.Base;
import kui.util.TextStorage;

class LabelledToggle extends Toggle {

    private var text: TextStorage = new TextStorage();
    
    override function onDataUpdate(data:Dynamic):Dynamic {
        text.text = data.text ?? text.text;
        text.size = data.size ?? text.size;
        text.color = data.color ?? text.color;
        return super.onDataUpdate(data);
    }

    override function onLayoutUpdate(impl:Base) {
        super.onLayoutUpdate(impl);
        setSize(Style.TOGGLE_WIDTH + Style.GLOBAL_PADDING + text.getWidth(impl), Style.TOGGLE_HEIGHT);
        useBoundsClipRect();
        submitLayoutRequest();
    }

    override function onRender(impl:Base) {
        super.onRender(impl);
        impl.drawText(text.getText(), getBoundsX() + Style.TOGGLE_WIDTH + Style.GLOBAL_PADDING, getBoundsY() + (Style.TOGGLE_HEIGHT / 2) - (text.getHeight(impl) / 2), text.color, text.size, text.font);
    }
}