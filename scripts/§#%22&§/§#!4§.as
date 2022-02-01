package §#"&§ {
    import § ^§.§`!2§;
    import §1!`§.§-!M§;
    import §;K§.§&s§;
    import §@!k§.§9!G§;
    import §]0§.§>I§;
    import flash.events.Event;
    import flash.events.HTTPStatusEvent;
    import flash.events.IOErrorEvent;
    import flash.events.TimerEvent;
    import flash.net.URLLoader;
    import flash.net.URLLoaderDataFormat;
    import flash.net.URLRequest;
    import flash.net.URLRequestMethod;
    import flash.net.URLVariables;
    
    public class §#!4§ {
        
        public static const § !z§:String = "serializationJSON";
        
        public static const §8$§:String = "serializationURLParameters";
        
        public static const §';§:String = "09sb85etmnspa89j3mx7han3689ngp9a";
        
        public static const §@!A§:String = "3v9a8crja089ph7st8oh7apr9cm8ja43";
        
        private static const § [§:String = "|";
        
        private static const §4o§:int = 500;
         
        
        private var §=B§:URLLoader;
        
        private var §3!H§:§>I§;
        
        private var §]c§:Boolean = false;
        
        public function §#!4§(param1:Object, param2:String, param3:§>I§, param4:String) {
            super();
            this.§=B§ = new §-!M§();
            this.§3!H§ = param3;
            var p5:URLRequest;
            (p5 = new URLRequest()).method = URLRequestMethod.POST;
            this.§=B§.dataFormat = URLLoaderDataFormat.TEXT;
            switch(param4) {
                case § !z§:
                    p5.contentType = "application/json";
                    p5.data = §&s§.encode(param1);
                    break;
                case §8$§:
                    p5.data = this.§<!H§(param1);
            }
            this.§=B§.addEventListener(Event.COMPLETE,this.onComplete);
            this.§=B§.addEventListener(HTTPStatusEvent.HTTP_STATUS,this.§'!s§);
            this.§=B§.addEventListener(IOErrorEvent.IO_ERROR,this.§=o§);
            p5.url = param2;
            this.§]c§ = false;
            this.§=B§.load(p5);
        }
        
        public static function §"!R§(param1:Object) : String {
            return §9!G§.§3"%§([param1.levelId,param1.score,§`!2§.§!!$§.id,§';§,param1.blocks,param1.gamePlay].join("|"));
        }
        
        public static function §^5§(param1:Array) : String {
            var p3:Object = null;
            var p2:String = "";
            for each(p3 in param1) {
                p2 += p3.levelId + "|";
            }
            p2 += §';§;
            return §9!G§.§3"%§(p2);
        }
        
        public static function §6D§(param1:String, param2:Array) : String {
            var p5:Object = null;
            var p3:String = §@!A§;
            p3 = §9!G§.§3"%§(param1 + § [§ + p3);
            var p4:String = "";
            for each(p5 in param2) {
                p4 += p5.type + p5.count;
                p3 = §9!G§.§3"%§(p3 + § [§ + p4.toString());
            }
            return p3;
        }
        
        public static function §'!q§(param1:Object) : String {
            var p5:Object = null;
            var p6:String = null;
            var p7:Array = null;
            var p8:String = null;
            var p9:String = null;
            var p10:int = 0;
            var p2:Array = [];
            p2.push(param1.levelId);
            p2.push(param1.score + "");
            p2.push(param1.stars + "");
            p2.push(§';§);
            var p3:String = param1.gamePlay;
            var p4:Array = p3.split(":");
            for each(p5 in p4) {
                p2.push(p5);
            }
            p2.push(param1.userId);
            p7 = (p6 = param1.blocks).split(",");
            for each(p5 in p7) {
                p2.push(p5);
            }
            p8 = "";
            p9 = "";
            p10 = 0;
            while(p10 < p2.length) {
                p8 += p2[p10];
                if(p10 <= §4o§) {
                    p9 = §9!G§.§3"%§(p8 + p9);
                }
                p10++;
            }
            if(§4o§ < p2.length) {
                p9 = §9!G§.§3"%§(p8 + p9);
            }
            return p9;
        }
        
        private static function getText(param1:Array) : String {
            var p3:int = 0;
            var p2:String = "";
            for each(p3 in param1) {
                p2 += String.fromCharCode(p3);
            }
            return p2;
        }
        
        public static function §9!7§(param1:String, param2:int, param3:int, param4:String) : String {
            var p5:String = §';§;
            var p6:String = (p6 = (p6 = (p6 = "") + p5) + § [§) + param2;
            p5 = §9!G§.§3"%§(p6);
            p6 = (p6 = (p6 += p5) + § [§) + param3;
            p5 = §9!G§.§3"%§(p6);
            p6 = (p6 = (p6 += p5) + § [§) + param4;
            p5 = §9!G§.§3"%§(p6);
            p6 = (p6 += p5) + param1;
            p5 = §9!G§.§3"%§(p6);
            return p6.length > 0 ? p5 : null;
        }
        
        public function get §-I§() : Boolean {
            return this.§]c§;
        }
        
        private function §4!]§(param1:TimerEvent) : void {
            this.dispose();
        }
        
        private function onComplete(param1:Event) : void {
            this.§3!H§.onComplete(param1);
            this.§]c§ = true;
            this.removeEventListeners();
        }
        
        private function §'!s§(param1:HTTPStatusEvent) : void {
            this.§3!H§.§'!s§(param1);
        }
        
        private function §=o§(param1:IOErrorEvent) : void {
            this.§3!H§.§=o§(param1);
            this.removeEventListeners();
        }
        
        public function get §8!P§() : URLLoader {
            return this.§=B§;
        }
        
        private function removeEventListeners() : void {
            if(this.§=B§) {
                this.§=B§.removeEventListener(HTTPStatusEvent.HTTP_STATUS,this.§'!s§);
                this.§=B§.removeEventListener(Event.COMPLETE,this.onComplete);
                this.§=B§.removeEventListener(IOErrorEvent.IO_ERROR,this.§=o§);
            }
        }
        
        public function dispose() : void {
            this.removeEventListeners();
            if(this.§=B§) {
                this.§=B§.close();
                this.§=B§ = null;
            }
            if(this.§3!H§) {
                this.§3!H§ = null;
            }
        }
        
        private function §<!H§(param1:Object) : URLVariables {
            var p3:* = null;
            var p2:URLVariables = new URLVariables();
            for(p3 in param1) {
                p2[p3] = param1[p3];
            }
            return p2;
        }
    }
}
