package kui.components;

import kui.impl.Base;

class FloatInput extends GenericInput {

    private var min: Null<Float> = null;
    private var max: Null<Float> = null;

    override function onDataUpdate(data:Dynamic):Dynamic {
        min = data.min ?? min;
        max = data.max ?? max;
        return Std.parseFloat(super.onDataUpdate(data));
    }

    override function onRender(impl:Base) {
        super.onRender(impl);
        
        var x = getBoundsX() + width;
        var y = getBoundsY();
        var height = getBoundsHeight();

        impl.drawTrianglePoints(
            x - 10, y + 5,
            x - 5, y + 10,
            x - 15, y + 10,
            Style.INPUT_ARROW_COLOR
        );

        impl.drawTrianglePoints(
            x - 10, y + height - 5,
            x - 5, y + height - 10,
            x - 15, y + height - 10,
            Style.INPUT_ARROW_COLOR
        );
    }

    public function mouseOverArrows(impl:Base):Bool {
        var x = impl.getMouseX();
        var boundsX = getBoundsX();
        return x > boundsX + width - 15 && x < boundsX + width;
    }

    override function onMouseDown(impl:Base) if (!mouseOverArrows(impl)) super.onMouseDown(impl);
    override function onMouseUp(impl:Base) if (!mouseOverArrows(impl)) super.onMouseUp(impl);
    override function onMouseClick(impl:Base) {
        if (!mouseOverArrows(impl)) return super.onMouseClick(impl);
        if (interactingWith) interactingWith = false;

        var v = Std.parseFloat(value.getText());
        if (Math.isNaN(v)) v = 0;

        if (impl.getMouseY() < getBoundsY() + getBoundsHeight() / 2) {
            if (v < max || max == null) v++;
        } else {
            if (v > min || min == null) v--;
        }

        value.text = Std.string(v);
    }
        
    override function insertText(impl:Base, text:String) {
        var mock = insertTextMock(impl, text);
        var parsed = Std.parseFloat(mock);

        var usedDot = false;
        for (i in 0...mock.length) {
            var c = mock.charCodeAt(i);
            if (c < 48 || c > 57) {
                if (c != 46 && (c != 45 || i != 0)) return;
                if (c == 46) {
                    if (usedDot) return;
                    usedDot = true;
                }
            }
        }

        if (mock == '-' || mock == '.') return super.insertText(impl, text);

        if (Math.isNaN(parsed)) return;
        if (parsed < min && min != null) return;
        if (parsed > max && max != null) return;

        super.insertText(impl, text);
    }

}