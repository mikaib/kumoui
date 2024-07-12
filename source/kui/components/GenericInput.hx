package kui.components;

import kui.util.TextStorage;
import kui.impl.Base;
import kui.KeyboardInput;

class GenericInput extends Component {
    private var value: TextStorage = new TextStorage();
    private var label: TextStorage = new TextStorage();
    private var placeholder: TextStorage = new TextStorage();
    private var caretBlinkSpeed: Float = Style.INPUT_CARET_BLINK_SPEED;

    private var width: Float = Style.INPUT_DEFAULT_WIDTH;
    private var height: Float = Style.INPUT_DEFAULT_HEIGHT;

    private var interactingWith: Bool = false;
    private var textOffsetX: Float = 0;

    private var caretPosition: Int = 0;
    private var selectionStart: Int = -1;
    private var caretX: Float = 0;
    private var caretBlinkIn: Float = 0;
    private var caretState: Bool = true;

    private var isMouseDragging: Bool = false;
    private var mouseDraggingSelectionSize: Int = 0;

    public function new() {
        placeholder.color = Style.INPUT_PLACEHOLDER_COLOR;
    }

    override function onMouseClick(impl: Base) {
        if (impl.getMouseX() <= getBoundsX() + width) {
            interactingWith = true;

            if (mouseDraggingSelectionSize > 0) return;
            caretGotoMouse(impl);
            selectionStart = caretPosition;
        } else {
            interactingWith = false;
        }
    }

    override function onMouseDown(impl: Base) {
        if (impl.getMouseX() <= getBoundsX() + width) {
            interactingWith = true;
            caretGotoMouse(impl);
            selectionStart = caretPosition;
            isMouseDragging = true;
        }
    }

    override function onMouseUp(impl: Base) {
        isMouseDragging = false;
    }

    public function caretGotoMouse(impl: Base) {
        var mouseX = impl.getMouseX();
        var clickPositionX = mouseX - getBoundsX() - Style.INPUT_PADDING + textOffsetX;

        var low = 0;
        var high = value.text.length;

        while (low < high) {
            var mid = (low + high) >>> 1;
            var cumulativeWidth = calculateTextWidthUpToPosition(mid, impl);

            if (cumulativeWidth < clickPositionX) {
                low = mid + 1;
            } else {
                high = mid;
            }
        }

        caretPosition = low;
        calculateCaretPosition(impl);
    }

    private function calculateTextWidthUpToPosition(position: Int, impl: Base): Float {
        var textBeforePosition = value.text.substring(0, position);
        return impl.measureTextWidth(textBeforePosition, value.getSize(), value.getFont());
    }

    override function onMouseClickOutside(impl: Base) {
        interactingWith = false;
    }

    override function onSerialize(): Dynamic {
        return { value: value.text };
    }

    override function onDataUpdate(data: Dynamic): Dynamic {
        if (!interactingWith) {
            value.text = data.value ?? value.text;
        }

        // value.size = data.size ?? value.size;
        // value.font = data.font ?? value.font;
        // value.color = data.color ?? value.color;

        label.text = data.label ?? label.text;
        label.size = data.labelSize ?? Style.TEXT_DEFAULT_SIZE;
        label.font = data.labelFont ?? Style.TEXT_DEFAULT_FONT;
        label.color = data.labelColor ?? Style.TEXT_DEFAULT_COLOR;

        placeholder.text = data.placeholder ?? placeholder.text;
        // placeholder.size = data.size ?? placeholder.size;
        // placeholder.font = data.font ?? placeholder.font;
        // placeholder.color = data.placeholderColor ?? placeholder.color;

        width = data.width ?? width;
        height = data.height ?? height;

        return value.text;
    }

