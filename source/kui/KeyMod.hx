package kui;

enum abstract KeyMod(Int) {
    var NONE = 1 << 0;
    var SHIFT = 1 << 1;
    var CTRL = 1 << 2;
    var ALT = 1 << 3;
    var CAPS_LOCK = 1 << 4;
}