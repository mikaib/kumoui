package kui;

import kui.demo.Demo;
import haxe.PosInfos;
import kui.FontType;
import kui.Component;
import kui.impl.Base;
import kui.util.Stack;

class KumoUI {

    // Parent container stuff
    public static var containerStack: Stack<Component> = new Stack<Component>();

    // Current frame components
    public static var currentComponentIndex: Int = 0;
    public static var currentComponents: Array<Component> = [];
    public static var toRender: Array<Component> = [];

    // Persistent data
    public static var dataMap: Map<String, Dynamic> = [];

    // window stuff
    public static var currentWindowIndex: Int = 1;
    public static var focusedWindow: Null<Component> = null;

    // backend
    private static var impl: Base = null;

    // Input
    public static var lastHovered: Null<Component> = null;
    public static var lastClicked: Null<Component> = null;
    public static var mouseWasDown: Bool = false;

    // Debug draw
    public static var debugDraw: Bool = false;

    /**
     * Set debug mode
     * @param mode Debug mode
     */
    public static function setDebugMode(mode: Bool) {
        debugDraw = mode;
    }

    /**
     * Add a component to the current frame, it will re-use existing instances if possible
     * @param comp The class of the component
     * @param data The data to pass to the component
     * @return the data that the component returns in the onDataUpdate method
     */
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
    /**
     * The main demo function, this will show the demo window which contains (most) available components and a few demo applications
     */
    public static inline function showDemo(): Void {
        Demo.use();
    }

    /**
     * A horizontal separator
     * @param color The color of the separator
     * @param thickness The thickness of the separator
     */
    public static inline function separator(?color: Int, ?thickness: Int): Void {
        addComponent(kui.components.Separator, { color: color, thickness: thickness });
    }

    /**
     * A Toggle component
     * @param id The id of the component
     * @param labelText The text of the label
     * @param value The value of the toggle
     * @param labelSize The size of the label
     * @param labelColor The color of the label
     * @param labelType The font type of the label
     * @return Bool The value of the toggle
     */
    public static inline function toggle(id: String, ?labelText: String, ?value: Bool, ?labelSize: Int, ?labelColor: Int, ?labelType: FontType): Bool {
        return addComponentBool(kui.components.Toggle, { id: id, text: labelText, size: labelSize, color: labelColor, font: labelType, value: value });
    }

    /**
     * A slider component that returns floats
     * @param id The id of the component
     * @param labelText The text of the label
     * @param min The minimum value of the slider
     * @param max The maximum value of the slider
     * @param value The value of the slider
     * @param labelSize The size of the label
     * @param labelColor The color of the label
     * @param labelType The font type of the label
     * @param width The width of the slider
     */
    public static inline function sliderFloat(id: String, ?labelText: String, ?min: Float, ?max: Float, ?value: Float, ?labelSize: Int, ?labelColor: Int, ?labelType: FontType, ?width: Float) {
        return addComponentFloat(kui.components.FloatSlider, { id: id, min: min, max: max, width: width, text: labelText, size: labelSize, color: labelColor, font: labelType, value: value });
    }

    /**
     * A slider component that returns integers
     * @param id The id of the component
     * @param labelText The text of the label
     * @param min The minimum value of the slider
     * @param max The maximum value of the slider
     * @param value The value of the slider
     * @param labelSize The size of the label
     * @param labelColor The color of the label
     * @param labelType The font type of the label
     * @param width The width of the slider
     */
    public static inline function sliderInt(id: String, ?labelText: String, ?min: Int, ?max: Int, ?value: Int, ?labelSize: Int, ?labelColor: Int, ?labelType: FontType, ?width: Float) {
        return addComponentInt(kui.components.IntSlider, { id: id, min: min, max: max, width: width, text: labelText, size: labelSize, color: labelColor, font: labelType, value: value });
    }

    /**
     * The collapse component
     * @param text The text of the collapse component
     * @param id The id of the collapse component
     * @param fontSize The size of the font
     * @param fontType The font type
     * @return Bool The value of the collapse component
     */
    public static inline function collapse(text: String, ?id: String, ?fontSize: Int, ?fontType: FontType): Bool {
        return addComponentBool(kui.components.Collapse, { text: text, size: fontSize, font: fontType, id: id ?? text });
    }

