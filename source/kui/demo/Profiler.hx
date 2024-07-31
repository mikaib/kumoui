package kui.demo;

import kui.util.ProfilerTimer;

/**
 * I'm calling this a demo even though this is a litteral debugging tool.
 * In my defense, alongside being a nice debugging tool it's also a great learning resource.
 */
class Profiler {

    public static var lastTime: Float = 0.0;
    public static var historicalTimes: Array<Float> = [ for (i in 0...480) 0.0 ];
    public static var componentGraphs: Array<{ points: Array<Float>, label: String, color: Int }> = [
        { points: [ for (i in 0...480) 0.0 ], label: "Total Components", color: 0xff0000 },
        { points: [ for (i in 0...480) 0.0 ], label: "Rendered Components", color: 0x00ff00 }
    ];

    public static var dataLayoutTimes: TableData = new TableData(["Component", "Time"], []);
    public static var dataRenderTimes: TableData = new TableData(["Component", "Time"], []);

    public static function update() {
        var currTime = ProfilerTimer.getTime();
        if (currTime - lastTime < 0.05) return;

        lastTime = currTime;

        historicalTimes.shift();
        historicalTimes.push(KumoUI.lastFrameTime * 1000);

        componentGraphs[0].points.shift();
        componentGraphs[0].points.push(KumoUI.currentComponents.length);

        componentGraphs[1].points.shift();
        componentGraphs[1].points.push(KumoUI.toRender.length);

        var dataLayout = dataLayoutTimes.data;
        dataLayout.resize(0);
        for (layout in KumoUI.componentLayoutTimes.keys()) {
            dataLayout.push([layout, toFixed(KumoUI.componentLayoutTimes.get(layout) * 1000, 2) + 'ms']);
        }

        var dataRender = dataRenderTimes.data;
        dataRender.resize(0);
        for (render in KumoUI.componentRenderTimes.keys()) {
            dataRender.push([render, toFixed(KumoUI.componentRenderTimes.get(render) * 1000, 2) + 'ms']);
        }
  
    }

    public static function toFixed(value: Float, digits: Int): String {
        var str = Std.string(value);
        var dotIndex = str.indexOf('.');
        if (dotIndex == -1) return str;
        return str.substring(0, dotIndex + digits + 1);
    }

    public static function use() {
        KumoUI.beginWindow("Profiler", "kui_profiler");

        update();
        KumoUI.graph(historicalTimes, KumoUI.getInnerWidth(), 100, "Render Times (ms)");
        KumoUI.multiGraph(componentGraphs, KumoUI.getInnerWidth(), 100);

        if (KumoUI.collapse("Layout Times")) {
            KumoUI.table(dataLayoutTimes, 32, 32);
        }

        if (KumoUI.collapse("Render Times")) {
            KumoUI.table(dataRenderTimes, 32, 32);
        }

        KumoUI.endWindow();
    }

}