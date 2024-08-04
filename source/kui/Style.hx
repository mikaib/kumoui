package kui;

class Style {

   public static var instance: Style = new Style();
   public static inline function getInstance(): Style { return instance; }
   public function new() {}

    // Globals
   public var GLOBAL_PADDING: Int = 8;

    // Windows
   public var WINDOW_MIN_WIDTH: Int = 200;
   public var WINDOW_BODY_ROUNDING: Int = 5;
   public var WINDOW_BODY_COLOR: Int = 0x212833;
   public var WINDOW_HEADER_COLOR: Int = 0x11141a;
   public var WINDOW_HEADER_HEIGHT: Int = 30;
   public var WINDOW_HEADER_TEXT_SIZE: Int = 16;
   public var WINDOW_HEADER_TEXT_COLOR: Int = 0xffffff;
   public var WINDOW_HEADER_TEXT_HPADDING: Int = 32;
   public var WINDOW_HEADER_TEXT_VPADDING: Int = 8;
   public var WINDOW_HEADER_TEXT_FONT: FontType = FontType.BOLD;
   public var WINDOW_HEADER_ROUNDING: Int = 5;
   public var WINDOW_COLLAPSE_SIZE: Int = 16;
   public var WINDOW_COLLAPSE_COLOR: Int = 0xffffff;
   public var WINDOW_RESIZE_SIZE: Int = 20;
   public var WINDOW_RESIZE_COLOR: Int = 0x11141a;
   public var WINDOW_RESIZE_COLOR_HOVER: Int = 0x0E51C7;

    // Scrollable Container
   public var SCROLL_HPADDING: Int = 8;
   public var SCROLL_VPADDING: Int = 8;
   public var SCROLL_WIDTH: Int = 12;
   public var SCROLL_GUTTER_COLOR: Int = 0x11141a;
   public var SCROLL_GUTTER_ROUNDING: Int = 3;
   public var SCROLL_BAR_COLOR: Int = 0xffffff;
   public var SCROLL_BAR_ROUNDING: Int = 3;
    
    // Button
   public var BUTTON_INNER_PADDING: Int = 16;
   public var BUTTON_TEXT_COLOR: Int = 0xffffff;
   public var BUTTON_TEXT_SIZE: Int = 16;
   public var BUTTON_TEXT_FONT: FontType = FontType.BOLD;
   public var BUTTON_ROUNDING: Int = 5;
   public var BUTTON_COLOR: Int = 0x11141a;
   public var BUTTON_COLOR_HOVER: Int = 0x191d26;
   public var BUTTON_COLOR_ACTIVE: Int = 0x323c4d;
   public var BUTTON_TEXT_UPPERCASE: Bool = true;

    // Toggle
   public var TOGGLE_ROUNDING: Int = 10;
   public var TOGGLE_WIDTH: Int = 60;
   public var TOGGLE_HEIGHT: Int = 28;
   public var TOGGLE_BASE_COLOR: Int = 0x11141a;
   public var TOGGLE_BASE_COLOR_HOVER: Int = 0x191d26;
   public var TOGGLE_ENABLED_COLOR: Int = 0x08B926;
   public var TOGGLE_ENABLED_COLOR_HOVER: Int = 0x0CCC2C;
   public var TOGGLE_GRIP_COLOR: Int = 0xd4d4d4;
   public var TOGGLE_GRIP_COLOR_HOVER: Int = 0xffffff;
   public var TOGGLE_PADDING: Int = 2;

    // Slider
   public var SLIDER_HEIGHT: Int = 28;
   public var SLIDER_WIDTH: Int = 200;
   public var SLIDER_PADDING: Int = 2;
   public var SLIDER_BASE_COLOR: Int = 0x11141a;
   public var SLIDER_BASE_COLOR_HOVER: Int = 0x191d26;
   public var SLIDER_BASE_COLOR_ACTIVE: Int = 0x323c4d;
   public var SLIDER_GRIP_COLOR: Int = 0xd4d4d4;
   public var SLIDER_GRIP_COLOR_HOVER: Int = 0xffffff;
   public var SLIDER_GRIP_COLOR_ACTIVE: Int = 0xffffff;
   public var SLIDER_SELECTED_COLOR: Int = 0x9c9c9c;
   public var SLIDER_SELECTED_COLOR_HOVER: Int = 0xb4b4b4;
   public var SLIDER_SELECTED_COLOR_ACTIVE: Int = 0xb4b4b4;
   public var SLIDER_ROUNDING: Int = 10;

