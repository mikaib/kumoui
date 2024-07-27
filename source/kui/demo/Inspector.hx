package kui.demo;

import kui.impl.Base;

class InspectorView extends Component {

    private var components: Array<Component>;
    
    override function onRender(impl: Base) {
        var x = getBoundsX();
        var y = getBoundsY();
        for (component in components) {
            impl.drawText(component.getComponentType(), x, y, 0xffffff);
            y += 20;
        }
    }

    override function onDataUpdate(data: Dynamic): Dynamic {
       return null;
    }

    override function onLayoutUpdate(impl: Base) {
        components = KumoUI.currentComponents;

        useLayoutPosition();
        setSize(KumoUI.getInnerWidth(), components.length * 20);
        useBoundsClipRect();
        submitLayoutRequest();
    }
}

/**
 * I'm calling this a demo even though this is a litteral debugging tool.
 * In my defense, alongside being a nice debugging tool it's also a great learning resource.
 */
class Inspector {

    public static function use() {
        KumoUI.beginWindow("Inspector", "kui_inspector");
        KumoUI.addComponent(InspectorView, null);
        KumoUI.endWindow();
    }

}