    /**
     * Same line component, will put the next component on the same line as the previous one
     */
    public static inline function sameLine(): Void {
        Layout.beginSameLine();
    }

    /**
     * The text component
     * @param text The text of the component
     * @param color The color of the text
     * @param fontSize The size of the font (note, altering this value may make text blurry on some backends if the backend uses bitmap fonts)
     * @param fontType The font type
     */
    public static inline function text(text: String, ?color: Int, ?fontSize: Int, ?fontType: FontType): Void {
        addComponent(kui.components.Text, { text: text, color: color, size: fontSize, font: fontType });
    }

    /**
     * The button component
     * @param text The text of the button
     * @param fontSize The size of the font
     * @param fontType The font type
     * @param width The width of the button
     * @return Bool Whether the button was clicked the current frame
     */
    public static inline function button(text: String, ?fontSize: Int, ?fontType: FontType, ?width: Float): Bool {
        return addComponentBool(kui.components.Button, { text: text, size: fontSize, font: fontType, width: width });
    }

    /**
     * Begin a tree node  
     * __NOTE:__ endTreeNode must ALWAYS be called, even if not expanded.   
     * ```hx
     * if (KumoUI.beginTreeNode('Node')) {
     *    // ... your content here ...
     * }
     * KumoUI.endTreeNode();
     * ```
     * @param text The text of the tree node
     * @param id The id of the tree node
     * @param fontSize The size of the font
     * @param fontType The font type
     * @return If the note is expanded or not
     */
    public static inline function beginTreeNode(text: String, ?id: String, ?fontSize: Int, ?fontType: FontType): Bool {
        return addComponentBool(kui.components.TreeCollapse, { text: text, size: fontSize, font: fontType, id: id ?? text });
    }

    /**
     * End a tree node
     */
    public static inline function endTreeNode(): Void {
        addComponent(kui.components.TreeCollapseEnd, null);
    }

    /**
     * Draws a simple graph
     * @param points Array of points to draw
     * @param width The width of the graph
     * @param height The height of the graph
     * @param labelText The text of the label
     * @param labelSize The size of the label
     * @param labelType The font type of the label
     */
    public static inline function graph(points: Array<Float>, width: Float, height: Float, ?labelText: String, ?labelSize: Int, ?labelType: FontType): Void {
        addComponent(kui.components.Graph, { points: points, width: width, height: height, text: labelText, size: labelSize, font: labelType });
    }

    /**
     * Draws a multi graph
     * @param pointArrays Collection of point arrays, colors and labels to draw
     * @param width The width of the graph
     * @param height The height of the graph
     */
    public static inline function multiGraph(pointArrays: Array<{ points: Array<Float>, ?label: String, ?color: Int }>, ?width: Float, ?height: Float): Void {
        addComponent(kui.components.MultiGraph, { pointArrays: pointArrays, width: width, height: height });
    }

    /**
     * The input text component
     * @param id The id of the component
     * @param labelText The text of the label
     * @param placeholderText The placeholder text
     * @param value The value of the input
     * @param labelSize The size of the label
     * @param labelColor The color of the label
     * @param labelType The font type of the label
     * @param width The width of the input
     * @return String The value of the input
     */
    public static inline function inputText(id: String, ?labelText: String, ?placeholderText: String, ?value: String, ?labelSize: Int, ?labelColor: Int, ?labelType: FontType, ?width: Float): String {
        return addComponentString(kui.components.GenericInput, { id: id, label: labelText, placeholder: placeholderText, value: value, labelSize: labelSize, labelColor: labelColor, labelFont: labelType, width: width });
    }

    /**
     * The integer input component, allows you to enter any valid integer.
     * @param id The id of the component
     * @param labelText The text of the label 
     * @param placeholderText The placeholder text 
     * @param min The minimum value
     * @param max The maximum value
     * @param value The value
     * @param labelSize The size of the label
     * @param labelColor The color of the label
     * @param labelType The font type of the label
     * @param width The width of the input
     * @return The value of the input
     */
    public static inline function inputInt(id: String, ?labelText: String, ?placeholderText: String, ?min: Int, ?max: Null<Int>, ?value: Null<Int>, ?labelSize: Int, ?labelColor: Int, ?labelType: FontType, ?width: Float): Int {
        return addComponentInt(kui.components.IntInput, { id: id, label: labelText, placeholder: placeholderText, min: min, max: max, value: value, labelSize: labelSize, labelColor: labelColor, labelFont: labelType, width: width });
    }

