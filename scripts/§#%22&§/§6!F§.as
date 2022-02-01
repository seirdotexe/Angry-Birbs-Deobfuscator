package §#"&§ {
    import §"n§.§<n§;
    import §4!o§.§+!N§;
    import §8!K§.§5!0§;
    import §8!K§.§5!Y§;
    import §8]§.§7!4§;
    import §@g§.§#!r§;
    import flash.display.Bitmap;
    import flash.display.Loader;
    import flash.events.Event;
    import flash.system.ApplicationDomain;
    import flash.system.LoaderContext;
    
    [SecureSWF(codeWrap="max",rename="true",statementLevel="true",controlFlow="100")]
    public class §6!F§ extends §#!r§ {
         
        
        protected var §&" §:§5!Y§;
        
        protected var §7!r§:Loader;
        
        protected var §>!Y§:Vector.<XML>;
        
        public function §6!F§(param1:§5!Y§) {
            this.§>!Y§ = new Vector.<XML>();
            super();
            this.§&" § = param1;
        }
        
        override public function dispose() : void {
            super.dispose();
            this.§&" § = null;
        }
        
        override protected function clear() : void {
            super.clear();
            if(this.§7!r§) {
                this.§7!r§.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.§`!@§);
                this.§7!r§ = null;
            }
        }
        
        override protected function initializeFile(param1:String) : void {
            var p6:String = null;
            var p2:Array = param1.match(/^levels\/(.*)\.json$/i);
            if(p2) {
                p6 = p2[1].toLowerCase().substr("level".length);
                this.§7w§(p6,param1);
            }
            var p3:Array = param1.match(/^particle_emitters\/(.*)\.pex$/i);
            if(p3) {
                this.§%!^§(p3[1]);
            }
            var p4:Array;
            if(p4 = param1.match(/cutscenes.lua$/i)) {
                this.§,!d§(param1);
            }
            var p5:Array;
            if(p5 = param1.match(/cutscene.swf$/i)) {
                this.§?"$§(param1);
            }
            if(param1.toLowerCase() == "assetmap.xml") {
                this.§<Z§(param1);
            }
            if(param1.toLowerCase() == "episodes.json") {
                this.§'!<§(param1);
            }
            super.initializeFile(param1);
        }
        
        protected function §7w§(param1:String, param2:String) : void {
            if(!this.§&" §.getLevelForId(param1)) {
                this.§&" §.§^8§(param1,§5!0§.§'!&§(§;E§(param2)));
            }
        }
        
        protected function §'!<§(param1:String) : void {
            this.§&" §.§#!!§(JSON.parse(§;E§(param1)));
        }
        
        private function §<Z§(param1:String) : void {
            ++§"U§;
            var p2:XML = new XML(§;E§(param1));
            this.§>!Y§.push(p2);
            if(this.§>!Y§.length == 1) {
                this.§7!r§ = new Loader();
                this.§7!r§.contentLoaderInfo.addEventListener(Event.COMPLETE,this.§`!@§);
                this.§7!r§.loadBytes(§3!a§(p2.Library.@swf),new LoaderContext(false,ApplicationDomain.currentDomain));
            }
        }
        
        private function §`!@§(param1:Event) : void {
            this.§7!r§.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.§`!@§);
            var p2:XML = this.§>!Y§.shift();
            if(this.§>!Y§.length > 0) {
                this.§7!r§ = new Loader();
                this.§7!r§.contentLoaderInfo.addEventListener(Event.INIT,this.§`!@§);
                this.§7!r§.loadBytes(§3!a§(this.§>!Y§[0].Library.@swf),new LoaderContext(false,ApplicationDomain.currentDomain));
            }
            §6!?§();
        }
        
        private function §,!d§(param1:String) : void {
            var p2:Object = §<n§.§%d§(§;E§(param1));
            §+!N§.§,!d§(p2);
        }
        
        private function §?"$§(param1:String) : void {
            §+!N§.§#L§(§1;§,§3!a§(param1,§1;§));
        }
        
        protected function §%!^§(param1:String) : void {
            var id:String = param1;
            var onComplete:Function = function(param1:Bitmap):void {
                §7!4§.§%U§(id,XML(§;E§("particle_emitters/" + id + ".pex")),param1.bitmapData);
                §6!?§();
            };
            ++§"U§;
            §+F§("particle_emitters/" + id + ".png",onComplete);
        }
    }
}
