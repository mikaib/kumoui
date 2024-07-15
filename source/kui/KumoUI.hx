package kui;

import kui.demo.Demo;
import haxe.PosInfos;
import kui.FontType;
import kui.Component;
import kui.impl.Base;
import kui.util.Stack;

class KumoUI {

    public static var containerStack: Stack<Component> = new Stack<Component>();
    public static var currentComponents: Array<Component> = [];
    public static var toRender: Array<Component> = [];
    public static var dataMap: Map<String, Dynamic> = [];
    public static var currentComponentIndex: Int = 0;
    public static var currentWindowIndex: Int = 1;
    public static var focusedWindow: Null<Component> = null;
    private static var impl: Base = null;

    // Input
    public static var lastHovered: Null<Component> = null;
    public static var lastClicked: Null<Component> = null;
    public static var mouseWasDown: Bool = false;

    // Debug draw
    public static var debugDraw: Bool = false;
    public static function setDebugMode(mode: Bool) debugDraw = mode;

    // Add component
    public static function addComponent(comp: Class<Component>, data: Dynamic) : Dynamic {
        var isNew = false;
        if (currentComponents[currentComponentIndex] == null) {
            currentComponents.push(Type.createInstance(comp, []));
            debugLog('Creating new instance at index ${currentComponentIndex} of type ${Type.getClassName(comp)}');
            isNew = true;
        } else if (Type.getClassName(Type.getClass(currentComponents[currentComponentIndex])) != Type.getClassName(comp)) {
            var found = false;
            var id = data?.id;

            if (id != null) {
                for (i in 0...currentComponents.length) {
                    if (currentComponents[i].getId() == id) {
                        var moved = currentComponents.splice(i, 1);
                        currentComponents.insert(currentComponentIndex, moved[0]);
                        found = true;
                        debugLog('Component type mismatch, moving instance from index ${i} to index ${currentComponentIndex} of type ${Type.getClassName(comp)}');
                        break;
                    }
                }
            }

            if (!found) {
                currentComponents.insert(currentComponentIndex, Type.createInstance(comp, []));
                debugLog('Component type mismatch, creating new instance at index ${currentComponentIndex} of type ${Type.getClassName(comp)}');
                isNew = true;
            }
        } else if (currentComponents[currentComponentIndex].getId() != data?.id) {
            if (currentComponents[currentComponentIndex].getId() != null && currentComponents[currentComponentIndex].getSerializable()) {
                var storedData = currentComponents[currentComponentIndex].onSerialize();
                dataMap.set(currentComponents[currentComponentIndex].getId(), storedData);
                debugLog('Serializing data for instance with id ${currentComponents[currentComponentIndex].getId()}, data: ${Std.string(storedData)}');
            }

            currentComponents[currentComponentIndex] = Type.createInstance(comp, []);
            debugLog('Replacing instance at index ${currentComponentIndex} of type ${Type.getClassName(comp)}');
            isNew = true;
        }

        var comp = currentComponents[currentComponentIndex];
        comp.updateComputedPriority();
        comp.setId(data?.id);

        if (comp.getId() != null && isNew) {
            var storedData = dataMap.get(comp.getId());
            if (storedData != null) {
                debugLog('Deserializing data for instance with id ${comp.getId()}, data: ${Std.string(storedData)}');
                comp.onDeserialize(storedData);
            }
        }

        var ret: Dynamic = comp.onDataUpdate(data);
        comp.setDataInteractable(data);
        currentComponentIndex++;

        comp.onLayoutUpdate(impl);
        if (comp.isVisible()) toRender.push(comp);

        return ret;
    }

