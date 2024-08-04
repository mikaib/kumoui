package kui.components;

import kui.util.TextStorage;
import kui.impl.Base;

class MultiGraph extends Component {

    private var pointArrays: Array<{ points: Array<Float>, ?label: String, ?color: Int }> = [];
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
    
        impl.drawRect(getBoundsX(), getBoundsY(), width, height, Style.getInstance().GRAPH_BACKGROUND_COLOR, Style.getInstance().GRAPH_BACKGROUND_ROUNDING);
    
        // Calculate overall minY and maxY across all datasets
        var overallMinY = Math.POSITIVE_INFINITY;
        var overallMaxY = Math.NEGATIVE_INFINITY;
    
        for (pointArray in pointArrays) {
            var points = pointArray.points;
            var numPoints = points.length;
    
            if (numPoints > 0) {
                var minY = Math.POSITIVE_INFINITY;
                var maxY = Math.NEGATIVE_INFINITY;
                for (i in 0...numPoints) {
                    var point = points[i];
                    if (point < minY) minY = point;
                    if (point > maxY) maxY = point;
                }
    
                if (minY < overallMinY) overallMinY = minY;
                if (maxY > overallMaxY) overallMaxY = maxY;
            }
        }
    
        // Ensure overallMinY and overallMaxY are properly defined
        if (overallMinY == Math.POSITIVE_INFINITY) overallMinY = 0;
        if (overallMaxY == Math.NEGATIVE_INFINITY) overallMaxY = 0;
    
        var scaleY = h / (overallMaxY - overallMinY);
    
        // Render each dataset
        var ty = y + Style.getInstance().GLOBAL_PADDING;
        for (pointArray in pointArrays) {
            var points = pointArray.points;
            var numPoints = points.length;
    
            if (numPoints > 0) {
                var dx = w / (numPoints - 1);
    
                var prevX = x;
                var prevY = y + h - (points[0] - overallMinY) * scaleY;
    
                for (i in 0...numPoints) {
                    var nextX = x + i * dx;
                    var nextY = y + h - (points[i] - overallMinY) * scaleY;
                    var color = pointArray.color != null ? pointArray.color : Style.getInstance().GRAPH_LINE_COLOR;
                    impl.drawLine(prevX, prevY, nextX, nextY, color, Style.getInstance().GRAPH_LINE_THICKNESS);
                    prevX = nextX;
                    prevY = nextY;
                }
    
                if (hover) {
                    var mx = impl.getMouseX();
                    var my = impl.getMouseY();
                    var pointIndex = Math.round((mx - x) / dx);
                    if (pointIndex >= 0 && pointIndex < numPoints) {
                        var pointX = x + pointIndex * dx;
                        var pointY = y + h - (points[pointIndex] - overallMinY) * scaleY;
                        var pointValue = points[pointIndex];
                        impl.drawLine(pointX, y, pointX, y + h, Style.getInstance().GRAPH_POINT_COLOR, Style.getInstance().GRAPH_POINTLINE_SIZE);
                        impl.drawCircle(pointX, pointY, Style.getInstance().GRAPH_POINT_SIZE, Style.getInstance().GRAPH_POINT_COLOR);
                        var labelText = pointArray.label != null ? '${pointArray.label} (${pointValue}})' : '(${pointIndex}, ${points[pointIndex]})';
                        impl.drawText(labelText, pointX + Style.getInstance().GLOBAL_PADDING, Math.min(Math.max(pointY - 8, getBoundsY()), getBoundsY() + getBoundsWidth()), Style.getInstance().GRAPH_POINT_COLOR, 16, REGULAR);
                    }
                }
            }
        }

        for (pointArray in pointArrays) {
            impl.drawCircle(x + Style.getInstance().GLOBAL_PADDING, ty, 6, pointArray.color != null ? pointArray.color : 0xFFFFFF);
            impl.drawText(pointArray.label, x + Style.getInstance().GLOBAL_PADDING + 16, ty - 6, pointArray.color != null ? pointArray.color : 0xFFFFFF, 12, REGULAR);
            ty += 16;
        }
    }
    
    override function onDataUpdate(data: Dynamic): Dynamic {
        pointArrays = data.pointArrays ?? pointArrays;
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