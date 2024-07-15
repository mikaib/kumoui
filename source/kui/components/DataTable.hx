package kui.components;

import kui.Component;
import kui.impl.Base;
import kui.KumoUI;

class DataTable extends Component {
    private var tableData: TableData;
    private var rowHeight: Float = 0;
    private var headerHeight: Float = 40;
    private var tableWidth: Float = 10;

    public function new(tableData: TableData) {
        this.tableData = tableData;
    }

    public function setRowHeight(height: Float) {
        this.rowHeight = height;
    }

    public function setHeaderHeight(height: Float) {
        this.headerHeight = height;
    }

    override function onMouseClick(impl: Base) {
        var mouseX = impl.getMouseX() - getBoundsX();
        if (impl.getMouseY() - getBoundsY() < headerHeight) {
            var columnWidth = getTableWidth() / tableData.columns.length;
            var clickedColumn = Std.int(mouseX / columnWidth);
            tableData.toggleSort(clickedColumn);
        }
    }

    private function getTableWidth(): Float {
        return tableWidth;
    }

    private function toRad(deg: Float): Float {
        return deg * Math.PI / 180;
    }

    override function onRender(impl: Base) {
        var tableWidth = getTableWidth();
        impl.drawRect(getBoundsX(), getBoundsY(), tableWidth, headerHeight, Style.TABLE_HEADER_BACKGROUND_COLOR, Style.TABLE_HEADER_BACKGROUND_ROUNDING);

        for (i in 0...tableData.columns.length) {
            var columnWidth = tableWidth / tableData.columns.length;
            var columnX = getBoundsX() + (i * columnWidth);
            impl.drawText(
                tableData.columns[i],
                columnX + 10,
                getBoundsY() + (headerHeight - Style.TABLE_HEADER_TEXT_SIZE) / 2,
                Style.TABLE_HEADER_TEXT_COLOR,
                Style.TABLE_HEADER_TEXT_SIZE,
                Style.TABLE_HEADER_TEXT_FONT
            );

            if (tableData.getSortColumn() == i) {
                impl.drawTriangle(
                    columnX + columnWidth - 20,
                    getBoundsY() + headerHeight - (headerHeight * .5) - (tableData.isSortAscending() ? 0 : (headerHeight * .5) / 8),
                    headerHeight * 0.5,
                    tableData.isSortAscending() ? toRad(0) : toRad(180),
                    Style.TABLE_HEADER_TEXT_COLOR
                );
            }
        }

        var sortedData = tableData.getSortedData();
        var startIndex = Std.int((getClipY() - getBoundsY() - headerHeight) / rowHeight);
        var endIndex = Std.int((getClipY() + getClipHeight() - getBoundsY() - headerHeight) / rowHeight) + 1;

        for (i in startIndex...endIndex) {
            if (i < 0 || i >= sortedData.length) continue;
            var rowY = getBoundsY() + (headerHeight - Style.TABLE_CONTENT_SHIFT) + (i * rowHeight);
            var rowColor = (i % 2 == 0) ? Style.TABLE_ROW_BACKGROUND_COLOR : Style.TABLE_ROW_BACKGROUND_COLOR_ALT;
            impl.drawRect(getBoundsX(), rowY, tableWidth, rowHeight, rowColor, i == sortedData.length - 1 ? Style.TABLE_LAST_ROW_BACKGROUND_ROUNDING : Style.TABLE_ROW_BACKGROUND_ROUNDING);

            for (j in 0...tableData.columns.length) {
                var columnWidth = tableWidth / tableData.columns.length;
                var columnX = getBoundsX() + (j * columnWidth);
                var cellValue = sortedData[i][j];
    
                impl.drawRect(columnX, rowY, columnWidth, rowHeight, rowColor, i == sortedData.length - 1 ? Style.TABLE_LAST_ROW_BACKGROUND_ROUNDING : Style.TABLE_ROW_BACKGROUND_ROUNDING);
                impl.drawText(
                    Std.string(cellValue),
                    columnX + 10,
                    rowY + (rowHeight - Style.TABLE_ROW_TEXT_SIZE) / 2,
                    Style.TABLE_ROW_TEXT_COLOR,
                    Style.TABLE_ROW_TEXT_SIZE,
                    Style.TABLE_ROW_TEXT_FONT
                );
            }
        }
    }

    override function onLayoutUpdate(impl: Base) {
        useLayoutPosition();
        tableWidth = KumoUI.getInnerWidth();
        
        setSize(getTableWidth(), headerHeight + (tableData.data.length * rowHeight));
        setInteractable(true);
        useBoundsClipRect();
        submitLayoutRequest();
    }

    override function onDataUpdate(data: Dynamic): Dynamic {
        tableData = data.tableData ?? tableData;
        rowHeight = data.rowHeight ?? Style.TABLE_ROW_TEXT_SIZE + Style.GLOBAL_PADDING * 2;
        headerHeight = data.headerHeight ?? Style.TABLE_HEADER_TEXT_SIZE + Style.GLOBAL_PADDING * 2;
        return null;
    }
}
