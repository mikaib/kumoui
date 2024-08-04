package kui.demo;

import kui.components.Text;

class StyleEditor {

    public static var editingTheme: Style = new Style();
    public static var liveTheme: Style;
    public static var exportContent: String = "";

    public static function use() {
        KumoUI.beginWindow("Style editor", "kui_style_editor");

        var didChange = false;
        var shouldRefresh = false;

        if (KumoUI.button("Reset")) {
            editingTheme = new Style();
            shouldRefresh = true;
        }
        
        KumoUI.sameLine();

        var shouldLiveTheme = KumoUI.toggle("kui_style_editor_live", "Preview");
        if (KumoUI.button("Refresh")) shouldRefresh = true;

        if (shouldLiveTheme) {
            if (liveTheme == null) {
                liveTheme = Style.instance;
                shouldRefresh = true;
            }
            if (shouldRefresh) {
                var copy = new Style();
                for (key in Reflect.fields(editingTheme)) Reflect.setField(copy, key, Reflect.field(editingTheme, key));
            
                Style.instance = copy;
                KumoUI.text('Refreshing, please wait...'); // Hacky way to force a refresh
            }
        } else {
            if (liveTheme != null) {
                Style.instance = liveTheme;
                liveTheme = null;
                KumoUI.text('Refreshing, please wait...'); // Hacky way to force a refresh
            }
        }

        if (KumoUI.button("Export")) exportContent = export();
        if (KumoUI.button("Import")) import_(exportContent);
        KumoUI.sameLine();
        exportContent = KumoUI.inputText("kui_style_editor_export", "Export content", null, exportContent);

        KumoUI.separator();

        for (key in Reflect.fields(editingTheme)) {
            var value: Dynamic = Reflect.field(editingTheme, key);
            var newValue: Dynamic = null;
            if (Std.isOfType(value, Int)) {
                newValue = KumoUI.inputInt("kui_style_editor_" + key, key, null, null, null, value);
            } else if (Std.isOfType(value, Float)) {
                newValue = KumoUI.inputFloat("kui_style_editor_" + key, key, null, null, null, value);
            } else if (Std.isOfType(value, Bool)) {
                newValue = KumoUI.toggle("kui_style_editor_" + key, key, value);
            } else if (Std.isOfType(value, String)) {
                newValue = KumoUI.inputText("kui_style_editor_" + key, key, null, value);
            }

            if (newValue != null && newValue != value) didChange = true;
            Reflect.setField(editingTheme, key, newValue); 
        }

        KumoUI.endWindow();
    }

    public static function export(): String {
        var content = "class MyTheme extends Style {\n";
        content += "    public function new() {\n";

        for (key in Reflect.fields(editingTheme)) {
            var value = Reflect.field(editingTheme, key);
            content += "        " + key + " = " + Std.string(value) + ";\n";
        }

        content += "    }\n";
        content += "}\n";

        return content;
    }

    public static function import_(content: String) {
        var lines = content.split("\n");
        var theme = new Style();
        var fields = Type.getInstanceFields(Style);
        for (line in lines) {
            var parts = line.split("=");
            if (parts.length != 2) continue;
            var key = StringTools.trim(parts[0]);
            var value = StringTools.trim(parts[1]).split(";")[0];
            
            if (fields.contains(key)) {
                var field = Reflect.field(theme, key);
                if (Std.isOfType(field, Int)) Reflect.setField(theme, key, Std.parseInt(value));
                else if (Std.isOfType(field, Float)) Reflect.setField(theme, key, Std.parseFloat(value));
                else if (Std.isOfType(field, Bool)) Reflect.setField(theme, key, value == "true");
                else if (Std.isOfType(field, String)) Reflect.setField(theme, key, value);
            }
        }

        trace(theme.SCROLL_VPADDING);
        editingTheme = theme;

        if (liveTheme != null) {
            var copy = new Style();
            for (key in Reflect.fields(editingTheme)) Reflect.setField(copy, key, Reflect.field(editingTheme, key));
        
            Style.instance = copy;
            KumoUI.text('Refreshing, please wait...'); // Hacky way to force a refresh
        }
    }

}
 