    /**
     * The float input component, allows you to enter any valid float.
     * @param id The id of the component
     * @param labelText The text of the label 
     * @param placeholderText The placeholder text 
     * @param min The minimum value
     * @param max The maximum value
     * @param value The value
     * @param labelSize The size of the label
     * @param labelColor The color of the label
     * @param labelType The font type of the label
     * @param width The width of the input
     * @return The value of the input
     */
    public static inline function inputFloat(id: String, ?labelText: String, ?placeholderText: String, ?min: Null<Float>, ?max: Null<Float>, ?value: Float, ?labelSize: Int, ?labelColor: Int, ?labelType: FontType, ?width: Float): Float {
        return addComponentFloat(kui.components.FloatInput, { id: id, label: labelText, placeholder: placeholderText, min: min, max: max, value: value, labelSize: labelSize, labelColor: labelColor, labelFont: labelType, width: width });
    }

    /**
     * The datatable component
     * @param data Instance of TableData class which handles the data
     * @param rowHeight The height of a single row
     * @param headerHeight The height of the header
     */
    public static inline function table(data: TableData, ?rowHeight: Int, ?headerHeight: Int): Void {
        addComponent(kui.components.DataTable, { tableData: data, rowHeight: rowHeight, headerHeight: headerHeight });
    }

    /**
     * Begin a simple container which allows you to add "depth" to your UI
     * @param height The height
     * @param width The width
     * @param bgColor The background color
     */
    public static inline function beginContainer(?height: Float, ?width: Float, ?bgColor: Int): Void {
        addComponent(kui.components.Container, { containerHeight: height, containerWidth: width, backgroundColor: bgColor });
        addComponent(kui.components.ScrollableContainer, { scrollHeightOffset: 0, id: 'scrollable.container${currentComponentIndex}' });
    }

    /**
     * Begin a window
     * @param title The title of the window
     * @param id The id of the window
     * @param x The forced x position
     * @param y The forced y position
     * @param width The forced width
     * @param height The forced height
     */
    public static inline function beginWindow(title: String, id: String, ?x: Float, ?y: Float, ?width: Float, ?height: Float): Void {
        addComponent(kui.components.Window, { title: title, x: x, y: y, width: width, height: height, id: id});
        addComponent(kui.components.ScrollableContainer, { scrollHeightOffset: Style.WINDOW_RESIZE_SIZE, id: 'scrollable.${id}' });
        currentWindowIndex++;
    }

    /**
     * End a window
     */
    public static inline function endWindow(): Void { 
        addComponent(kui.components.ScrollableContainerEnd, null);
        Layout.endParentContainer();
    }

    /**
     * End a container
     */
    public static inline function endContainer(): Void { 
        addComponent(kui.components.ScrollableContainerEnd, null);
        Layout.endParentContainer();
    }

    // Variations of addComponent
    /**
     * Add a component to the current frame, it will re-use existing instances if possible.  
     * This version will automatically "cast" dynamic to Int, which allows users to have nicer typing
     * @param comp The class of the component
     * @param data The data to pass to the component
     * @return the data that the component returns in the onDataUpdate method
     */
    public static inline function addComponentInt(comp: Class<Component>, data: Dynamic): Int {
        return addComponent(comp, data) ?? 0;
    }
    
    /**
     * Add a component to the current frame, it will re-use existing instances if possible.  
     * This version will automatically "cast" dynamic to Float, which allows users to have nicer typing
     * @param comp The class of the component
     * @param data The data to pass to the component
     * @return the data that the component returns in the onDataUpdate method
     */
    public static inline function addComponentFloat(comp: Class<Component>, data: Dynamic): Float {
        return addComponent(comp, data) ?? 0.0;
    }