    // Various elements
    public static inline function showDemo(): Void Demo.use();
    public static inline function separator(?color: Int, ?thickness: Int): Void addComponent(kui.components.Separator, { color: color, thickness: thickness });
    public static inline function toggle(id: String, ?labelText: String, ?value: Bool, ?labelSize: Int, ?labelColor: Int, ?labelType: FontType): Bool return addComponentBool(kui.components.Toggle, { id: id, text: labelText, size: labelSize, color: labelColor, font: labelType, value: value });
    public static inline function sliderFloat(id: String, ?labelText: String, ?min: Float, ?max: Float, ?value: Float, ?labelSize: Int, ?labelColor: Int, ?labelType: FontType, ?width: Float) return addComponentFloat(kui.components.FloatSlider, { id: id, min: min, max: max, width: width, text: labelText, size: labelSize, color: labelColor, font: labelType, value: value });
    public static inline function sliderInt(id: String, ?labelText: String, ?min: Int, ?max: Int, ?value: Int, ?labelSize: Int, ?labelColor: Int, ?labelType: FontType, ?width: Float) return addComponentInt(kui.components.IntSlider, { id: id, min: min, max: max, width: width, text: labelText, size: labelSize, color: labelColor, font: labelType, value: value });
    public static inline function collapse(text: String, ?id: String, ?fontSize: Int, ?fontType: FontType): Bool return addComponentBool(kui.components.Collapse, { text: text, size: fontSize, font: fontType, id: id ?? text });
    public static inline function sameLine(): Void Layout.beginSameLine();
    public static inline function text(text: String, ?color: Int, ?fontSize: Int, ?fontType: FontType): Void addComponent(kui.components.Text, { text: text, color: color, size: fontSize, font: fontType });
    public static inline function button(text: String, ?fontSize: Int, ?fontType: FontType, ?fullWidth: Bool): Bool return addComponentBool(kui.components.Button, { text: text, size: fontSize, font: fontType, fullWidth: fullWidth });
    public static inline function beginTreeNode(text: String, ?id: String, ?fontSize: Int, ?fontType: FontType): Bool return addComponentBool(kui.components.TreeCollapse, { text: text, size: fontSize, font: fontType, id: id ?? text });
    public static inline function endTreeNode(): Void addComponent(kui.components.TreeCollapseEnd, null);
    public static inline function graph(points: Array<Float>, width: Float, height: Float, ?labelText: String, ?labelSize: Int, ?labelType: FontType): Void addComponent(kui.components.Graph, { points: points, width: width, height: height, text: labelText, size: labelSize, font: labelType });
    public static inline function multiGraph(pointArrays: Array<{ points: Array<Float>, ?label: String, ?color: Int }>, ?width: Float, ?height: Float): Void addComponent(kui.components.MultiGraph, { pointArrays: pointArrays, width: width, height: height });
    public static inline function inputText(id: String, ?labelText: String, ?placeholderText: String, ?value: String, ?labelSize: Int, ?labelColor: Int, ?labelType: FontType, ?width: Float): String return addComponentString(kui.components.GenericInput, { id: id, label: labelText, placeholder: placeholderText, value: value, labelSize: labelSize, labelColor: labelColor, labelFont: labelType, width: width });
    public static inline function inputInt(id: String, ?labelText: String, ?placeholderText: String, ?min: Int, ?max: Null<Int>, ?value: Null<Int>, ?labelSize: Int, ?labelColor: Int, ?labelType: FontType, ?width: Float): Int return addComponentInt(kui.components.IntInput, { id: id, label: labelText, placeholder: placeholderText, min: min, max: max, value: value, labelSize: labelSize, labelColor: labelColor, labelFont: labelType, width: width });
    public static inline function inputFloat(id: String, ?labelText: String, ?placeholderText: String, ?min: Null<Float>, ?max: Null<Float>, ?value: Float, ?labelSize: Int, ?labelColor: Int, ?labelType: FontType, ?width: Float): Float return addComponentFloat(kui.components.FloatInput, { id: id, label: labelText, placeholder: placeholderText, min: min, max: max, value: value, labelSize: labelSize, labelColor: labelColor, labelFont: labelType, width: width });
    public static inline function table(data: TableData, ?rowHeight: Int, ?headerHeight: Int): Void addComponent(kui.components.DataTable, { tableData: data, rowHeight: rowHeight, headerHeight: headerHeight });
    public static inline function beginContainer(?height: Float, ?width: Float, ?bgColor: Int): Void {
        addComponent(kui.components.Container, { containerHeight: height, containerWidth: width, backgroundColor: bgColor });
        addComponent(kui.components.ScrollableContainer, { scrollHeightOffset: 0, id: 'scrollable.container${currentComponentIndex}' });
    }
    public static inline function beginWindow(title: String, id: String, ?x: Float, ?y: Float, ?width: Float, ?height: Float): Void {
        addComponent(kui.components.Window, { title: title, x: x, y: y, width: width, height: height, id: id});
        addComponent(kui.components.ScrollableContainer, { scrollHeightOffset: Style.WINDOW_RESIZE_SIZE, id: 'scrollable.${id}' });
        currentWindowIndex++;
    }
    public static inline function endWindow(): Void { 
        addComponent(kui.components.ScrollableContainerEnd, null);
        Layout.endParentContainer();
    }
    public static inline function endContainer(): Void { 
        addComponent(kui.components.ScrollableContainerEnd, null);
        Layout.endParentContainer();
    }

    // Variations of addComponent
    public static inline function addComponentInt(comp: Class<Component>, data: Dynamic): Int return addComponent(comp, data) ?? 0;
    public static inline function addComponentFloat(comp: Class<Component>, data: Dynamic): Float return addComponent(comp, data) ?? 0.0;
    public static inline function addComponentBool(comp: Class<Component>, data: Dynamic): Bool return addComponent(comp, data) ?? false;
    public static inline function addComponentString(comp: Class<Component>, data: Dynamic): String return addComponent(comp, data) ?? '';

    // Parent container stuff
    public static inline function getParent(): Component return containerStack.peek();
    public static inline function hasParent(): Bool return !containerStack.isEmpty();
    public static inline function getParentX(): Float return containerStack.peek()?.getBoundsX() ?? 0;
    public static inline function getParentY(): Float return containerStack.peek()?.getBoundsY() ?? 0;
    public static inline function getParentWidth(): Float return containerStack.peek()?.getBoundsWidth() ?? Layout.getScreenWidth();
    public static inline function getParentHeight(): Float return containerStack.peek()?.getBoundsHeight() ?? Layout.getScreenHeight();
    public static inline function getWindowPriorityWeight(comp: Component): Int return comp == focusedWindow ? 1000000 : currentWindowIndex * 1000;
    public static inline function getInnerWidth(): Float return KumoUI.getParentWidth() - Style.GLOBAL_PADDING;
    public static inline function getInnerHeight(): Float return KumoUI.getParentHeight() - Style.GLOBAL_PADDING;

