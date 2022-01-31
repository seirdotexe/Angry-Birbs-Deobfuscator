package §@g§ {
    import § ! §.§+D§;
    import §"n§.§?!=§;
    import §"n§.§`x§;
    import §'!l§.§2N§;
    import §'!l§.§4O§;
    import §'!l§.§5A§;
    import §'!l§.§9!#§;
    import §'!l§.§?!<§;
    import §'!l§.§]!e§;
    import §5&§.§ B§;
    import §5&§.§9!O§;
    import flash.display.Bitmap;
    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.events.TimerEvent;
    import flash.utils.ByteArray;
    import flash.utils.Timer;
    import flash.utils.getTimer;
    
    public class §#!r§ extends EventDispatcher implements §%! § {
        
        protected static const §^!k§:Number = 100;
        
        protected static const §+]§:Number = 20;
         
        
        protected var §>"!§:int;
        
        protected var §<!@§:Object;
        
        protected var §1;§:String;
        
        protected var §"U§:int = 0;
        
        protected var §@!+§:§]!e§;
        
        protected var §="#§:Timer;
        
        protected var §@U§:Object;
        
        protected var §=!v§:Vector.<String>;
        
        public function §#!r§() {
            this.§<!@§ = {};
            super();
            this.§@!+§ = new §]!e§("packageManager");
        }
        
        public function get §-!-§() : §5A§ {
            return this.§@!+§;
        }
        
        public function get §4!d§() : Boolean {
            return this.§"U§ == 0 && (!this.§=!v§ || this.§=!v§.length == 0);
        }
        
        public function dispose() : void {
            this.clear();
            this.§@!+§.dispose();
        }
        
        protected function clear() : void {
            if(this.§="#§) {
                this.§="#§.stop();
                this.§="#§.removeEventListener(TimerEvent.TIMER,this.§`%§);
                this.§="#§ = null;
            }
            this.§@U§ = null;
            this.§=!v§ = null;
        }
        
        protected function §<z§(param1:String, param2:String) : String {
            return param2 + "/" + param1;
        }
        
        protected function §6!E§(param1:String, param2:String) : § B§ {
            return this.§<!@§[this.§<z§(param1,param2)] as § B§;
        }
        
        protected function §'!S§(param1:String, param2:String, param3:§ B§) : void {
            this.§<!@§[this.§<z§(param1,param2)] = param3;
        }
        
        protected function §;E§(param1:String, param2:String = null) : String {
            if(param2 == null) {
                param2 = this.§1;§;
            }
            var p3:§ B§ = this.§6!E§(param1,param2);
            if(!p3) {
                throw new Error("File " + this.§<z§(param1,param2) + " not found",§?!=§.§#"-§);
            }
            return p3.§41§(false);
        }
        
        protected function §3!a§(param1:String, param2:String = null) : ByteArray {
            if(param2 == null) {
                param2 = this.§1;§;
            }
            var p3:§ B§ = this.§6!E§(param1,param2);
            if(!p3) {
                throw new Error("File " + this.§<z§(param1,param2) + " not found",§?!=§.§#"-§);
            }
            return p3.content;
        }
        
        protected function §+F§(param1:String, param2:Function) : void {
            return §`x§.§`!+§(this.§3!a§(param1),param2);
        }
        
        public function §;!h§(param1:ByteArray, param2:String, param3:Boolean = true) : void {
            var p7:§ B§ = null;
            if(!this.§4!d§) {
                throw new Error("Can\'t load another package - need to wait for previous one to complete !!!");
            }
            if(param3) {
                this.§ 9§(param1);
            }
            this.§1;§ = param2;
            var p4:§9!O§;
            (p4 = new §9!O§()).loadBytes(param1);
            var p5:Object = {};
            var p6:int = p4.§3!?§() - 1;
            while(p6 >= 0) {
                if((p7 = p4.§[!;§(p6)).§!! §.substr(-1) != "/") {
                    if(this.§6!E§(p7.§!! §,this.§1;§)) {
                        p5[p7.§!! §] = this.§6!E§(p7.§!! §,this.§1;§);
                    } else {
                        p5[p7.§!! §] = p7;
                        this.§'!S§(p7.§!! §,this.§1;§,p7);
                    }
                }
                p6--;
            }
            this.§%T§(p5);
        }
        
        public function §""0§() : void {
            this.clear();
        }
        
        protected function §"!N§(param1:String) : void {
            var jsonObject:Object = null;
            var fileName:String = param1;
            try {
                jsonObject = JSON.parse(this.§;E§(fileName));
            }
            catch(e:Error) {
                throw new Error("Can\'t convert file \'" + fileName + "\' to object; invalid JSON.",§?!=§.§0w§);
            }
            this.§?U§(jsonObject);
        }
        
        protected function initializeFile(param1:String) : void {
            if(param1.search(/^sprite_sheets\/(.*)\.json$/i) != -1) {
                this.§"!N§(param1);
            }
            var p2:Array = param1.match(/composites\/data\/(.*)\.xml$/i);
            if(p2) {
                this.§=m§(param1);
            }
            p2 = param1.match(/sprite_sheets\/data\/(.*)\.xml$/i);
            if(p2) {
                this.§=m§(param1);
            }
            var p3:Array = param1.match(/composites\/main\/(.*)\.xml$/i);
            if(p3) {
                this.§<!,§(param1);
            }
        }
        
        protected function §%T§(param1:Object) : void {
            this.§%!?§(param1);
            if(this.§=y§()) {
                if(!this.§="#§) {
                    this.§="#§ = new Timer(§+]§,0);
                    this.§="#§.addEventListener(TimerEvent.TIMER,this.§`%§);
                } else {
                    this.§="#§.stop();
                }
                this.§="#§.start();
            }
        }
        
        private function §%!?§(param1:Object) : void {
            var p2:* = null;
            this.§=!v§ = new Vector.<String>();
            for(p2 in param1) {
                this.§=!v§.push(p2);
            }
            this.§@U§ = param1;
        }
        
        private function §=y§() : Boolean {
            var p1:int = getTimer();
            while(getTimer() - p1 < §^!k§ / 2) {
                if(!this.§5!j§()) {
                    break;
                }
            }
            var p2:* = this.§=!v§.length > 0;
            if(this.§4!d§) {
                dispatchEvent(new Event(Event.COMPLETE));
            }
            return p2;
        }
        
        private function §5!j§() : Boolean {
            var p1:String = null;
            if(this.§=!v§.length > 0) {
                p1 = this.§=!v§[0];
                this.§=!v§.splice(0,1);
                this.initializeFile(p1);
                return true;
            }
            return false;
        }
        
        private function §`%§(param1:Event) : void {
            if(!this.§=y§()) {
                if(this.§="#§) {
                    this.§="#§.stop();
                }
            }
        }
        
        protected function §<!,§(param1:String) : void {
            var p2:XML = new XML(this.§;E§(param1));
            §+D§.§@r§(p2);
        }
        
        protected function §=m§(param1:String) : void {
            var activePackageName:String = null;
            var filePath:String = param1;
            activePackageName = this.§1;§;
            var onComplete:Function = function(param1:Bitmap):void {
                var p6:XML = null;
                var p7:String = null;
                var p8:Array = null;
                var p9:String = null;
                var p10:Array = null;
                var p11:String = null;
                var p12:int = 0;
                var p13:* = null;
                var p14:String = null;
                var p2:XML = new XML(§;E§(filePath,activePackageName));
                var p3:Array = [];
                var p4:Vector.<XML> = new Vector.<XML>();
                var p5:XMLList = p2.child("sprite");
                for each(p6 in p5) {
                    if(p7 = p6.@file) {
                        p8 = p7.split("\\");
                        p9 = p8[p8.length - 1];
                        p10 = filePath.split("/");
                        p11 = "";
                        p12 = 0;
                        while(p12 < p10.length - 2) {
                            p11 += p10[p12] + "/";
                            p12++;
                        }
                        p13 = p11 + "source/" + p9 + ".xml";
                        if(§6!E§(p13,activePackageName) == null) {
                            p9 = p8[p8.length - 2] + "/" + p8[p8.length - 1];
                            p13 = p11 + "source/" + p9 + ".xml";
                        }
                        if(p3.indexOf(p9) < 0) {
                            p3.push(p9);
                            p14 = §;E§(p13,activePackageName);
                            p4.push(new XML(p14));
                        }
                    }
                }
                §="!§(new §4O§(p2,p4,param1.bitmapData));
                §6!?§();
            };
            ++this.§"U§;
            var imagePath:String = filePath.substr(0,filePath.length - 3) + "png";
            this.§+F§(imagePath,onComplete);
        }
        
        protected function §="!§(param1:§9!#§) : void {
            this.§@!+§.§1!u§(param1);
        }
        
        protected function §6!?§() : void {
            --this.§"U§;
            if(this.§4!d§) {
                dispatchEvent(new Event(Event.COMPLETE));
            }
        }
        
        protected function §?U§(param1:Object) : void {
            var spriteSheetClass:Class = null;
            var dataObject:Object = param1;
            var onComplete:Function = function(param1:Bitmap):void {
                §="!§(new spriteSheetClass(dataObject,param1.bitmapData));
                §6!?§();
            };
            ++this.§"U§;
            if(dataObject.image) {
                spriteSheetClass = §?!<§;
                this.§+F§("sprite_sheets/" + dataObject.image,onComplete);
            } else {
                if(!(dataObject.name && dataObject.charCount)) {
                    throw new Error("Invalid sprite sheet data.");
                }
                spriteSheetClass = §2N§;
                this.§+F§("sprite_sheets/" + dataObject.name + ".png",onComplete);
            }
        }
        
        protected function § 9§(param1:ByteArray) : void {
            var p2:int = 0;
            this.§>"!§ = 56895 & 25147 >> 1;
            p2 = Math.min(param1.length,65536) - 1;
            while(p2 >= 0) {
                param1[p2] -= int(this.§7!!§() * 255);
                p2 -= 2;
            }
            p2 = param1.length - 1;
            while(p2 >= 0) {
                param1[p2] -= int(this.§7!!§() * 255);
                p2 -= int(this.§7!!§() * 255);
            }
            var p3:int = Math.max(param1.length,65536) - 65536;
            p2 = param1.length - 1;
            while(p2 >= p3) {
                param1[p2] -= int(this.§7!!§() * 255);
                p2 -= 2;
            }
            param1.inflate();
        }
        
        protected function §7!!§() : Number {
            this.§>"!§ ^= this.§>"!§ << 21;
            this.§>"!§ ^= this.§>"!§ >>> 35;
            this.§>"!§ ^= this.§>"!§ << 4;
            if(this.§>"!§ < 0) {
                this.§>"!§ &= 2147483647;
            }
            return this.§>"!§ / 2147483647;
        }
    }
}
