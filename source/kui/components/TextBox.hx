package kui.components;

import kui.impl.Base;

class TextBox extends GenericInput {

    private var autoScaleHeight: Bool = true;

    public function new() {
        super();
        multiLineSupport = true;
    }

    override function onDataUpdate(data:Dynamic):Dynamic {
        if (data.height) {
            autoScaleHeight = false;
            height = data.height;
        } else autoScaleHeight = true;
        return super.onDataUpdate(data);
    }
    
    override function onLayoutUpdate(impl:Base) {
        super.onLayoutUpdate(impl);
        height = Math.max(value.size * value.text.split('\n').length, Style.INPUT_DEFAULT_HEIGHT);
    }

}