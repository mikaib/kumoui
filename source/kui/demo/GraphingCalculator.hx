package kui.demo;

class MathExprContext {
    private var variables: Map<String, Float>;
    private var functions: Map<String, Array<Float> -> Float>;
    private var argCounts: Map<String, Int>;
    private var operators: Map<String, (Float, Float) -> Float>;

    public function new() {
        variables = new Map<String, Float>();
        functions = new Map<String, Array<Float> -> Float>();
        argCounts = new Map<String, Int>();
        operators = [
            "+" => (a, b) -> return a + b,
            "-" => (a, b) -> return a - b,
            "*" => (a, b) -> return a * b,
            "/" => (a, b) -> return a / b,
            "^" => (a, b) -> return Math.pow(a, b),
            "%" => (a, b) -> return a % b
        ];

        setVariable("pi", Math.PI);
        setFunction("sin", (args) -> return Math.sin(args[0]), 1);
        setFunction("cos", (args) -> return Math.cos(args[0]), 1);
        setFunction("tan", (args) -> return Math.tan(args[0]), 1);
    }

    public function setVariable(name: String, value: Float): Void {
        variables[name] = value;
    }

    public function setFunction(name: String, func: Array<Float> -> Float, argCount: Int): Void {
        functions[name] = func;
        argCounts[name] = argCount;
    }

    public function getVariable(name: String): Null<Float> {
        return variables.get(name);
    }

    public function getFunction(name: String): Null<Array<Float> -> Float> {
        return functions.get(name);
    }

    public function getFunctionArgCount(name: String): Null<Int> {
        return argCounts.get(name);
    }

    public function hasVariable(name: String): Bool {
        return variables.exists(name);
    }

    public function hasFunction(name: String): Bool {
        return functions.exists(name);
    }

    public function eval(expr: String, x: Float = 0): Float {
        setVariable("x", x);
        expr = StringTools.replace(expr, " ", "");
        return parseExpression(expr);
    }

    private function parseExpression(expr: String): Float {
        var tokens = tokenize(expr);
        var postfix = infixToPostfix(tokens);
        return evaluatePostfix(postfix);
    }

    private function tokenize(expr: String): Array<String> {
        var tokens = [];
        var numberBuffer = new StringBuf();
        var funcBuffer = new StringBuf();
        var prevChar = "";
        var isUnary = true;

        for (i in 0...expr.length) {
            var ch = expr.charAt(i);

            if (isDigit(ch) || ch == '.') {
                if (funcBuffer.length > 0) {
                    tokens.push(funcBuffer.toString());
                    funcBuffer = new StringBuf();
                    tokens.push("*");
                }
                numberBuffer.add(ch);
                isUnary = false;
            } else {
                if (numberBuffer.length > 0) {
                    tokens.push(numberBuffer.toString());
                    numberBuffer = new StringBuf();
                }
                if (isAlpha(ch)) {
                    funcBuffer.add(ch);
                    isUnary = false;
                } else {
                    if (funcBuffer.length > 0) {
                        tokens.push(funcBuffer.toString());
                        funcBuffer = new StringBuf();
                    }
                    if (ch == '(') {
                        if (prevChar != "" && (isNumber(prevChar) || prevChar == ')')) {
                            tokens.push("*");
                        }
                        tokens.push(ch);
                        isUnary = true;
                    } else if (ch == '-' && isUnary) {
                        tokens.push("0");
                        tokens.push(ch);
                    } else {
                        if (ch == ')') {
                            isUnary = false;
                        } else if (isOperator(ch)) {
                            isUnary = true;
                        }
                        tokens.push(ch);
                    }
                }
            }
            prevChar = ch;
        }

        if (numberBuffer.length > 0) {
            tokens.push(numberBuffer.toString());
        }
        if (funcBuffer.length > 0) {
            tokens.push(funcBuffer.toString());
        }

        // Handle implicit multiplication before functions and variables
        for (i in 0...tokens.length - 1) {
            if (isNumber(tokens[i]) && (isAlpha(tokens[i + 1].charAt(0)) || tokens[i + 1] == "(")) {
                tokens.insert(i + 1, "*");
            }
        }

        return tokens;
    }

