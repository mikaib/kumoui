package kui;

import kui.impl.Base;

class Component {

    public var boundsX: Float = 0;
    public var boundsY: Float = 0;
    public var boundsWidth: Float = 0;
    public var boundsHeight: Float = 0;

    public var containerClip: Bool = false;
    public var clipX: Float = 0;
    public var clipY: Float = 0;
    public var clipWidth: Null<Float> = null;
    public var clipHeight: Null<Float> = null;

    public var _sameLine: Bool = false;

    public function getId(): String return null; // A component should only assign an ID to itself IF it has a state that has to ALWAYS be preserved (like windows)
    public function isInteractable(): Bool return false; // A component should only be interactable if it has a state that can be changed by the user
    public function getPriority(): Int return 0; // A component should only have a priority if it has to be rendered in a specific order
    public function getReturnValue(): Dynamic return null;

    public function update(args: Dynamic) {}
    public function destroy() {}

    public function render(impl: Base) {}
    public function postRender() {}

    public function onMouseHoverEnter(impl: Base) {}
    public function onMouseHoverExit(impl: Base) {}
    public function onMouseClick(impl: Base) {}
    public function onMouseDown(impl: Base) {}
    public function onMouseUp(impl: Base) {}

    public function setAbsolutePosition(x: Float, y: Float) {
        Layout.setPositionAbsolute(x, y);
    }

    public function startContainer() {
        var previous = KumoUI.containerStack.peek();

        KumoUI.containerStack.push(this);
        Layout.createPositionalBranch(boundsX, boundsY);

        if (previous != null) setContainerClip(previous.clipX, previous.clipY, previous.clipWidth, previous.clipHeight);
    }

    public function setContainerClip(x: Float, y: Float, width: Float, height: Float) {
        var componentArray = KumoUI.containerStack.toArray();
        var previous = componentArray[componentArray.length - 2];

        clipX = previous != null ? Math.max(x, previous.clipX) : x;
        clipY = previous != null ? Math.max(y, previous.clipY) : y;
        clipWidth = previous != null ? Math.min(x + width, previous.clipX + previous.clipWidth) - clipX : width;
        clipHeight = previous != null ? Math.min(y + height, previous.clipY + previous.clipHeight) - clipY : height;
    }

    public function endContainer() {
        KumoUI.containerStack.pop();
        Layout.endPositionalBranch();
    }

    public function updateAllBounds(x: Float, y: Float, width: Float, height: Float) {
        updateLayoutBounds(x, y, width, height);
        updateComponentBounds(x, y, width, height);
    }

    public function updateLayoutBounds(x: Float, y: Float, width: Float, height: Float) {
        Layout.prevX = x;
        Layout.prevY = y;
        Layout.prevWidth = width;
        Layout.prevHeight = height;
    }

    public function updateComponentBounds(x: Float, y: Float, width: Float, height: Float) {
        boundsX = x;
        boundsY = y;
        boundsWidth = width;
        boundsHeight = height;
    }

}