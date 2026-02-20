package kui.util;

#if cpp
    @:cppFileCode('#include <chrono>')
#end
class ProfilerTimer {

    /**
     * Gets the best high resolution time available, in seconds.
     */
    public static function getTime() {
        #if js
            return js.Browser.window.performance.now() / 1000;
        #elseif cpp
            return untyped __cpp__("std::chrono::duration_cast<std::chrono::duration<double>>(std::chrono::high_resolution_clock::now().time_since_epoch()).count()");
        #else
            return Sys.time();
        #end
    }

}