package kui;

class KeyboardInput {

    public static var keyStates: Map<Key, Bool> = new Map();
    public static var framePressedKeys: Array<Key> = [];
    public static var lastFrameDownKeys: Array<Key> = [];
    public static var lastRepeatKey: Key = null;
    public static var lastRepeatTime: Float = 0;
    public static var repeatTime: Float = 0.05;
    public static var initialRepeatTime: Float = 0.45;
    public static var shiftMod: Bool = false;
    public static var capsMod: Bool = false;

    private static var shiftLayerMap: Map<Key, Key> = [
        KEY_MINUS => KEY_UNDERSCORE,
        KEY_EQUALS => KEY_PLUS,
        KEY_OPEN_BRACKET => KEY_OPEN_BRACE,
        KEY_CLOSE_BRACKET => KEY_CLOSE_BRACE,
        KEY_BACKSLASH => KEY_PIPE,
        KEY_SEMICOLON => KEY_COLON,
        KEY_SINGLE_QUOTE => KEY_DOUBLE_QUOTE,
        KEY_GRAVE => KEY_TILDE,
        KEY_COMMA => KEY_LESS_THAN,
        KEY_PERIOD => KEY_GREATER_THAN,
        KEY_SLASH => KEY_QUESTION,
        KEY_1 => KEY_EXCLAMATION,
        KEY_2 => KEY_AT,
        KEY_3 => KEY_HASH,
        KEY_4 => KEY_DOLLAR,
        KEY_5 => KEY_PERCENT,
        KEY_6 => KEY_CARET,
        KEY_7 => KEY_AMPERSAND,
        KEY_8 => KEY_ASTERISK,
        KEY_9 => KEY_LEFT_PARENTHESIS,
        KEY_0 => KEY_RIGHT_PARENTHESIS
    ];

    public static function getKeyWithModsApplied(key: Key): Key {
        if (!shiftMod && !capsMod) return key;
        else {
            var k = Std.string(shiftMod ? (shiftLayerMap[key] ?? key) : key);
            return k.length > 1 ? k : k.toUpperCase();
        }
    }

    public static function reportKey(key: Key) {
        if (framePressedKeys.indexOf(key) == -1 && key != null) {
            framePressedKeys.push(getKeyWithModsApplied(key));
        }
    }

    public static function setCurrentShiftMod(state: Bool) {
        shiftMod = state;
    }

    public static function setCurrentCapsMod(state: Bool) {
        capsMod = state;
    }

    public static function getDownKeys(): Array<Key> {
        return framePressedKeys.copy();
    }

    public static function isKeyDown(key: Key): Bool {
        return keyStates.exists(key) && keyStates.get(key);
    }

    public static function isKeyUp(key: Key): Bool {
        return !keyStates.exists(key) || !keyStates.get(key);
    }

    public static function isKeyPressed(key: Key): Bool {
        return keyStates.exists(key) && keyStates.get(key) && lastFrameDownKeys.indexOf(key) == -1;
    }

    public static function isKeyReleased(key: Key): Bool {
        return (!keyStates.exists(key) || !keyStates.get(key)) && lastFrameDownKeys.indexOf(key) != -1;
    }

    public static function isKeyRepeat(key: Key): Bool {
        return lastRepeatKey != null && lastRepeatKey == key && isKeyDown(key);
    }

    public static function beginFrame() {
        lastFrameDownKeys = framePressedKeys.copy();
        framePressedKeys = [];
    }

    public static function submit() {
        var newRepeatKey: Key = null;

        for (key in framePressedKeys) {
            if (!keyStates.exists(key) || !keyStates.get(key)) {
                newRepeatKey = key;
                break;
            }
        }

        if (newRepeatKey != null && lastRepeatKey != newRepeatKey) {
            lastRepeatKey = newRepeatKey;
            lastRepeatTime = Sys.time() + initialRepeatTime;
        }

        for (key in lastFrameDownKeys) {
            keyStates.set(key, framePressedKeys.indexOf(key) != -1);
        }
        for (key in framePressedKeys) {
            keyStates.set(key, true);
        }

        keyStates.set(KEY_SHIFT, shiftMod);
    }

    public static function getPressedKeys(): Array<Key> {
        var time = Sys.time();
        var pressedKeys: Array<Key> = framePressedKeys.copy().filter(function(key) {
            return lastFrameDownKeys.indexOf(key) == -1;
        });
        if (lastRepeatKey != null && time - lastRepeatTime > repeatTime) {
            if (keyStates.get(lastRepeatKey) != true) {
                lastRepeatKey = null;
                return pressedKeys;
            }
            pressedKeys.push(lastRepeatKey);
            lastRepeatTime = time;
        }
        return pressedKeys;
    }

}