    private function infixToPostfix(tokens: Array<String>): Array<String> {
        var output = [];
        var operatorsStack = [];

        for (token in tokens) {
            if (isNumber(token)) {
                output.push(token);
            } else if (isVariable(token)) {
                output.push(token);
            } else if (isFunction(token)) {
                operatorsStack.push(token);
            } else if (token == "(") {
                operatorsStack.push(token);
            } else if (token == ")") {
                while (operatorsStack.length > 0 && operatorsStack[operatorsStack.length - 1] != "(") {
                    output.push(operatorsStack.pop());
                }
                if (operatorsStack.length == 0) throw "Mismatched parentheses";
                operatorsStack.pop();
                if (operatorsStack.length > 0 && isFunction(operatorsStack[operatorsStack.length - 1])) {
                    output.push(operatorsStack.pop());
                }
            } else if (isOperator(token)) {
                while (operatorsStack.length > 0 && precedence(operatorsStack[operatorsStack.length - 1]) >= precedence(token)) {
                    output.push(operatorsStack.pop());
                }
                operatorsStack.push(token);
            }
        }

        while (operatorsStack.length > 0) {
            var op = operatorsStack.pop();
            if (op == "(" || op == ")") throw "Mismatched parentheses";
            output.push(op);
        }

        return output;
    }

    private function evaluatePostfix(tokens: Array<String>): Float {
        var stack = [];

        for (token in tokens) {
            if (isNumber(token)) {
                stack.push(Std.parseFloat(token));
            } else if (isVariable(token)) {
                var value = getVariable(token);
                if (value == null) throw "Unknown variable: " + token;
                stack.push(value);
            } else if (isFunction(token)) {
                var func = getFunction(token);
                var argCount = getFunctionArgCount(token);
                if (func == null || argCount == null) throw "Unknown function: " + token;

                var args = [];
                for (i in 0...argCount) {
                    if (stack.length == 0) throw "Insufficient arguments for function: " + token;
                    args.push(stack.pop());
                }
                args.reverse();
                stack.push(func(args));
            } else if (isOperator(token)) {
                if (stack.length < 2) throw "Insufficient operands for operator: " + token;
                var b = stack.pop();
                var a = stack.pop();
                stack.push(operators.get(token)(a, b));
            }
        }

        if (stack.length != 1) throw "Invalid expression";
        return stack.pop();
    }

    private function isDigit(ch: String): Bool {
        return ch >= "0" && ch <= "9";
    }

    private function isAlpha(ch: String): Bool {
        return (ch >= "a" && ch <= "z") || (ch >= "A" && ch <= "Z");
    }

    private function isNumber(token: String): Bool {
        return !Math.isNaN(Std.parseFloat(token));
    }

    private function isVariable(token: String): Bool {
        return hasVariable(token);
    }

    private function isFunction(token: String): Bool {
        return hasFunction(token);
    }

    private function isOperator(token: String): Bool {
        return operators.exists(token);
    }

    private function precedence(op: String): Int {
        return switch (op) {
            case "+", "-":
                1;
            case "*", "/" , "%":
                2;
            case "^":
                3;
            default:
                0;
        };
    }

    
    public function intersect(exprA: String, exprB: String, wxmin: Float, wxmax: Float): Array<Float> {
        var results = [];
        var tolerance = 0.0000001;
        var segments = 100000;

        var func = (x: Float) -> eval(exprA, x) - eval(exprB, x);
    
        for (i in 0...segments) {
            var start = wxmin + i * (wxmax - wxmin) / segments;
            var end = wxmin + (i + 1) * (wxmax - wxmin) / segments;
    
            var root = findRoot(func, start, end, tolerance);
            if (root != null) {
                results.push(root);
            }
        }
    
        return results;
    }
    
