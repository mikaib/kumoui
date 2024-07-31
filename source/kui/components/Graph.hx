package kui.components;

import kui.util.TextStorage;
import kui.impl.Base;

class Graph extends Component {
    private var label: TextStorage = new TextStorage();
    private var points: Array<Float> = [];
    private var width: Float = 0;
    private var height: Float = 0;

    private var hover: Bool = false;
    private var lines: Array<{ x1: Float, y1: Float, x2: Float, y2: Float }> = [];
    private var optimizedLines: Array<{ x1: Float, y1: Float, x2: Float, y2: Float }> = [];

    private var cachedMinY: Float = Math.POSITIVE_INFINITY;
    private var cachedMaxY: Float = Math.NEGATIVE_INFINITY;
    private var cachedGraphWidth: Float = 0;
    private var cachedGraphHeight: Float = 0;

    override function onMouseHoverEnter(impl: Base) hover = true;
    override function onMouseHoverExit(impl: Base) hover = false;

    private function calculateMinMaxY() {
        cachedMinY = Math.POSITIVE_INFINITY;
        cachedMaxY = Math.NEGATIVE_INFINITY;

        for (i in 0...points.length) {
            var point = points[i];
            if (point < cachedMinY) cachedMinY = point;
            if (point > cachedMaxY) cachedMaxY = point;
        }

        if (cachedMinY == Math.POSITIVE_INFINITY) cachedMinY = 0;
    }

    private function precomputeLines() {
        lines.resize(0);
        var x = getBoundsX() + Style.GRAPH_INNER_PADDING;
        var y = getBoundsY() + Style.GRAPH_INNER_PADDING;
        var w = width - Style.GRAPH_INNER_PADDING * 2;
        var h = height - Style.GRAPH_INNER_PADDING * 2;

        if (w != cachedGraphWidth || h != cachedGraphHeight) {
            calculateMinMaxY();
            cachedGraphWidth = w;
            cachedGraphHeight = h;
        }

        if (points.length > 0) {
            var dx = w / (points.length - 1);
            var scaleY = (cachedMaxY == cachedMinY) ? 1.0 : h / (cachedMaxY - cachedMinY);

            var prevX = x;
            var prevY = y + h - (points[0] - cachedMinY) * scaleY;

            for (i in 1...points.length) {
                var nextX = x + i * dx;
                var nextY = y + h - (points[i] - cachedMinY) * scaleY;

                var line = KumoUI.acquireDataPoolItem();
                line.x1 = prevX;
                line.y1 = prevY;
                line.x2 = nextX;
                line.y2 = nextY;
                lines.push(line);

                prevX = nextX;
                prevY = nextY;
            }

            optimizedLines.resize(0);
            for (i in 0...lines.length) {
                var line = lines[i];
                if (i == 0) {
                    optimizedLines.push(line);
                } else {
                    var lastLine = optimizedLines[optimizedLines.length - 1];
                    var lastSlope = (lastLine.y2 - lastLine.y1) / (lastLine.x2 - lastLine.x1);
                    var currentSlope = (line.y2 - line.y1) / (line.x2 - line.x1);
                    if (Math.abs(lastSlope - currentSlope) < 1) {
                        lastLine.x2 = line.x2;
                        lastLine.y2 = line.y2;
                    } else {
                        optimizedLines.push(line);
                    }
                } 
            }
        }
    }

    override function onRender(impl: Base) {
        if (points == null) return;

        calculateMinMaxY();
        precomputeLines();

        var x = getBoundsX() + Style.GRAPH_INNER_PADDING;
        var y = getBoundsY() + Style.GRAPH_INNER_PADDING;
        var w = width - Style.GRAPH_INNER_PADDING * 2;
        var h = height - Style.GRAPH_INNER_PADDING * 2;

        impl.drawRect(getBoundsX(), getBoundsY(), width, height, Style.GRAPH_BACKGROUND_COLOR, Style.GRAPH_BACKGROUND_ROUNDING);

        for (line in optimizedLines) {
            impl.drawLine(line.x1, line.y1, line.x2, line.y2, Style.GRAPH_LINE_COLOR, Style.GRAPH_LINE_THICKNESS);
        }

        if (hover) {
            var mx = impl.getMouseX();
            var my = impl.getMouseY();
            var dx = w / (points.length - 1);
            var pointIndex = Math.round((mx - x) / dx);
            if (pointIndex >= 0 && pointIndex < points.length) {
                var scaleY = (cachedMaxY == cachedMinY) ? 1.0 : h / (cachedMaxY - cachedMinY);
                var pointX = x + pointIndex * dx;
                var pointY = y + h - (points[pointIndex] - cachedMinY) * scaleY;
                impl.drawLine(pointX, y, pointX, y + h, Style.GRAPH_POINT_COLOR, Style.GRAPH_POINTLINE_SIZE);
                impl.drawCircle(pointX, pointY, Style.GRAPH_POINT_SIZE, Style.GRAPH_POINT_COLOR);
                impl.drawText('(${points[pointIndex]})', pointX + Style.GLOBAL_PADDING, pointY - Style.GLOBAL_PADDING - 16, Style.GRAPH_POINT_COLOR, 16, REGULAR);
            }
        }

        var labelText = label.getText();
        var labelWidth = label.getWidth(impl);
        var textX = x + (w / 2) - (labelWidth / 2);
        var textY = y;
        impl.drawText(labelText, textX, textY, label.color, label.size, label.font);
    }

    override function onDataUpdate(data: Dynamic): Dynamic {
        label.text = data.text ?? '';
        label.size = data.size ?? Style.TEXT_DEFAULT_SIZE;
        label.font = data.font ?? Style.TEXT_DEFAULT_FONT;
        points = data.points ?? null;
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