    /**
     * Add a component to the current frame, it will re-use existing instances if possible.  
     * This version will automatically "cast" dynamic to Bool, which allows users to have nicer typing
     * @param comp The class of the component
     * @param data The data to pass to the component
     * @return the data that the component returns in the onDataUpdate method
     */
    public static inline function addComponentBool(comp: Class<Component>, data: Dynamic): Bool {
        return addComponent(comp, data) ?? false;
    }

    /**
     * Add a component to the current frame, it will re-use existing instances if possible.  
     * This version will automatically "cast" dynamic to String, which allows users to have nicer typing
     * @param comp The class of the component
     * @param data The data to pass to the component
     * @return the data that the component returns in the onDataUpdate method
     */
    public static inline function addComponentString(comp: Class<Component>, data: Dynamic): String {
        return addComponent(comp, data) ?? '';
    }

    // Parent container stuff
    /**
     * Get the parent container
     * @return The parent container
     */
    public static inline function getParent(): Component {
        return containerStack.peek();
    }

    /**
     * Check if the current container has a parent
     * @return If the current container has a parent
     */
    public static inline function hasParent(): Bool {
        return !containerStack.isEmpty();
    }

    /**
     * Get the parent x position
     * @return The parent x position
     */
    public static inline function getParentX(): Float {
        return containerStack.peek()?.getBoundsX() ?? 0;
    }

    /**
     * Get the parent y position
     * @return The parent y position
     */
    public static inline function getParentY(): Float {
        return containerStack.peek()?.getBoundsY() ?? 0;
    }

    /**
     * Get the parent width
     * @return The parent width
     */
    public static inline function getParentWidth(): Float {
        return containerStack.peek()?.getBoundsWidth() ?? Layout.getScreenWidth();
    }

    /**
     * Get the parent height
     * @return The parent height
     */
    public static inline function getParentHeight(): Float {
        return containerStack.peek()?.getBoundsHeight() ?? Layout.getScreenHeight();
    }

    /**
     * Get the weight that a window should have.
     * @param comp The window component to get the weight for
     * @return The weight of the window
     */
    public static inline function getWindowPriorityWeight(comp: Component): Int {
        return comp == focusedWindow ? 1000000 : currentWindowIndex * 1000;
    }

    /**
     * Get the inner width of the parent container
     * @return The inner width of the parent container
     */
    public static inline function getInnerWidth(): Float {
        return KumoUI.getParentWidth() - Style.GLOBAL_PADDING;
    }

    /**
     * Get the inner height of the parent container
     * @return The inner height of the parent container
     */
    public static inline function getInnerHeight(): Float {
        return KumoUI.getParentHeight() - Style.GLOBAL_PADDING;
    }

    // Debug log
    /**
     * Debug log
     * @param m The message to log
     * @param posInfo The position information (no need to pass this, it will be automatically be done by the compiler)
     */
    public static inline function debugLog(m: Dynamic, ?posInfo: PosInfos) {
        return; //Sys.println('[kui debug] (${posInfo.fileName}:${posInfo.lineNumber}) in ${posInfo.className}.${posInfo.methodName}: ${Std.string(m)}');
    }

    // Input utility functions
    /**
     * Get the hovered component of a specific type
     * @param impl The backend
     * @param cls The class of the component
     * @param mustBeInteractable If you want to filter out non-interactable components
     * @return The hovered component (null if none)
     */
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

    /**
     * Get the hovered component of any type
     * @param impl The backend
     * @param mustBeInteractable If you want to filter out non-interactable components
     * @return The hovered component (null if none)
     */
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
    /**
     * Render the current frame
     */
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
    /**
     * Begin the current frame
     * @param width The width of the window
     * @param height The height of the window
     */
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
    /**
     * Draw debugging information
     * @param impl The backend
     */
    public static function drawDebuggingInformation(impl: Base) {
        for (comp in currentComponents) comp.onDebugDraw(impl);
    }

    // Init
    /**
     * Initialize KumoUI
     * @param backend The backend to use
     * @param debugDraw If debug draw should be enabled
     */
    public static function init(backend: Base, debugDraw: Bool = false) {
        KumoUI.impl = backend;
        KumoUI.debugDraw = debugDraw;
    }
    
}