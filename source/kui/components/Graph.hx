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
        var x = getBoundsX() + Style.GRAPH_INNER_PADDING;
        var y = getBoundsY() + Style.GRAPH_INNER_PADDING;
        var w = width - Style.GRAPH_INNER_PADDING * 2;
        var h = height - Style.GRAPH_INNER_PADDING * 2;
        var pointsArray = points;
        var numPoints = pointsArray.length;
        
        impl.drawRect(getBoundsX(), getBoundsY(), width, height, Style.GRAPH_BACKGROUND_COLOR, Style.GRAPH_BACKGROUND_ROUNDING);

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
                impl.drawLine(prevX, prevY, nextX, nextY, Style.GRAPH_LINE_COLOR, Style.GRAPH_LINE_THICKNESS);
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
                    impl.drawLine(pointX, y, pointX, y + h, Style.GRAPH_POINT_COLOR, Style.GRAPH_POINTLINE_SIZE);
                    impl.drawCircle(pointX, pointY, Style.GRAPH_POINT_SIZE, Style.GRAPH_POINT_COLOR);
                    impl.drawText('(${pointsArray[pointIndex]})', pointX + Style.GLOBAL_PADDING, pointY - Style.GLOBAL_PADDING - 16, Style.GRAPH_POINT_COLOR, 16, REGULAR);
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
        label.size = data.size ?? Style.TEXT_DEFAULT_SIZE;
        label.font = data.font ?? Style.TEXT_DEFAULT_FONT;
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