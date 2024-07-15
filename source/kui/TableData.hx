package kui;

class TableData {
    public var data: Array<Array<Dynamic>>;
    public var columns: Array<String>;
    private var sortColumn: Int = -1;
    private var sortAscending: Bool = true;

    public function new(columns: Array<String>, data: Array<Array<Dynamic>>) {
        this.columns = columns;
        this.data = data;
    }

    public function setData(data: Array<Array<Dynamic>>) {
        this.data = data;
        sortData();
    }

    public function setColumns(columns: Array<String>) {
        this.columns = columns;
    }

    public function toggleSort(column: Int) {
        if (sortColumn == column) {
            sortAscending = !sortAscending;
        } else {
            sortColumn = column;
            sortAscending = true;
        }
        sortData();
    }

    private function sortData() {
        if (sortColumn != -1) {
            data.sort(function(a, b) {
                var aValue = a[sortColumn];
                var bValue = b[sortColumn];
                return sortAscending ? Reflect.compare(aValue, bValue) : Reflect.compare(bValue, aValue);
            });
        }
    }

    public function getSortedData(): Array<Array<Dynamic>> {
        return data;
    }

    public function getSortColumn(): Int {
        return sortColumn;
    }

    public function isSortAscending(): Bool {
        return sortAscending;
    }
}
