package kui;

class ComponentRegistry {

    public static var regMap: Map<String, Class<Component>> = [];

    public static function defineComponent(clazz: Class<Component>): Void {
        var name = Type.getClassName(clazz);
        regMap[name] = clazz;
    }

    public static function getComponent(clazz: Class<Component>): Class<Component> {
        return regMap[Type.getClassName(clazz)] ?? clazz;
    }

    public static function overwriteComponent(clazz: Class<Component>, with: Class<Component>): Void {
        var name = Type.getClassName(clazz);
        regMap[name] = with;
    }

    public static function createComponent(clazz: Class<Component>, args: Array<Dynamic>): Component {
        return Type.createInstance(getComponent(clazz), args);
    }

}