    override function onRender(impl: Base) {
        impl.drawRect(getBoundsX(), getBoundsY(), width, height, Style.INPUT_BACKGROUND_COLOR, Style.INPUT_ROUNDING);

        if (label.text != '') {
            impl.drawText(
                label.getText(),
                getBoundsX() + width + Style.GLOBAL_PADDING,
                getBoundsY() + (getBoundsHeight() - label.getHeight(impl)) / 2,
                label.getColor(),
                label.getSize(),
                label.getFont()
            );
        }

        impl.setClipRect(
            getBoundsX() + Style.INPUT_PADDING,
            getBoundsY(),
            width - (Style.INPUT_PADDING * 2),
            getBoundsHeight()
        );

        if (value.text == '') {
            impl.drawText(
                placeholder.getText(),
                getBoundsX() + Style.INPUT_PADDING,
                getBoundsY() + (getBoundsHeight() - placeholder.getHeight(impl)) / 2,
                placeholder.getColor(),
                placeholder.getSize(),
                placeholder.getFont()
            );
        } else {
            var textToRender = value.text;
            var textWidth = impl.measureTextWidth(textToRender, value.getSize(), value.getFont());
            var renderX = getBoundsX() + Style.INPUT_PADDING - textOffsetX;

            if (textWidth < width - (Style.INPUT_PADDING * 2)) {
                renderX = getBoundsX() + Style.INPUT_PADDING;
            }

            impl.drawText(
                textToRender,
                renderX,
                getBoundsY() + (getBoundsHeight() - value.getHeight(impl)) / 2,
                value.getColor(),
                value.getSize(),
                value.getFont()
            );
        }

        if (selectionStart != -1 && selectionStart != caretPosition) {
            var startPos = Std.int(Math.min(selectionStart, caretPosition));
            var endPos = Std.int(Math.max(selectionStart, caretPosition));
            var startPosText = value.text.substring(0, startPos);
            var selectionX1 = getBoundsX() + Style.INPUT_PADDING - textOffsetX + impl.measureTextWidth(startPosText, value.getSize(), value.getFont());
            var endPosText = value.text.substring(0, endPos);
            var selectionX2 = getBoundsX() + Style.INPUT_PADDING - textOffsetX + impl.measureTextWidth(endPosText, value.getSize(), value.getFont());

            impl.drawRect(
                selectionX1,
                getBoundsY() + Style.INPUT_CARET_INNER_PADDING,
                selectionX2 - selectionX1,
                getBoundsHeight() - (Style.INPUT_CARET_INNER_PADDING * 2),
                Style.INPUT_SELECTION_COLOR
            );
        }

        applyClipToImpl(impl);

        if (interactingWith && caretState) {
            impl.drawRect(
                getBoundsX() + caretX,
                getBoundsY() + Style.INPUT_CARET_INNER_PADDING,
                Style.INPUT_CARET_THICKNESS,
                getBoundsHeight() - (Style.INPUT_CARET_INNER_PADDING * 2),
                Style.INPUT_CARET_COLOR,
                Style.INPUT_CARET_ROUNDING
            );
        }
    }

    public function calculateCaretPosition(impl: Base) {
        var textBeforeCaret = value.text.substring(0, caretPosition);
        var textWidthBeforeCaret = impl.measureTextWidth(textBeforeCaret, value.getSize(), value.getFont());

        var totalTextWidth = impl.measureTextWidth(value.getText(), value.getSize(), value.getFont());
        var availableWidth = width - 2 * Style.INPUT_PADDING;

        if (textWidthBeforeCaret - textOffsetX > availableWidth) {
            textOffsetX = textWidthBeforeCaret - availableWidth;
        } else if (textWidthBeforeCaret < textOffsetX) {
            textOffsetX = textWidthBeforeCaret;
        } else if (totalTextWidth < availableWidth) {
            textOffsetX = 0;
        } else if (textOffsetX > totalTextWidth - availableWidth) {
            textOffsetX = Math.max(0, totalTextWidth - availableWidth);
        }

        caretX = textWidthBeforeCaret - textOffsetX + Style.INPUT_PADDING;
        resetCaretBlink();
    }

    private function resetCaretBlink() {
        caretBlinkIn = caretBlinkSpeed;
        caretState = true;
    }

    override function onLayoutUpdate(impl: Base) {
        useLayoutPosition();

        if (label.text != '') {
            setSize(width + Style.GLOBAL_PADDING + label.getWidth(impl), height);
        } else {
            setSize(width, height);
        }

        setInteractable(true);
        setSerializable(true);
        useBoundsClipRect();
        submitLayoutRequest();

        if (interactingWith) {
            updateCaretBlink(impl);
            processKeyboardInput(impl);
        }

        if (isMouseDragging) {
            caretGotoMouse(impl);
            mouseDraggingSelectionSize = caretPosition - selectionStart;
        }
    }

    private function updateCaretBlink(impl: Base) {
        caretBlinkIn -= impl.getDeltaTime();
        if (caretBlinkIn < 0) {
            caretState = !caretState;
            caretBlinkIn = caretBlinkSpeed;
        }
    }

    private function processKeyboardInput(impl: Base) {
        var pressedKeys = KeyboardInput.getPressedKeys();
        var caretChanged = false;

        if (KeyboardInput.isKeyDown(KEY_CTRL)) {
            if (processCtrlShortcuts(impl)) calculateCaretPosition(impl);
            if (!KeyboardInput.isKeyDown(KEY_LEFT) && !KeyboardInput.isKeyDown(KEY_RIGHT)) return;
        }

        for (key in pressedKeys) {
            switch(key) {
                case KEY_BACKSPACE:
                    caretChanged = processBackspace() || caretChanged;
                    break;
                case KEY_ENTER:
                case KEY_ESCAPE:
                    interactingWith = false;
                    break;
                case KEY_SPACE:
                    insertText(impl, ' ');
                    caretChanged = true;
                    break;
                case KEY_HOME:
                    caretPosition = 0;
                    caretChanged = true;
                    break;
                case KEY_END:
                    caretPosition = value.text.length;
                    caretChanged = true;
                    break;
                case KEY_LEFT:
                    caretChanged = moveCaretLeft() || caretChanged;
                    break;
                case KEY_RIGHT:
                    caretChanged = moveCaretRight() || caretChanged;
                    break;
                default:
                    if (Std.string(key).length == 1) {
                        insertText(impl, Std.string(key));
                        caretChanged = true;
                    }
            }
        }

        if (caretChanged) calculateCaretPosition(impl);
    }

