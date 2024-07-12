package kui.components;

import kui.impl.Base;

class TreeCollapseEnd extends Component {

    override function onLayoutUpdate(impl: Base) {
        try {
            var nextPos = Layout.getNextPosition();
            var c = cast (endParentContainer(), TreeCollapse);
            c.innerContentHeight = nextPos.y - c.getBoundsY() - c.getBoundsHeight() - Style.GLOBAL_PADDING;
            Layout.addVerticalSpacing(c.expanded ? c.innerContentHeight : 0);
        } catch(e) KumoUI.debugLog('Could not cast "Component" to "TreeCollapse" in TreeCollapseEnd, did you mismatch endContainer calls?');
    }

}