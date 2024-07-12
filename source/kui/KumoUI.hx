package kui;

import kui.util.Stack;
import haxe.PosInfos;
import kui.impl.Base;

class KumoUI {

    // Options
    public static var debugDraw: Bool = false;

    // Component lists
    public static var currentComponents: Array<Component> = [];
    public static var currentWantedComponents: Array<{ cl: Class<Component>, data: Dynamic, id: String, sameLine: Bool }> = [];

    // Layout stuff
    public static var containerStack: Stack<Component> = new Stack<Component>();
    public static var _sameLine: Bool = false;

    // Element focus
    public static var lastHoveredElement: Component = null;
    public static var previouslyClickedElement: Component = null;

    // Add a component to the current wanted components list
    public static function addComponent(comp: Class<Component>, data: Dynamic) : Dynamic {
        currentWantedComponents.push({ cl: ComponentRegistry.getComponent(comp), data: data, id: data?.id ?? null, sameLine: _sameLine });

        var currentMatched = currentComponents[currentWantedComponents.length - 1];
        _sameLine = false;

        if (currentMatched != null && currentMatched.getId() == currentWantedComponents[currentWantedComponents.length - 1].id) return currentMatched.getReturnValue();
        return null;
    }

    // Various elements
    public static inline function beginWindow(title: String, ?id: String, ?x: Float, ?y: Float, ?width: Float, ?height: Float): Void addComponent(kui.components.Window, { title: title, id: id, x: x, y: y, width: width, height: height });
    public static inline function endWindow(): Void addComponent(kui.components.ContainerEnd, null);
    public static inline function text(text: String, ?color: Int, ?fontSize: Int, ?fontType: FontType): Void addComponent(kui.components.Text, { text: text, color: color, size: fontSize, font: fontType });
    public static inline function button(text: String, ?fontSize: Int, ?fontType: FontType): Bool return addComponentBool(kui.components.Button, { text: text, size: fontSize, font: fontType });

    // Layout stuff
    public static inline function sameLine(): Void _sameLine = true;

    // Variations of addComponent
    public static inline function addComponentInt(comp: Class<Component>, data: Dynamic): Int return addComponent(comp, data) ?? 0;
    public static inline function addComponentFloat(comp: Class<Component>, data: Dynamic): Float return addComponent(comp, data) ?? 0.0;
    public static inline function addComponentBool(comp: Class<Component>, data: Dynamic): Bool return addComponent(comp, data) ?? false;
    public static inline function addComponentString(comp: Class<Component>, data: Dynamic): String return addComponent(comp, data) ?? '';

    // Debug log
    public static inline function debugLog(m: Dynamic, ?posInfo: PosInfos) Sys.println('[kui debug] (${posInfo.fileName}:${posInfo.lineNumber}) in ${posInfo.className}.${posInfo.methodName}: ${Std.string(m)}');

    // Push a container onto the container stack
    public static function pushContainer(comp: Component) containerStack.push(comp);

    // Various parent getters
    public static function getParentX() {
        var top = containerStack.peek();
        return top != null ? top.boundsX : 0;
    }

    public static function getParentY() {
        var top = containerStack.peek();
        return top != null ? top.boundsY : 0;
    }

    public static function getParentWidth() {
        var top = containerStack.peek();
        return top != null ? top.boundsWidth : Layout.screenW;
    }

    public static function getParentHeight() {
        var top = containerStack.peek();
        return top != null ? top.boundsHeight : Layout.screenH;
    }

    public static function getParentClipX() {
        var top = containerStack.peek();
        return top != null ? top.clipX : 0;
    }

    public static function getParentClipY() {
        var top = containerStack.peek();
        return top != null ? top.clipY : 0;
    }

    public static function getParentClipWidth() {
        var top = containerStack.peek();
        return top != null ? top.clipWidth : Layout.screenW;
    }

    public static function getParentClipHeight() {
        var top = containerStack.peek();
        return top != null ? top.clipHeight : Layout.screenH;
    }