    // Table
    public var TABLE_HEADER_BACKGROUND_COLOR: Int = 0x11141a;
    public var TABLE_HEADER_BACKGROUND_ROUNDING: Int = 5;
    public var TABLE_HEADER_TEXT_COLOR: Int = 0xffffff;
    public var TABLE_HEADER_TEXT_SIZE: Int = 16;
    public var TABLE_HEADER_TEXT_FONT: FontType = FontType.BOLD;
    public var TABLE_ROW_BACKGROUND_COLOR: Int = 0x191d26;
    public var TABLE_ROW_BACKGROUND_COLOR_ALT: Int = 0x11141a;
    public var TABLE_CONTENT_SHIFT: Int = 5;
    public var TABLE_ROW_BACKGROUND_ROUNDING: Int = 0;
    public var TABLE_LAST_ROW_BACKGROUND_ROUNDING: Int = 0;
    public var TABLE_ROW_TEXT_COLOR: Int = 0xffffff;
    public var TABLE_ROW_TEXT_SIZE: Int = 16;
    public var TABLE_ROW_TEXT_FONT: FontType = FontType.REGULAR;

    // Graph
   public var GRAPH_BACKGROUND_COLOR: Int = 0x11141a;
   public var GRAPH_INNER_PADDING: Int = 4;
   public var GRAPH_BACKGROUND_ROUNDING: Int = 5;
   public var GRAPH_LINE_COLOR: Int = 0x727272;
   public var GRAPH_LINE_THICKNESS: Int = 2;
   public var GRAPH_POINT_COLOR: Int = 0xADADAD;
   public var GRAPH_POINT_SIZE: Int = 4;
   public var GRAPH_POINTLINE_SIZE: Int = 2;

    // Collapse
   public var COLLAPSE_INNER_PADDING: Int = 16;
   public var COLLAPSE_TEXT_COLOR: Int = 0xffffff;
   public var COLLAPSE_TEXT_SIZE: Int = 16;
   public var COLLAPSE_TEXT_FONT: FontType = FontType.BOLD;
   public var COLLAPSE_ROUNDING: Int = 5;
   public var COLLAPSE_COLOR: Int = 0x11141a;
   public var COLLAPSE_COLOR_HOVER: Int = 0x191d26;
   public var COLLAPSE_COLOR_ACTIVE: Int = 0x323c4d;
   public var COLLAPSE_TEXT_UPPERCASE: Bool = true;

    // Text
   public var TEXT_DEFAULT_COLOR: Int = 0xffffff;
   public var TEXT_DEFAULT_SIZE: Int = 16;
   public var TEXT_DEFAULT_FONT: FontType = FontType.REGULAR;
    
    // Generic Input
   public var INPUT_DEFAULT_WIDTH: Int = 200;
   public var INPUT_DEFAULT_HEIGHT: Int = 32;
   public var INPUT_BACKGROUND_COLOR: Int = 0x11141a;
   public var INPUT_PLACEHOLDER_COLOR: Int = 0x727272;
   public var INPUT_CARET_COLOR: Int = 0xffffff;
   public var INPUT_CARET_THICKNESS: Int = 3;
   public var INPUT_CARET_INNER_PADDING: Int = 6;
   public var INPUT_CARET_ROUNDING: Int = 2;
   public var INPUT_ROUNDING: Int = 5;
   public var INPUT_PADDING: Int = 8;
   public var INPUT_CARET_BLINK_SPEED: Float = .5;
   public var INPUT_SELECTION_COLOR: Int = 0x3fffffff;
   public var INPUT_ARROW_COLOR: Int = 0xffffff;

    // Tree Collapse
   public var TREECOLLAPSE_TEXT_COLOR: Int = 0xffffff;
   public var TREECOLLAPSE_TEXT_SIZE: Int = 16;
   public var TREECOLLAPSE_TEXT_FONT: FontType = FontType.REGULAR;
   public var TREECOLLAPSE_TEXT_UPPERCASE: Bool = false;
   public var TREECOLLAPSE_INDENT: Int = 16;

    // Separator
   public var SEPARATOR_COLOR: Int = 0x3fffffff;
   public var SEPARATOR_THICKNESS: Int = 3;
   public var SEPARATOR_ROUNDING: Int = 50; // This rounding value is as a percentage of the thickness

    // Container
   public var CONTAINER_BACKGROUND_COLOR: Int = 0x11141a;
   public var CONTAINER_DEFAULT_HEIGHT: Float = 200;
   public var CONTAINER_ROUNDING: Int = 5;
    
    // Animations
   public var WINDOW_COLLAPSE_SPEED: Float = 30;
   public var SCROLL_SPEED: Float = 30;
   public var TOGGLE_SPEED: Float = 30;
}
