package kui;

class KeyboardInput {

    // Current states (up/down)
    public static var keyStates: Map<Key, Bool> = new Map();

    // last pressed / frame pressed keys
    public static var framePressedKeys: Array<Key> = [];
    public static var lastFrameDownKeys: Array<Key> = [];

    // Repeat state
    public static var lastRepeatKey: Key = null;
    public static var lastRepeatTime: Float = 0;

    // Config
    public static var repeatTime: Float = 0.05;
    public static var initialRepeatTime: Float = 0.45;

    // Modifiers
    public static var shiftMod: Bool = false;
    public static var capsMod: Bool = false;

    // The map which is responsible for mapping keys to their shifted versions, will not work for keyboards with a different layout
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

    /**
     * Get a key with the current modifiers applied.
     * @param key The key to get.
     * @return Key The key with the modifiers applied.
     */
    public static function getKeyWithModsApplied(key: Key): Key {
        if (!shiftMod && !capsMod) return key;
        else {
            var k = Std.string(shiftMod ? (shiftLayerMap[key] ?? key) : key);
            return k.length > 1 ? k : k.toUpperCase();
        }
    }

    /**
     * Report a key state.
     * @param key The key that was down.
     */
    public static function reportKey(key: Key) {
        if (framePressedKeys.indexOf(key) == -1 && key != null) {
            framePressedKeys.push(getKeyWithModsApplied(key));
        }
    }

    /**
     * Set the current shift state.
     * @param state The state to set.
     */
    public static function setCurrentShiftMod(state: Bool) {
        shiftMod = state;
    }

    /**
     * Set the current caps lock state.
     * @param state The state to set.
     */
    public static function setCurrentCapsMod(state: Bool) {
        capsMod = state;
    }

    /**
     * Get all keys that are currently down.
     * @return Array<Key> The keys that are currently down.
     */
    public static function getDownKeys(): Array<Key> {
        return framePressedKeys.copy();
    }

    /**
     * Check if a key is down.
     * @param key The key to check.
     * @return Bool Whether the key is down.
     */
    public static function isKeyDown(key: Key): Bool {
        return keyStates.exists(key) && keyStates.get(key);
    }

    /**
     * Check if a key is up.
     * @param key The key to check.
     * @return Bool Whether the key is up.
     */
    public static function isKeyUp(key: Key): Bool {
        return !keyStates.exists(key) || !keyStates.get(key);
    }

    /**
     * Check if a key is pressed.
     * @param key The key to check.
     * @return Bool Whether the key is pressed this frame.
     */
    public static function isKeyPressed(key: Key): Bool {
        return keyStates.exists(key) && keyStates.get(key) && lastFrameDownKeys.indexOf(key) == -1;
    }

    /**
     * Check if a key is released.
     * @param key The key to check.
     * @return Bool Whether the key is released.
     */
    public static function isKeyReleased(key: Key): Bool {
        return (!keyStates.exists(key) || !keyStates.get(key)) && lastFrameDownKeys.indexOf(key) != -1;
    }

    /**
     * Check if a key is being repeated.
     * @param key The key to check.
     * @return Bool Whether the key is being repeated.
     */
    public static function isKeyRepeat(key: Key): Bool {
        return lastRepeatKey != null && lastRepeatKey == key && isKeyDown(key);
    }

    /**
     * Begin a new frame.
     */
    public static function beginFrame() {
        lastFrameDownKeys.resize(0);
        for (key in framePressedKeys) {
            lastFrameDownKeys.push(key);
        }
        framePressedKeys.resize(0);
    }

    /**
     * Called in the backend, will submit and update the key states.
     */
    public static function submit() {
        var newRepeatKey: Key = null;

        for (key in framePressedKeys) {
            if (!keyStates.exists(key) || !keyStates.get(key)) {
                newRepeatKey = key;
                break;
            }
        }

        if (newRepeatKey != null && lastRepeatKey != newRepeatKey) {
            var time = #if js js.lib.Date.now() #else Sys.time() #end;
            lastRepeatKey = newRepeatKey;
            lastRepeatTime =  time + initialRepeatTime;
        }

        for (key in lastFrameDownKeys) {
            keyStates.set(key, framePressedKeys.indexOf(key) != -1);
        }
        for (key in framePressedKeys) {
            keyStates.set(key, true);
        }

        keyStates.set(KEY_SHIFT, shiftMod);
    }

    /**
     * Get all keys that were pressed this frame.
     * @return Array<Key> The keys that were pressed this frame.
     */
    public static function getPressedKeys(): Array<Key> {
        var time = #if js js.lib.Date.now() #else Sys.time() #end;
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
