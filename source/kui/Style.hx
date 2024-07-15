package kui;

class Style {

    // Globals
    public static inline final GLOBAL_PADDING: Int = 8;

    // Windows
    public static inline final WINDOW_MIN_WIDTH: Int = 200;
    public static inline final WINDOW_BODY_ROUNDING: Int = 5;
    public static inline final WINDOW_BODY_COLOR: Int = 0x212833;
    public static inline final WINDOW_HEADER_COLOR: Int = 0x11141a;
    public static inline final WINDOW_HEADER_HEIGHT: Int = 30;
    public static inline final WINDOW_HEADER_TEXT_SIZE: Int = 16;
    public static inline final WINDOW_HEADER_TEXT_COLOR: Int = 0xffffff;
    public static inline final WINDOW_HEADER_TEXT_HPADDING: Int = 32;
    public static inline final WINDOW_HEADER_TEXT_VPADDING: Int = 8;
    public static inline final WINDOW_HEADER_TEXT_FONT: FontType = FontType.BOLD;
    public static inline final WINDOW_HEADER_ROUNDING: Int = 5;
    public static inline final WINDOW_COLLAPSE_SIZE: Int = 16;
    public static inline final WINDOW_COLLAPSE_COLOR: Int = 0xffffff;
    public static inline final WINDOW_RESIZE_SIZE: Int = 20;
    public static inline final WINDOW_RESIZE_COLOR: Int = 0x11141a;
    public static inline final WINDOW_RESIZE_COLOR_HOVER: Int = 0x0E51C7;

    // Scrollable Container
    public static inline final SCROLL_PADDING: Int = 12;
    public static inline final SCROLL_WIDTH: Int = 12;
    public static inline final SCROLL_GUTTER_COLOR: Int = 0x11141a;
    public static inline final SCROLL_GUTTER_ROUNDING: Int = 3;
    public static inline final SCROLL_BAR_COLOR: Int = 0xffffff;
    public static inline final SCROLL_BAR_ROUNDING: Int = 3;
    
    // Button
    public static inline final BUTTON_INNER_PADDING: Int = 16;
    public static inline final BUTTON_TEXT_COLOR: Int = 0xffffff;
    public static inline final BUTTON_TEXT_SIZE: Int = 16;
    public static inline final BUTTON_TEXT_FONT: FontType = FontType.BOLD;
    public static inline final BUTTON_ROUNDING: Int = 5;
    public static inline final BUTTON_COLOR: Int = 0x11141a;
    public static inline final BUTTON_COLOR_HOVER: Int = 0x191d26;
    public static inline final BUTTON_COLOR_ACTIVE: Int = 0x323c4d;
    public static inline final BUTTON_TEXT_UPPERCASE: Bool = true;

    // Toggle
    public static inline final TOGGLE_ROUNDING: Int = 10;
    public static inline final TOGGLE_WIDTH: Int = 60;
    public static inline final TOGGLE_HEIGHT: Int = 28;
    public static inline final TOGGLE_BASE_COLOR: Int = 0x11141a;
    public static inline final TOGGLE_BASE_COLOR_HOVER: Int = 0x191d26;
    public static inline final TOGGLE_ENABLED_COLOR: Int = 0x08B926;
    public static inline final TOGGLE_ENABLED_COLOR_HOVER: Int = 0x0CCC2C;
    public static inline final TOGGLE_GRIP_COLOR: Int = 0xd4d4d4;
    public static inline final TOGGLE_GRIP_COLOR_HOVER: Int = 0xffffff;
    public static inline final TOGGLE_PADDING: Int = 2;

    // Slider
    public static inline final SLIDER_HEIGHT: Int = 28;
    public static inline final SLIDER_WIDTH: Int = 200;
    public static inline final SLIDER_PADDING: Int = 2;
    public static inline final SLIDER_BASE_COLOR: Int = 0x11141a;
    public static inline final SLIDER_BASE_COLOR_HOVER: Int = 0x191d26;
    public static inline final SLIDER_BASE_COLOR_ACTIVE: Int = 0x323c4d;
    public static inline final SLIDER_GRIP_COLOR: Int = 0xd4d4d4;
    public static inline final SLIDER_GRIP_COLOR_HOVER: Int = 0xffffff;
    public static inline final SLIDER_GRIP_COLOR_ACTIVE: Int = 0xffffff;
    public static inline final SLIDER_SELECTED_COLOR: Int = 0x9c9c9c;
    public static inline final SLIDER_SELECTED_COLOR_HOVER: Int = 0xb4b4b4;
    public static inline final SLIDER_SELECTED_COLOR_ACTIVE: Int = 0xb4b4b4;
    public static inline final SLIDER_ROUNDING: Int = 10;

