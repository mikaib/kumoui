package kui.demo;

import kui.impl.Base;

class InspectorOverlay extends Component {

    private var currentComponent: Component;

    override function onRender(impl: Base) {
        if (currentComponent == null) return;

        impl.drawRectOutline(currentComponent.getClipX(), currentComponent.getClipY(), currentComponent.getClipWidth(), currentComponent.getClipHeight(), 0xBEC70E, 2);
        impl.drawRectOutline(currentComponent.getBoundsX(), currentComponent.getBoundsY(), currentComponent.getBoundsWidth(), currentComponent.getBoundsHeight(), currentComponent.isVisible() ? 0x0E51C7 : 0xC70E0E, 4);

        var info: Array<String> = [
            'ID: ${currentComponent.getId()}',
            'Type: ${currentComponent.getComponentType()}',
            'Bounds: ${currentComponent.getBoundsX()}, ${currentComponent.getBoundsY()}, ${currentComponent.getBoundsWidth()}, ${currentComponent.getBoundsHeight()}',
            'Clip: ${currentComponent.getClipX()}, ${currentComponent.getClipY()}, ${currentComponent.getClipWidth()}, ${currentComponent.getClipHeight()}',
            'PriorityWeight: ${currentComponent.getPriorityWeight()}',
            'ComputedPriority: ${currentComponent.getComputedPriority()}',
            'Interactable: ${currentComponent.getInteractable()}',
            'Serializable: ${currentComponent.getSerializable()}',
            'Visible: ${currentComponent.isVisible()}',
            'Depth: ${currentComponent.getLastDepth()}'
        ];

        var ty = impl.getMouseX() + Style.GLOBAL_PADDING;
        var tx = impl.getMouseY() + Style.GLOBAL_PADDING;

        var longestLine: Float = 0;
        for (line in info) {
            var w = impl.measureTextWidth(line, 14);
            if (w > longestLine) longestLine = w;
        }

        impl.drawRect(ty, tx, longestLine + Style.GLOBAL_PADDING * 2, info.length * 20 + Style.GLOBAL_PADDING * 2, Style.CONTAINER_BACKGROUND_COLOR, Style.CONTAINER_ROUNDING);
        for (i in 0...info.length) {
            impl.drawText(info[i], ty + Style.GLOBAL_PADDING, tx + Style.GLOBAL_PADDING + i * 20, 0xffffff, 14);
        }

    }

    override function onDataUpdate(data: Dynamic): Dynamic {
        currentComponent = data.component;
        return null;
    }

    override function onLayoutUpdate(impl: Base) {
        useLayoutPosition();
        setSize(0, 0);
        setInteractable(true);
        useScreenClipRect();
        setPriorityWeight(100000000);
        submitLayoutRequest();
    }

}

class InspectorView extends Component {
    private var showAll: Bool = false;
    private var components: Array<Component> = [];
    private var color1 = Style.TABLE_ROW_BACKGROUND_COLOR;
    private var color2 = Style.TABLE_ROW_BACKGROUND_COLOR_ALT;
    private var hovered: Bool = false;

    override function onMouseHoverEnter(impl:Base) {
        hovered = true;
    }

    override function onMouseHoverExit(impl:Base) {
        hovered = false;
    }

    override function onRender(impl: Base) {
        var x = getBoundsX();
        var y = getBoundsY();
        var mx = impl.getMouseX();
        var my = impl.getMouseY();
        var width = getBoundsWidth();
        var itemHeight = 38;
        var padding = Style.GLOBAL_PADDING;
        var hoveredIndex = -1;

        for (i in 0...components.length) {
            var component = components[i];
            var bgColor = (i % 2 == 0) ? color1 : color2;
            var indent = component.getLastDepth() * 15;
            
            impl.drawRect(x + indent, y, width - indent, itemHeight, bgColor, 1);
            impl.drawText('${component.getComponentType()}', x + padding + indent, y + padding / 2, 0xffffff, 14);
            impl.drawText('${component.getBoundsWidth()}x${component.getBoundsHeight()} - (${component.getBoundsX()}, ${component.getBoundsY()}) - ${component.isVisible() ? 'visible' : 'invisibile'}', x + padding + indent, y + padding / 2 + 20, 0xaaaaaa, 12);
            
            if (mx > x && mx < x + width && my > y && my < y + itemHeight) hoveredIndex = i;

            y += itemHeight;
        }

        if (hoveredIndex != -1 && hovered) KumoUI.addComponent(InspectorOverlay, {component: components[hoveredIndex]});
    }

    override function onDataUpdate(data: Dynamic): Dynamic {
        showAll = data.showAll ?? false;
        return null;
    }

    override function onLayoutUpdate(impl: Base) {
        components = showAll ? KumoUI.currentComponents : KumoUI.toRender;

        useLayoutPosition();
        setSize(KumoUI.getInnerWidth(), (components.length + 1) * 38);
        setInteractable(true);
        useBoundsClipRect();
        submitLayoutRequest();
    }
}

/**
 * I'm calling this a demo even though this is a litteral debugging tool.
 * In my defense, alongside being a nice debugging tool it's also a great learning resource.
 */
class Inspector {

    public static var showAll: Bool = false;

    public static function use() {
        KumoUI.beginWindow("Inspector", "kui_inspector");

        showAll = KumoUI.toggle('kui_inspector_showAll', 'Show All', showAll);
        KumoUI.addComponent(InspectorView, { showAll: showAll });

        KumoUI.endWindow();
    }
}
