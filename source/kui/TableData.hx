package kui;

class TableData {
    
    // Data
    public var data: Array<Array<Dynamic>>;
    public var columns: Array<String>;

    // Sorting
    private var sortColumn: Int = -1;
    private var sortAscending: Bool = true;

    /**
     * Create a new `TableData` instance.
     * @param columns The column names.
     * @param data The data in the table.
     */
    public function new(columns: Array<String>, data: Array<Array<Dynamic>>) {
        this.columns = columns;
        this.data = data;
    }

    /**
     * Set the data for the table.
     * @param data The data to set.
     */
    public function setData(data: Array<Array<Dynamic>>) {
        this.data = data;
        sortData();
    }

    /**
     * Set the columns for the table.
     * @param columns The columns to set.
     */
    public function setColumns(columns: Array<String>) {
        this.columns = columns;
    }

    /**
     * Toggle the sort order of a column.
     * @param column The column to toggle the sort order for.
     */
    public function toggleSort(column: Int) {
        if (sortColumn == column) {
            sortAscending = !sortAscending;
        } else {
            sortColumn = column;
            sortAscending = true;
        }
        sortData();
    }

    /**
     * Sort the data.
     */
    private function sortData() {
        if (sortColumn != -1) {
            data.sort(function(a, b) {
                var aValue = a[sortColumn];
                var bValue = b[sortColumn];
                return sortAscending ? Reflect.compare(aValue, bValue) : Reflect.compare(bValue, aValue);
            });
        }
    }

    /**
     * Get the columns.
     * @return Array<String> The columns.
     */
    public function getSortedData(): Array<Array<Dynamic>> {
        return data;
    }

    /**
     * Get the columns.
     * @return Array<String> The columns.
     */
    public function getSortColumn(): Int {
        return sortColumn;
    }

    /**
     * Get the columns.
     * @return Bool Whether the sort is ascending.
     */
    public function isSortAscending(): Bool {
        return sortAscending;
    }
    
}