    private function findRoot(func: Float -> Float, a: Float, b: Float, tolerance: Float): Null<Float> {
        var fa = func(a);
        var fb = func(b);
    
        if (fa * fb > 0) {
            return null;
        }
    
        var c = a;
        var fc = fa;
        var d = b - a;
        var e = d;
    
        for (i in 0...100) {
            if (Math.abs(fc) < Math.abs(fb)) {
                a = b;
                b = c;
                c = a;
                fa = fb;
                fb = fc;
                fc = fa;
            }
    
            var tolerance1 = 2 * 0.000001 * Math.abs(b) + 0.5 * tolerance;
            var m = 0.5 * (c - b);
    
            if (Math.abs(m) <= tolerance1 || fb == 0.0) {
                return b;
            }
    
            if (Math.abs(e) >= tolerance1 && Math.abs(fa) > Math.abs(fb)) {
                var s = fb / fa;
    
                var p: Float;
                var q: Float;
                var r: Float;
    
                if (a == c) {
                    p = 2 * m * s;
                    q = 1 - s;
                } else {
                    q = fa / fc;
                    r = fb / fc;
                    p = s * (2 * m * q * (q - r) - (b - a) * (r - 1));
                    q = (q - 1) * (r - 1) * (s - 1);
                }
    
                if (p > 0) {
                    q = -q;
                } else {
                    p = -p;
                }
    
                s = e;
                e = d;
    
                if (2 * p < 3 * m * q - Math.abs(tolerance1 * q) && p < Math.abs(0.5 * s * q)) {
                    d = p / q;
                } else {
                    e = m;
                    d = e;
                }
            } else {
                e = m;
                d = e;
            }
    
            a = b;
            fa = fb;
    
            if (Math.abs(d) > tolerance1) {
                b += d;
            } else {
                b += sign(m) * tolerance1;
            }
    
            fb = func(b);
        }
    
        return null; // Maximum iterations exceeded, no root found
    }    

    public function sign(x: Float): Float {
        return x < 0 ? -1 : 1;
    }

    public function points(expr: String, wxmin: Float, wxmax: Float, points: Int): Array<{x: Float, y: Float}> {
        var results = [];
        var step = (wxmax - wxmin) / (points - 1);

        for (i in 0...points) {
            var wx = wxmin + i * step;
            var wy = eval(expr, wx);
            results.push({ x: wx, y: wy });
        }

        return results;
    }
}


class GraphingCalculator {
    
    private static var functions: Array<{ label: String, expr: String, color: Int, points: Array<Float>, error: String }> = [];
    private static var constants: Array<{ name: String, value: Float }> = [];
    private static var intersectionExprIndexA: Int = 0;
    private static var intersectionExprIndexB: Int = 1;
    private static var intersectionResults: Array<{ x: Float, y: Float }> = [];
    private static var resolution: Int = 1000;
    private static var windowMin: Float = -10;
    private static var windowMax: Float = 10;

    public static function uniqueColor(index: Int) : Int {
        var r = Math.sin(index * 0.5) * 127 + 128;
        var g = Math.sin(index * 0.5 + 2) * 127 + 128;
        var b = Math.sin(index * 0.5 + 4) * 127 + 128;
        return Std.int(r) << 16 | Std.int(g) << 8 | Std.int(b);
    }

    public static function recalculate() {
        var context = new MathExprContext();
        for (c in constants) {
            context.setVariable(c.name, c.value);
        }

        for (fn in functions) {
            try {
                var points = context.points(fn.expr, windowMin, windowMax, resolution);
                fn.points = points.map(function(p) return p.y);
                fn.error = null;
            } catch (e: Dynamic) {
                fn.error = e;
            }
        }
    }