    // Update components
    private static function updateComponents() {
        var usedIds: Map<String, Bool> = new Map();
        var i = 0;

        for (wanted in currentWantedComponents) {
            var wantedClassName = Type.getClassName(wanted.cl);
            var wantedId = wanted.id;
            var found = false;

            // Try to find a matching component in currentComponents by ID
            for (j in i...currentComponents.length) {
                var current = currentComponents[j];
                var currentClassName = Type.getClassName(Type.getClass(current));
                var currentId = current.getId();

                if (currentClassName == wantedClassName && currentId == wantedId) {
                    // Match found, update component and mark as used
                    current.update(wanted.data);
                    current._sameLine = wanted.sameLine;
                    usedIds.set(currentId, true);
                    // Move matched component to the correct position
                    if (i != j) {
                        currentComponents.splice(j, 1);
                        currentComponents.insert(i, current);
                    }
                    found = true;
                    break;
                }
            }

            if (!found) {
                // No match found, create new component and insert it in place
                var newComponent = Type.createInstance(wanted.cl, [wanted.data]);
                newComponent.update(wanted.data);
                newComponent._sameLine = wanted.sameLine;
                currentComponents.insert(i, newComponent);
                if (wantedId != null) {
                    usedIds.set(wantedId, true);
                }
                debugLog('Inserted new component: ${Type.getClassName(wanted.cl)} with ID: ${wantedId} at index: $i');
            }
            i++;
        }

        // Remove any components that are no longer wanted
        while (i < currentComponents.length) {
            var comp = currentComponents[i];
            var compId = comp.getId();
            if (compId == null || !usedIds.exists(compId)) {
                currentComponents.splice(i, 1);
                comp.destroy();
                debugLog('Removed component: ${Type.getClassName(Type.getClass(comp))} with ID: ${compId}');
            } else {
                i++;
            }
        }
    }

    // Render the UI
    public static function render(impl: Base, sw: Float, sh: Float) {
        // Update screen bounds
        Layout.updateScreenBounds(sw, sh);

        // Run a diff to see if we need to insert/remove or update components
        updateComponents();

        // Render all components and update input
        var mx = impl.getMouseX();
        var my = impl.getMouseY();

        var hoveredElement: Component = null;

        for (comp in currentComponents) { 

            var parent = containerStack.peek();
            var clipX = parent != null ? parent.clipX : 0;
            var clipY = parent != null ? parent.clipY : 0;
            var clipWidth = parent != null ? parent.clipWidth : Layout.screenW;
            var clipHeight = parent != null ? parent.clipHeight : Layout.screenH;

            if (parent != null) impl.setClipRect(clipX, clipY, clipWidth, clipHeight);
            else impl.resetClipRect();

            Layout.sameLine = comp._sameLine;
            comp.render(impl);

            if (debugDraw) impl.drawRectOutline(comp.boundsX, comp.boundsY, comp.boundsWidth, comp.boundsHeight, 0xff0000, 1);

            if (comp.isInteractable()) {
                var compX = comp.boundsX;
                var compY = comp.boundsY;
                var compW = comp.boundsWidth;
                var compH = comp.boundsHeight;

                if (mx >= compX && mx <= compX + compW && my >= compY && my <= compY + compH && comp.getPriority() > (hoveredElement?.getPriority() ?? -999)) {
                    if (clipX == 0 && clipY == 0 && clipWidth == Layout.screenW && clipHeight == Layout.screenH) {
                        hoveredElement = comp;
                    } else {
                        if (mx >= clipX && mx <= clipX + clipWidth && my >= clipY && my <= clipY + clipHeight) {
                            hoveredElement = comp;
                        }
                    }
                }
                
            }

            comp.postRender();
        }

        // Update hover events
        if (hoveredElement != lastHoveredElement) {
            if (lastHoveredElement != null) lastHoveredElement.onMouseHoverExit(impl);
            if (hoveredElement != null) hoveredElement.onMouseHoverEnter(impl);
            lastHoveredElement = hoveredElement;
        }

        // Update click events
        var down = impl.getLeftMouseDown();

        if (down && previouslyClickedElement == null && hoveredElement != null) {
            hoveredElement.onMouseDown(impl);
            previouslyClickedElement = hoveredElement;
        }

        if (!down && previouslyClickedElement != null) {
            if (hoveredElement == previouslyClickedElement) previouslyClickedElement.onMouseClick(impl);
            previouslyClickedElement.onMouseUp(impl);
            previouslyClickedElement = null;
        }

        // Clear the wanted components list
        currentWantedComponents.resize(0);

        // Reset layout
        Layout.reset();

        // Reset clip rect
        impl.resetClipRect();

        // Reset container stack
        containerStack.clear();
    }

    // Initialize the UI
    public static function init() Layout.reset();

}
