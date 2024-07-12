package kui.components;

import kui.impl.Base;

class ScrollableContainerEnd extends Component {

    override function onLayoutUpdate(impl: Base) {
        try {
            var posEnd = Layout.getNextPosition();
            var c = cast (endParentContainer(), ScrollableContainer);

            c.innerContentEndY = posEnd.y;
            c.innerContentHeight = c.innerContentEndY - c.innerContentStartY;
            c.setClipRect(c.getBoundsX(), c.getBoundsY(), c.fullWidth, c.getBoundsHeight());
        } catch(e) KumoUI.debugLog('Could not cast "Component" to "ScrollableContainer" in ScrollableContainerEnd, did you mismatch endContainer calls?');
    }

}