    public static function use() {
        KumoUI.beginWindow('Graphing Calculator', 'graphing_calculator');

        if (KumoUI.button('Create New Constant')) {
            var name = 'New Constant';
            var i = 1;
            while (constants.filter(function(c) return c.name == name).length != 0) {
                name = 'New Constant ' + i;
                i++;
            }
            
            constants.push({ name: name, value: 0 });
        }

        KumoUI.sameLine();

        if (KumoUI.button('Create New Expression')) {
            var name = 'New Expression';
            var i = 1;
            while (functions.filter(function(f) return f.label == name).length != 0) {
                name = 'New Expression ' + i;
                i++;
            }
            
            functions.push({ label: name, expr: '', color: uniqueColor(functions.length), points: [], error: null });
        }

        if (KumoUI.collapse('Expressions')) {
            var index = 0;
            for (fn in functions) {
                fn.label = KumoUI.inputText('gc_label_$index', null, null, fn.label, null, null, null, 200);
                KumoUI.sameLine();

                var nw = KumoUI.inputText('gc_expr_$index', null, null, fn.expr, null, null, null, KumoUI.getInnerWidth() - 200 - Style.GLOBAL_PADDING * 2 - 150);
                if (fn.expr != nw) {
                    fn.expr = nw;
                    recalculate();
                }
               
                KumoUI.sameLine();

                if (KumoUI.button('remove', null, null, true)) functions.splice(index, 1);
                if (fn.error != null) KumoUI.text('Error: ${fn.error}', 0xff0000, 12, BOLD);

                index++;
            }
        }

        if (KumoUI.collapse('Constants')) {
            var index = 0;

            for (c in constants) {
                c.name = KumoUI.inputText('gc_name_$index', null, null, c.name, null, null, null, 200);
                KumoUI.sameLine();

                var nw = KumoUI.inputFloat('gc_value_$index', null, null, c.value, null, null, null, 200);
                if (c.value != nw) {
                    c.value = nw;
                    recalculate();
                }

                KumoUI.sameLine();
                if (KumoUI.button('remove', null, null, true)) constants.splice(index, 1);

                index++;
            }
        }

        if (KumoUI.collapse('Intersection')) {
            KumoUI.text('Intersection Expression A: ${functions[intersectionExprIndexA]?.label ?? 'None'}');
            for (i in 0...functions.length) {
                if (KumoUI.button('Expression: ${functions[i].label}')) intersectionExprIndexA = i;
                if (i != functions.length - 1) KumoUI.sameLine();
            }

            KumoUI.text('Intersection Expression B: ${functions[intersectionExprIndexB]?.label ?? 'None'}');
            for (i in 0...functions.length) {
                if (KumoUI.button('Expression: ${functions[i].label}')) intersectionExprIndexB = i;
                if (i != functions.length - 1) KumoUI.sameLine();
            }

            if (KumoUI.button('Calculate Intersections', null, null, true)) {
                var context = new MathExprContext();
                for (c in constants) {
                    trace(c.name, c.value);
                    context.setVariable(c.name, c.value);
                }

                var xCoords = context.intersect(functions[intersectionExprIndexA].expr, functions[intersectionExprIndexB].expr, windowMin, windowMax);
                intersectionResults = xCoords.map(function(x) return { x: x, y: context.eval(functions[intersectionExprIndexA].expr, x) });
            }
            
            KumoUI.text('Intersections:', null, null, BOLD);
            for (i in 0...intersectionResults.length) {
                KumoUI.text('x = ${intersectionResults[i].x}, y = ${intersectionResults[i].y}');
            }
        }

        if (KumoUI.collapse("Window")) {
            var newWindowMin = KumoUI.sliderFloat('gc_window_min', 'Window Min', -1000, 1000, windowMin);
            var newWindowMax = KumoUI.sliderFloat('gc_window_max', 'Window Max', -1000, 1000, windowMax);
            var newResolution = KumoUI.sliderInt('gc_resolution', 'Resolution', 10, 2500, resolution);
            if (newWindowMin != windowMin || newWindowMax != windowMax || newResolution != resolution) {
                windowMin = newWindowMin;
                windowMax = newWindowMax;
                resolution = newResolution;
                recalculate();
            }
        }

        KumoUI.separator();
        
        var pos = Layout.getNextPosition();
        var parentY = KumoUI.getParentY();
        var parentHeight = KumoUI.getParentHeight();
        var graphHeight = parentHeight - (pos.y - parentY) - Style.GLOBAL_PADDING * 4;
        KumoUI.multiGraph(functions, KumoUI.getInnerWidth(), graphHeight);

        KumoUI.endWindow();
    }

}