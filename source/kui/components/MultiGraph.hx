package kui.components;

import kui.util.TextStorage;
import kui.impl.Base;

class MultiGraph extends Component {
    private var pointArrays: Array<{ points: Array<Float>, ?label: String, ?color: Int }> = [];
    private var width: Float = 0;
    private var height: Float = 0;
    private var hover: Bool = false;
    private var cachedMinY: Float = Math.POSITIVE_INFINITY;
    private var cachedMaxY: Float = Math.NEGATIVE_INFINITY;
    private var cachedGraphWidth: Float = 0;
    private var cachedGraphHeight: Float = 0;
    private var lines: Array<Array<{ x1: Float, y1: Float, x2: Float, y2: Float }>> = [];
    private var rawLines: Array<{ x1: Float, y1: Float, x2: Float, y2: Float }> = [];

    override function onMouseHoverEnter(impl: Base) hover = true;
    override function onMouseHoverExit(impl: Base) hover = false;

    private function calculateMinMaxY() {
        cachedMinY = Math.POSITIVE_INFINITY;
        cachedMaxY = Math.NEGATIVE_INFINITY;

        for (pointArray in pointArrays) {
            var points = pointArray.points;
            var numPoints = points.length;

            for (i in 0...numPoints) {
                var point = points[i];
                if (point < cachedMinY) cachedMinY = point;
                if (point > cachedMaxY) cachedMaxY = point;
            }
        }

        if (cachedMinY == Math.POSITIVE_INFINITY) cachedMinY = 0;
    }

    private function precomputeLines() {
        lines = [];
        var x = getBoundsX() + Style.GRAPH_INNER_PADDING;
        var y = getBoundsY() + Style.GRAPH_INNER_PADDING;
        var w = width - Style.GRAPH_INNER_PADDING * 2;
        var h = height - Style.GRAPH_INNER_PADDING * 2;

        if (w != cachedGraphWidth || h != cachedGraphHeight) {
            calculateMinMaxY();
            cachedGraphWidth = w;
            cachedGraphHeight = h;
        }

        var scaleY = (cachedMaxY == cachedMinY) ? 1.0 : h / (cachedMaxY - cachedMinY);

        for (pointArray in pointArrays) {
            var points = pointArray.points;
            var numPoints = points.length;
            rawLines.resize(0);

            if (numPoints > 0) {
                var dx = w / (numPoints - 1);

                var prevX = x;
                var prevY = y + h - (points[0] - cachedMinY) * scaleY;

                for (i in 1...numPoints) {
                    var nextX = x + i * dx;
                    var nextY = y + h - (points[i] - cachedMinY) * scaleY;
                    
                    var line = KumoUI.acquireDataPoolItem();
                    line.x1 = prevX;
                    line.y1 = prevY;
                    line.x2 = nextX;
                    line.y2 = nextY;
                    
                    prevX = nextX;
                    prevY = nextY;

                    rawLines.push(line);
                }

                var optimizedLines: Array<{ x1: Float, y1: Float, x2: Float, y2: Float }> = [];
                var slopeThreshold = cachedGraphWidth / numPoints;
                for (i in 0...rawLines.length) {
                    var line = rawLines[i];
                    if (i == 0) {
                        optimizedLines.push(line);
                    } else {
                        var lastLine = optimizedLines[optimizedLines.length - 1];
                        var lastSlope = (lastLine.y2 - lastLine.y1) / (lastLine.x2 - lastLine.x1);
                        var currentSlope = (line.y2 - line.y1) / (line.x2 - line.x1);
             
                        if (Math.abs(lastSlope - currentSlope) < slopeThreshold) {
                            lastLine.x2 = line.x2;
                            lastLine.y2 = line.y2;
                        } else {
                            optimizedLines.push(line);
                        }
                    }
                }
                lines.push(optimizedLines);
            }
        }
    }

    override function onRender(impl: Base) {
        if (pointArrays == null) return;

        var x = getBoundsX() + Style.GRAPH_INNER_PADDING;
        var y = getBoundsY() + Style.GRAPH_INNER_PADDING;
        var w = width - Style.GRAPH_INNER_PADDING * 2;
        var h = height - Style.GRAPH_INNER_PADDING * 2;

        calculateMinMaxY();
        precomputeLines();

        impl.drawRect(getBoundsX(), getBoundsY(), width, height, Style.GRAPH_BACKGROUND_COLOR, Style.GRAPH_BACKGROUND_ROUNDING);

        for (i in 0...lines.length) {
            var graphLines = lines[i];
            var pointArray = pointArrays[i];
            var color = pointArray.color != null ? pointArray.color : Style.GRAPH_LINE_COLOR;
            for (line in graphLines) {
                impl.drawLine(line.x1, line.y1, line.x2, line.y2, color, Style.GRAPH_LINE_THICKNESS);
            }
        }

        if (hover) {
            if (pointArrays.length == 0) return;
            var mx = impl.getMouseX();
            var my = impl.getMouseY();
            var dx = w / (pointArrays[0].points.length - 1);
            var pointIndex = Math.round((mx - x) / dx);
            if (pointIndex >= 0 && pointIndex < pointArrays[0].points.length) {
                var scaleY = (cachedMaxY == cachedMinY) ? 1.0 : h / (cachedMaxY - cachedMinY);

                for (pointArray in pointArrays) {
                    var pointX = x + pointIndex * dx;
                    var pointY = y + h - (pointArray.points[pointIndex] - cachedMinY) * scaleY;
                    impl.drawLine(pointX, y, pointX, y + h, Style.GRAPH_POINT_COLOR, Style.GRAPH_POINTLINE_SIZE);
                    impl.drawCircle(pointX, pointY, Style.GRAPH_POINT_SIZE, Style.GRAPH_POINT_COLOR);
                    var labelText = pointArray.label != null ? '${pointArray.label} (${pointArray.points[pointIndex]})' : '(${pointIndex}, ${pointArray.points[pointIndex]})';
                    impl.drawText(labelText, pointX + Style.GLOBAL_PADDING, pointY - Style.GLOBAL_PADDING - 16, Style.GRAPH_POINT_COLOR, 16, REGULAR);
                }
            }
        }

        var ty = y + Style.GLOBAL_PADDING;
        for (pointArray in pointArrays) {
            impl.drawCircle(x + Style.GLOBAL_PADDING, ty, 6, pointArray.color != null ? pointArray.color : 0xFFFFFF);
            impl.drawText(pointArray.label, x + Style.GLOBAL_PADDING + 16, ty - 6, pointArray.color != null ? pointArray.color : 0xFFFFFF, 12, REGULAR);
            ty += 16;
        }
    }

    override function onDataUpdate(data: Dynamic): Dynamic {
        pointArrays = data.pointArrays ?? null;
        width = data.width ?? 0;
        height = data.height ?? 0;

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
