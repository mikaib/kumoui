package kui.components;

import kui.util.TextStorage;
import kui.impl.Base;

class Graph extends Component {

    private var label: TextStorage = new TextStorage();
    private var points: Array<Float> = [];
    private var width: Float = 0;
    private var height: Float = 0;
    
    private var hover: Bool = false;

    override function onMouseHoverEnter(impl:Base) hover = true;
    override function onMouseHoverExit(impl:Base) hover = false;

    override function onRender(impl: Base) {
        var x = getBoundsX() + Style.getInstance().GRAPH_INNER_PADDING;
        var y = getBoundsY() + Style.getInstance().GRAPH_INNER_PADDING;
        var w = width - Style.getInstance().GRAPH_INNER_PADDING * 2;
        var h = height - Style.getInstance().GRAPH_INNER_PADDING * 2;
        var pointsArray = points;
        var numPoints = pointsArray.length;
        
        impl.drawRect(getBoundsX(), getBoundsY(), width, height, Style.getInstance().GRAPH_BACKGROUND_COLOR, Style.getInstance().GRAPH_BACKGROUND_ROUNDING);

        if (numPoints > 0) {
            var dx = w / (numPoints - 1);

            var minY = Math.POSITIVE_INFINITY;
            var maxY = Math.NEGATIVE_INFINITY;
            for (i in 0...numPoints) {
                var point = pointsArray[i];
                if (point < minY) minY = point;
                if (point > maxY) maxY = point;
            }

            if (minY == Math.POSITIVE_INFINITY) minY = 0;
            
            var scaleY = (maxY == minY) ? 1.0 : h / (maxY - minY);
    
            var prevX = x;
            var prevY = y + h - (pointsArray[0] - minY) * scaleY;
            
            for (i in 1...numPoints) {
                var nextX = x + i * dx;
                var nextY = y + h - (pointsArray[i] - minY) * scaleY;
                impl.drawLine(prevX, prevY, nextX, nextY, Style.getInstance().GRAPH_LINE_COLOR, Style.getInstance().GRAPH_LINE_THICKNESS);
                prevX = nextX;
                prevY = nextY;
            }

            if (hover) {
                var mx = impl.getMouseX();
                var my = impl.getMouseY();
                var pointIndex = Math.round((mx - x) / dx);
                if (pointIndex >= 0 && pointIndex < numPoints) {
                    var pointX = x + pointIndex * dx;
                    var pointY = y + h - (pointsArray[pointIndex] - minY) * scaleY;
                    impl.drawLine(pointX, y, pointX, y + h, Style.getInstance().GRAPH_POINT_COLOR, Style.getInstance().GRAPH_POINTLINE_SIZE);
                    impl.drawCircle(pointX, pointY, Style.getInstance().GRAPH_POINT_SIZE, Style.getInstance().GRAPH_POINT_COLOR);
                    impl.drawText('(${pointsArray[pointIndex]})', pointX + Style.getInstance().GLOBAL_PADDING, Math.min(Math.max(pointY - 8, getBoundsY()), getBoundsY() + getBoundsWidth()), Style.getInstance().GRAPH_POINT_COLOR, 16, REGULAR);
                }
            }
        }

        var labelText = label.getText();
        var labelWidth = label.getWidth(impl);
        var textX = x + (w / 2) - (labelWidth / 2);
        var textY = y;
        impl.drawText(labelText, textX, textY, label.color, label.size, label.font);
    }    

    override function onDataUpdate(data: Dynamic): Dynamic {
        label.text = data.text ?? label.text;
        label.size = data.size ?? Style.getInstance().TEXT_DEFAULT_SIZE;
        label.font = data.font ?? Style.getInstance().TEXT_DEFAULT_FONT;
        points = data.points ?? points;
        width = data.width ?? width;
        height = data.height ?? height;
        return null;
    }

    override function onLayoutUpdate(impl: Base) {
        useLayoutPosition();
        setSize(width, height);
        useBoundsClipRect();
        setInteractable(true);
        submitLayoutRequest();
    }

}