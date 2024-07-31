package kui.demo;

import kui.util.ProfilerTimer;

class Demo {

    public static var float_slider_value: Float = 0.0;
    public static var int_slider_value: Int = 0;
    public static var toggle_value: Bool = false;

    public static final points_n: Int = 1000;

    public static var points_sin: Array<Float> = [for (i in 0...points_n) Math.sin(i / 100.0 * Math.PI * 4)];
    public static var points_cos: Array<Float> = [for (i in 0...points_n) Math.cos(i / 100.0 * Math.PI * 4)];
    public static var points_tan: Array<Float> = [for (i in 0...points_n) Math.tan(i / 100.0 * Math.PI * 4)];
    public static var points_mod: Array<Float> = [for (i in 0...points_n) i % 100];
    public static var moving_points_square: Array<Float> = [for (i in 0...points_n) if (i % 100 > 50) 1 else -1];
    public static var moving_points_square_count: Int = 0;

    // Demo apps
    public static var demo_calc: Bool = false;

    // Dev tools
    public static var dev_inspector: Bool = false;
    public static var dev_profiler: Bool = false;

    public static function use() {
        KumoUI.beginWindow('Demo', 'demo_window');

        KumoUI.text('KumoUI', 0xff00ea, 48, BOLD);
        KumoUI.text('Check out this demo to get started!', 0x00afe4);
        KumoUI.text('All of the code for this demo is available in Demo.hx in source/kui', 0x00afe4);

        if (KumoUI.collapse('Demo Applications')) {
            demo_calc = KumoUI.toggle('demo_calc', 'Graphing Calculator');
        }

        if (KumoUI.collapse('Development Tools')) {
            dev_inspector = KumoUI.toggle('dev_inspector', 'Inspector');
            dev_profiler = KumoUI.toggle('dev_profiler', 'Profiler');
        }

        KumoUI.separator();

        // ---------------------------------
        // Text
        // ---------------------------------
        if (KumoUI.collapse('Text')) {
            KumoUI.text('Default text');
            KumoUI.text('Coloured text', 0xff0000);
            KumoUI.text('Bold text', null, null, BOLD);

            KumoUI.text('Big text', null, 32);
            KumoUI.text('Big coloured text', 0x00ff00, 32);
            KumoUI.text('Big bold text', null, 32, BOLD);
            KumoUI.text('Big bold coloured text', 0xffff00, 32, BOLD);

            KumoUI.text('Small text', null, 10);
            KumoUI.text('Small coloured text', 0x0ff0ff, 10);
            KumoUI.text('Small bold text', null, 10, BOLD);
            KumoUI.text('Small bold coloured text', 0x00ff00, 10, BOLD);
        }

        // ---------------------------------
        // Tree view
        // ---------------------------------
        if (KumoUI.collapse("Tree View")) {
            if (KumoUI.beginTreeNode("1")) {
                KumoUI.text("Some text content!");
                KumoUI.button("And a button :D");
            }
            KumoUI.endTreeNode();

            if (KumoUI.beginTreeNode("2")) {
                if (KumoUI.beginTreeNode("2.1")) {
                    KumoUI.text("This is text for 2.1");
                }
                KumoUI.endTreeNode();

                if (KumoUI.beginTreeNode("2.2")) {
                    KumoUI.text("This is text for 2.2");
                }
                KumoUI.endTreeNode();

                if (KumoUI.beginTreeNode("2.3")) {
                    KumoUI.text("This is text for 2.3");
                }
                KumoUI.endTreeNode();
            }
            KumoUI.endTreeNode();

            if (KumoUI.beginTreeNode("3")) {
                if (KumoUI.beginTreeNode("3.1")) {
                    if (KumoUI.beginTreeNode("3.1.1")) {
                        KumoUI.text("This is text for 3.1.1");
                    }
                    KumoUI.endTreeNode();

                    if (KumoUI.beginTreeNode("3.1.2")) {
                        KumoUI.text("This is text for 3.1.2");
                    }
                    KumoUI.endTreeNode();
                }
                KumoUI.endTreeNode();

                if (KumoUI.beginTreeNode("3.2")) {
                    if (KumoUI.beginTreeNode("3.2.1")) {
                        KumoUI.text("This is text for 3.2.1");
                    }
                    KumoUI.endTreeNode();

                    if (KumoUI.beginTreeNode("3.2.2")) {
                        KumoUI.text("This is text for 3.2.2");
                    }
                    KumoUI.endTreeNode();
                }
                KumoUI.endTreeNode();

            }
            KumoUI.endTreeNode();

        }

        // ---------------------------------
        // Buttons
        // ---------------------------------
        if (KumoUI.collapse("Buttons")) {
            KumoUI.button("Simple Button");

            KumoUI.button("Button row (1/3)");
            KumoUI.sameLine();
            KumoUI.button("Button row (2/3)");
            KumoUI.sameLine();
            KumoUI.button("Button row (3/3)");

            KumoUI.button("Full width button", null, null, KumoUI.getInnerWidth());

            KumoUI.button("Non-bold button", null, REGULAR, KumoUI.getInnerWidth());
            KumoUI.button("BIG BUTTON", 48, BOLD, KumoUI.getInnerWidth());
        }

        // ---------------------------------
        // Toggles
        // ---------------------------------
        if (KumoUI.collapse("Toggles")) {
            toggle_value = KumoUI.toggle("my_toggle", null, toggle_value);
            toggle_value = KumoUI.toggle("my_toggle2", "Labelled toggle", toggle_value);
            toggle_value = KumoUI.toggle("my_toggle3", "Labelled toggle with color", toggle_value, null, 0xff0000);
            toggle_value = KumoUI.toggle("my_toggle4", "Labelled toggle with big label", toggle_value, 24);
            toggle_value = KumoUI.toggle("my_toggle5", "Labelled toggle with bold label", toggle_value, null, null, BOLD);
        }

        // ---------------------------------
        // Sliders
        // ---------------------------------
        if (KumoUI.collapse("Sliders")) {
            KumoUI.text('Float Sliders: $float_slider_value', null, 24, BOLD);
            float_slider_value = KumoUI.sliderFloat("my_slider", null, null, null, float_slider_value);
            float_slider_value = KumoUI.sliderFloat("my_slider2", "Labelled float slider", null, null, float_slider_value);
            float_slider_value = KumoUI.sliderFloat("my_slider3", "Labelled float slider with color", null, null, float_slider_value, null, 0xff0000);
            float_slider_value = KumoUI.sliderFloat("my_slider4", "Labelled float slider with big label", null, null, float_slider_value, 24);
            float_slider_value = KumoUI.sliderFloat("my_slider5", "Labelled float slider with bold label", null, null, float_slider_value, null, null, BOLD);
            float_slider_value = KumoUI.sliderFloat("my_slider6", null, null, null, float_slider_value, null, null, null, KumoUI.getInnerWidth());

            KumoUI.text('Int Sliders: $int_slider_value', null, 24, BOLD);
            int_slider_value = KumoUI.sliderInt("my_slider7", null, null, null, int_slider_value);
            int_slider_value = KumoUI.sliderInt("my_slider8", "Labelled int slider", null, null, int_slider_value);
            int_slider_value = KumoUI.sliderInt("my_slider9", "Labelled int slider with color", null, null, int_slider_value, null, 0xff0000);
            int_slider_value = KumoUI.sliderInt("my_slider10", "Labelled int slider with big label", null, null, int_slider_value, 24);
            int_slider_value = KumoUI.sliderInt("my_slider11", "Labelled int slider with bold label", null, null, int_slider_value, null, null, BOLD);
            int_slider_value = KumoUI.sliderInt("my_slider12", null, null, null, int_slider_value, null, null, null, KumoUI.getInnerWidth());
        }

        // ---------------------------------
        // Input
        // ---------------------------------
        if (KumoUI.collapse("Input")) {
            KumoUI.text('Generic Input (text):', null, 24, BOLD);
            KumoUI.inputText('my_input', 'Basic Label', 'Basic Placeholder');
            KumoUI.inputText('my_input2', 'Label with color', 'Placeholder with color', null, null, 0xff0000);
            KumoUI.inputText('my_input3', 'Label with big label', 'Placeholder with big label', null, 24);
            KumoUI.inputText('my_input4', 'Label with bold label', 'Placeholder with bold label', null, null, null, BOLD);
            KumoUI.inputText('my_input5', 'Label with bold label and color', 'Placeholder with bold label and color', null, null, 0xff0000, BOLD);
            KumoUI.inputText('my_input6', 'Label with big label and color', 'Placeholder with big label and color', null, 24, 0xff0000);
            KumoUI.inputText('my_input7', 'Label with big label and bold label', 'Placeholder with big label and bold label', null, 24, null, BOLD);
            KumoUI.inputText('my_input8', 'Label with big label, bold label and color', 'Placeholder with big label, bold label and color', null, 24, 0xff0000, BOLD);
            KumoUI.inputText('my_input9', null, 'Full-width input', null, null, null, null, KumoUI.getInnerWidth());

            KumoUI.text('Input Int:', null, 24, BOLD);
            KumoUI.inputInt('my_input10', 'Basic Label', 'Basic Placeholder');
            KumoUI.inputInt('my_input11', 'Capped Int input', '-100 to 100', -100, 100);

            KumoUI.text('Input Float:', null, 24, BOLD);
            KumoUI.inputFloat('my_input12', 'Basic Label', 'Basic Placeholder');
            KumoUI.inputFloat('my_input13', 'Capped Float input', '-100 to 100', -100, 100);
        }

        // ---------------------------------
        // Graphs
        // ---------------------------------
        if (KumoUI.collapse("Graphs")) {
            KumoUI.graph(points_sin, KumoUI.getInnerWidth(), 200);
            KumoUI.graph(points_cos, KumoUI.getInnerWidth(), 200, "With normal label (cos)");

            var sideBySideWidth = (KumoUI.getInnerWidth() - Style.GLOBAL_PADDING) / 2;
            KumoUI.graph(points_tan, sideBySideWidth, 100, "With big label (tan)", 24);
            KumoUI.sameLine();
            KumoUI.graph(points_mod, sideBySideWidth, 100, "With bold label (mod)", null, BOLD);
            KumoUI.graph(moving_points_square, KumoUI.getInnerWidth(), 100, "Moving graph (square)");

            moving_points_square_count++;
            moving_points_square.push((if (moving_points_square_count % 100 > 50) 1 else -1));
            moving_points_square.shift();

            KumoUI.multiGraph([
                { label: "sin", color: 0xff0000, points: points_sin },
                { label: "cos", color: 0x00ff00, points: points_cos },
                { label: "tan", color: 0x0000ff, points: points_tan },
                { label: "square", color: 0xff00ff, points: moving_points_square }
            ], KumoUI.getInnerWidth(), 400);
        }

        KumoUI.endWindow();

        if (demo_calc) GraphingCalculator.use();
        if (dev_profiler) Profiler.use();
        if (dev_inspector) Inspector.use();
    }

}