    // Table
    public static var TABLE_HEADER_BACKGROUND_COLOR: Int = 0x11141a;
    public static var TABLE_HEADER_BACKGROUND_ROUNDING: Int = 5;
    public static var TABLE_HEADER_TEXT_COLOR: Int = 0xffffff;
    public static var TABLE_HEADER_TEXT_SIZE: Int = 16;
    public static var TABLE_HEADER_TEXT_FONT: FontType = FontType.BOLD;
    public static var TABLE_ROW_BACKGROUND_COLOR: Int = 0x191d26;
    public static var TABLE_ROW_BACKGROUND_COLOR_ALT: Int = 0x11141a;
    public static var TABLE_CONTENT_SHIFT: Int = 5;
    public static var TABLE_ROW_BACKGROUND_ROUNDING: Int = 0;
    public static var TABLE_LAST_ROW_BACKGROUND_ROUNDING: Int = 0;
    public static var TABLE_ROW_TEXT_COLOR: Int = 0xffffff;
    public static var TABLE_ROW_TEXT_SIZE: Int = 16;
    public static var TABLE_ROW_TEXT_FONT: FontType = FontType.REGULAR;

    // Graph
    public static inline final GRAPH_BACKGROUND_COLOR: Int = 0x11141a;
    public static inline final GRAPH_INNER_PADDING: Int = 4;
    public static inline final GRAPH_BACKGROUND_ROUNDING: Int = 5;
    public static inline final GRAPH_LINE_COLOR: Int = 0x727272;
    public static inline final GRAPH_LINE_THICKNESS: Int = 2;
    public static inline final GRAPH_POINT_COLOR: Int = 0xADADAD;
    public static inline final GRAPH_POINT_SIZE: Int = 4;
    public static inline final GRAPH_POINTLINE_SIZE: Int = 2;

    // Collapse
    public static inline final COLLAPSE_INNER_PADDING: Int = 16;
    public static inline final COLLAPSE_TEXT_COLOR: Int = 0xffffff;
    public static inline final COLLAPSE_TEXT_SIZE: Int = 16;
    public static inline final COLLAPSE_TEXT_FONT: FontType = FontType.BOLD;
    public static inline final COLLAPSE_ROUNDING: Int = 5;
    public static inline final COLLAPSE_COLOR: Int = 0x11141a;
    public static inline final COLLAPSE_COLOR_HOVER: Int = 0x191d26;
    public static inline final COLLAPSE_COLOR_ACTIVE: Int = 0x323c4d;
    public static inline final COLLAPSE_TEXT_UPPERCASE: Bool = true;

    // Text
    public static inline final TEXT_DEFAULT_COLOR: Int = 0xffffff;
    public static inline final TEXT_DEFAULT_SIZE: Int = 16;
    public static inline final TEXT_DEFAULT_FONT: FontType = FontType.REGULAR;
    
    // Generic Input
    public static inline final INPUT_DEFAULT_WIDTH: Int = 200;
    public static inline final INPUT_DEFAULT_HEIGHT: Int = 32;
    public static inline final INPUT_BACKGROUND_COLOR: Int = 0x11141a;
    public static inline final INPUT_PLACEHOLDER_COLOR: Int = 0x727272;
    public static inline final INPUT_CARET_COLOR: Int = 0xffffff;
    public static inline final INPUT_CARET_THICKNESS: Int = 3;
    public static inline final INPUT_CARET_INNER_PADDING: Int = 6;
    public static inline final INPUT_CARET_ROUNDING: Int = 2;
    public static inline final INPUT_ROUNDING: Int = 5;
    public static inline final INPUT_PADDING: Int = 8;
    public static inline final INPUT_CARET_BLINK_SPEED: Float = .5;
    public static inline final INPUT_SELECTION_COLOR: Int = 0x3fffffff;
    public static inline final INPUT_ARROW_COLOR: Int = 0xffffff;

    // Tree Collapse
    public static inline final TREECOLLAPSE_TEXT_COLOR: Int = 0xffffff;
    public static inline final TREECOLLAPSE_TEXT_SIZE: Int = 16;
    public static inline final TREECOLLAPSE_TEXT_FONT: FontType = FontType.REGULAR;
    public static inline final TREECOLLAPSE_TEXT_UPPERCASE: Bool = false;
    public static inline final TREECOLLAPSE_INDENT: Int = 16;

    // Separator
    public static inline final SEPARATOR_COLOR: Int = 0x3fffffff;
    public static inline final SEPARATOR_THICKNESS: Int = 3;
    public static inline final SEPARATOR_ROUNDING: Int = 50; // This rounding value is as a percentage of the thickness

    // Container
    public static inline final CONTAINER_BACKGROUND_COLOR: Int = 0x11141a;
    public static inline final CONTAINER_DEFAULT_HEIGHT: Float = 200;
    public static inline final CONTAINER_ROUNDING: Int = 5;
    
    // Animations
    public static inline final WINDOW_COLLAPSE_SPEED: Float = 25;
    public static inline final SCROLL_SPEED: Float = 25;
    public static inline final TOGGLE_SPEED: Float = 25;
}