    // Debug log
    public static inline function debugLog(m: Dynamic, ?posInfo: PosInfos) return; //Sys.println('[kui debug] (${posInfo.fileName}:${posInfo.lineNumber}) in ${posInfo.className}.${posInfo.methodName}: ${Std.string(m)}');

    // Input utility functions
    public static function getHoveredComponentOfType(impl: Base, cls: Class<Dynamic>, mustBeInteractable: Bool = true): Null<Component> {
        var mx = impl.getMouseX();
        var my = impl.getMouseY();
        var priority = -1;
        var current = null;
        for (i in currentComponents) {
            if (i.pointInside(mx, my) && Type.getClass(i) == cls && i.getComputedPriority() > priority) {
                if (mustBeInteractable && !i.getInteractable()) continue;
                priority = i.getComputedPriority();
                current = i;
            }
        }
        return current;
    }

    public static function getHoveredComponentAny(impl: Base, mustBeInteractable: Bool = true): Null<Component> {
        var mx = impl.getMouseX();
        var my = impl.getMouseY();
        var priority = -1;
        var current = null;
        for (i in currentComponents) {
            if (i.pointInside(mx, my) && i.getComputedPriority() > priority) {
                if (mustBeInteractable && !i.getInteractable()) continue;
                priority = i.getComputedPriority();
                current = i;
            }
        }
        return current;
    }

    // Render
    public static function render() {
        // Render components
        toRender.sort(function(a, b) return a.getComputedPriority() - b.getComputedPriority());
        for (comp in toRender) {
            comp.applyClipToImpl(impl);
            comp.onRender(impl);
        }

        // Scroll container
        var scrollable = getHoveredComponentOfType(impl, kui.components.ScrollableContainer, false);
        if (scrollable != null) {
            var scrollDelta = impl.getScrollDelta();   
            try { cast (scrollable, kui.components.ScrollableContainer).scroll(scrollDelta);
            } catch(e) trace('Error casting to ScrollableContainer, this should not be able to happen?');
        }

        // Reset clip area
        impl.resetClipRect();

        // Check if debug draw is enabled, if so, we draw debugging information
        if (debugDraw) drawDebuggingInformation(impl);

		// Handle input
		var currentlyHovered = getHoveredComponentAny(impl);
		if (currentlyHovered != lastHovered) {
			if (lastHovered != null) lastHovered.onMouseHoverExit(impl);
			if (currentlyHovered != null) currentlyHovered.onMouseHoverEnter(impl);
			lastHovered = currentlyHovered;
		}

		if (impl.getLeftMouseDown()) {
            // down event
			if (mouseWasDown) return;
            if (currentlyHovered != lastClicked && lastClicked != null) {
                lastClicked.onMouseClickOutside(impl);
                lastClicked = null;
            }

            if (currentlyHovered != null) {
                currentlyHovered.onMouseDown(impl);
                lastClicked = currentlyHovered;
            } else {
                lastClicked = null;
            }

            // window focus
            var window = getHoveredComponentOfType(impl, kui.components.Window, false);
            if (window != null) focusedWindow = window;

            mouseWasDown = true;
		} else {
			if (!mouseWasDown) return;
            if (lastClicked != null) {
                lastClicked.onMouseUp(impl);
                if (lastClicked.pointInside(impl.getMouseX(), impl.getMouseY())) lastClicked.onMouseClick(impl);
            }
            mouseWasDown = false;
		}
    }

    // Reset
    public static function begin(width: Float, height: Float) {
        // Reset layout
        Layout.reset(width, height);

        // Destroy unnecessary instances
        if (currentComponentIndex < currentComponents.length) {
            debugLog('Destroying instances from index ${currentComponentIndex} to ${currentComponents.length - 1}');
            var toRemove = currentComponents.splice(currentComponentIndex, currentComponents.length - currentComponentIndex);
            for (item in toRemove) {
                debugLog('Destroying instance of type ${Type.getClassName(Type.getClass(item))}');
                if (item.getId() != null && item.getSerializable()) {
                    var data = item.onSerialize();
                    dataMap.set(item.getId(), data);
                    debugLog('Serializing data for instance with id ${item.getId()}, data: ${Std.string(data)}');
                }
                item.destroy(impl);
            }
        }

        // Clear container stack
        containerStack.clear();

        // Reset indices
        currentComponentIndex = 0;
        currentWindowIndex = 1;

        // Update component layout
        toRender.resize(0);

        // Reset input
        KeyboardInput.beginFrame();
    }

    // Debugging information
    public static function drawDebuggingInformation(impl: Base) {
        for (comp in currentComponents) comp.onDebugDraw(impl);
    }

    // Init
    public static function init(backend: Base, debugDraw: Bool = false) {
        KumoUI.impl = backend;
        KumoUI.debugDraw = debugDraw;
    }
    
}