    private function processCtrlShortcuts(impl: Base): Bool {
        if (KeyboardInput.isKeyPressed(KEY_C)) {
            copyToClipboard(impl);
            return false;
        }
        if (KeyboardInput.isKeyPressed(KEY_V)) {
            pasteFromClipboard(impl);
            return true;
        }
        if (KeyboardInput.isKeyPressed(KEY_X)) {
            copyToClipboard(impl);
            deleteSelection();
            return true;
        }
        if (KeyboardInput.isKeyPressed(KEY_A)) {
            selectAll();
            return true;
        }
        if (KeyboardInput.isKeyPressed(KEY_BACKSPACE)) {
            deleteWord();
            return true;
        }
        return false;
    }

    private function processBackspace(): Bool {
        if (selectionStart != -1 && selectionStart != caretPosition) {
            deleteSelection();
            return true;
        }
        if (caretPosition > 0) {
            value.text = value.text.substring(0, caretPosition - 1) + value.text.substring(caretPosition);
            caretPosition = Std.int(Math.max(0, caretPosition - 1));
            return true;
        }
        return false;
    }

    private function moveCaretLeft(): Bool {
        updateSelection(KEY_LEFT);
        if (KeyboardInput.isKeyDown(KEY_CTRL)) {
            var prevSpace = value.text.lastIndexOf(' ', caretPosition - 2);
            caretPosition = prevSpace == -1 ? 0 : prevSpace + 1;
        } else {
            caretPosition = Std.int(Math.max(0, caretPosition - 1));
        }
        return true;
    }

    private function moveCaretRight(): Bool {
        updateSelection(KEY_RIGHT);
        if (KeyboardInput.isKeyDown(KEY_CTRL)) {
            var nextSpace = value.text.indexOf(' ', caretPosition + 1);
            caretPosition = nextSpace == -1 ? value.text.length : nextSpace;
        } else {
            caretPosition = Std.int(Math.min(value.text.length, caretPosition + 1));
        }
        return true;
    }

    private function updateSelection(direction: Key) {
        if (KeyboardInput.isKeyDown(KEY_SHIFT)) {
            if (selectionStart == -1) {
                selectionStart = caretPosition;
            }
        } else {
            selectionStart = -1;
        }
    }

    private function insertText(impl: Base, text: String) {
        if (selectionStart != -1 && selectionStart != caretPosition) {
            deleteSelection();
        }
        value.text = value.text.substring(0, caretPosition) + text + value.text.substring(caretPosition);
        caretPosition += text.length;
        selectionStart = -1;
        calculateCaretPosition(impl);
    }

    private function insertTextMock(impl: Base, text: String): String {
        if (selectionStart != -1 && selectionStart != caretPosition) {
            return value.text.substring(0, Std.int(Math.min(selectionStart, caretPosition))) + text + value.text.substring(Std.int(Math.max(selectionStart, caretPosition)));
        }
        return value.text.substring(0, caretPosition) + text + value.text.substring(caretPosition);
    }

    private function deleteSelection() {
        if (selectionStart == -1) return;
        var start = Std.int(Math.min(selectionStart, caretPosition));
        var end = Std.int(Math.max(selectionStart, caretPosition));
        value.text = value.text.substring(0, start) + value.text.substring(end);
        caretPosition = start;
        selectionStart = -1;
    }

    private function copyToClipboard(impl: Base) {
        if (selectionStart == -1) return;
        var start = Std.int(Math.min(selectionStart, caretPosition));
        var end = Std.int(Math.max(selectionStart, caretPosition));
        impl.setClipboard(value.text.substring(start, end));
    }

    private function pasteFromClipboard(impl: Base) {
        var clipboardText = impl.getClipboard();
        if (clipboardText != null) {
            insertText(impl, clipboardText);
        }
    }

    private function selectAll() {
        selectionStart = 0;
        caretPosition = value.text.length;
    }

    private function deleteWord() {
        deleteSelection();
        var prevSpace = value.text.lastIndexOf(' ', caretPosition - 1);
        if (prevSpace == -1) {
            value.text = '';
            caretPosition = 0;
        } else {
            value.text = value.text.substring(0, prevSpace) + value.text.substring(caretPosition);
            caretPosition = prevSpace;
        }
    }
}
