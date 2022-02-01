package com.rovio.loader {
    import com.rovio.graphics.CompositeSpriteParser;
    import com.rovio.utils.ErrorCode;
    import com.rovio.utils.ImageDataUtils;
    import com.rovio.spritesheet.FontSheetJSONGGS;
    import com.rovio.spritesheet.SpriteSheetXMLGGS;
    import com.rovio.spritesheet.ISpriteSheetContainer;
    import com.rovio.spritesheet.SpriteSheetBase;
    import com.rovio.spritesheet.SpriteSheetJSONGGS;
    import com.rovio.spritesheet.SpriteSheetContainer;
    import deng.fzip.FZipFile;
    import deng.fzip.FZip;
    import flash.display.Bitmap;
    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.events.TimerEvent;
    import flash.utils.ByteArray;
    import flash.utils.Timer;
    import flash.utils.getTimer;
    
    public class PackageLoader extends EventDispatcher implements IPackageLoader {
        
        protected static const MAX_FRAME_TIME_MILLI_SECONDS:Number = 100;
        
        protected static const FRAME_BREATH_TIME_MILLI_SECONDS:Number = 20;
         
        
        protected var mRandom:int;
        
        protected var mFiles:Object;
        
        protected var mActivePackageName:String;
        
        protected var mUnitializedItems:int = 0;
        
        protected var mSpriteSheetContainer:SpriteSheetContainer;
        
        protected var mTimer:Timer;
        
        protected var mPackageFiles:Object;
        
        protected var mPackageFileList:Vector.<String>;
        
        public function PackageLoader() {
            this.mFiles = {};
            super();
            this.mSpriteSheetContainer = new SpriteSheetContainer("packageManager");
        }
        
        public function get spriteSheetContainer() : ISpriteSheetContainer {
            return this.mSpriteSheetContainer;
        }
        
        public function get loadingCompleted() : Boolean {
            return this.mUnitializedItems == 0 && (!this.mPackageFileList || this.mPackageFileList.length == 0);
        }
        
        public function dispose() : void {
            this.clear();
            this.mSpriteSheetContainer.dispose();
        }
        
        protected function clear() : void {
            if(this.mTimer) {
                this.mTimer.stop();
                this.mTimer.removeEventListener(TimerEvent.TIMER,this.onTimer);
                this.mTimer = null;
            }
            this.mPackageFiles = null;
            this.mPackageFileList = null;
        }
        
        protected function getFullPath(param1:String, param2:String) : String {
            return param2 + "/" + param1;
        }
        
        protected function getZipFile(param1:String, param2:String) : FZipFile {
            return this.mFiles[this.getFullPath(param1,param2)] as FZipFile;
        }
        
        protected function setZipFile(param1:String, param2:String, param3:FZipFile) : void {
            this.mFiles[this.getFullPath(param1,param2)] = param3;
        }
        
        protected function getFileAsString(param1:String, param2:String = null) : String {
            if(param2 == null) {
                param2 = this.mActivePackageName;
            }
            var p3:FZipFile = this.getZipFile(param1,param2);
            if(!p3) {
                throw new Error("File " + this.getFullPath(param1,param2) + " not found",ErrorCode.ZIP_FILE_NOT_FOUND);
            }
            return p3.getContentAsString(false);
        }
        
        protected function getFileData(param1:String, param2:String = null) : ByteArray {
            if(param2 == null) {
                param2 = this.mActivePackageName;
            }
            var p3:FZipFile = this.getZipFile(param1,param2);
            if(!p3) {
                throw new Error("File " + this.getFullPath(param1,param2) + " not found",ErrorCode.ZIP_FILE_NOT_FOUND);
            }
            return p3.content;
        }
        
        protected function getFileAsBitmap(param1:String, param2:Function) : void {
            return ImageDataUtils.getImageFromBytes(this.getFileData(param1),param2);
        }
        
        public function loadPackageFromBytes(param1:ByteArray, param2:String, param3:Boolean = true) : void {
            var p7:FZipFile = null;
            if(!this.loadingCompleted) {
                throw new Error("Can\'t load another package - need to wait for previous one to complete !!!");
            }
            if(param3) {
                this.decryptPackage(param1);
            }
            this.mActivePackageName = param2;
            var p4:FZip;
            (p4 = new FZip()).loadBytes(param1);
            var p5:Object = {};
            var p6:int = p4.getFileCount() - 1;
            while(p6 >= 0) {
                if((p7 = p4.getFileAt(p6)).filename.substr(-1) != "/") {
                    if(this.getZipFile(p7.filename,this.mActivePackageName)) {
                        p5[p7.filename] = this.getZipFile(p7.filename,this.mActivePackageName);
                    } else {
                        p5[p7.filename] = p7;
                        this.setZipFile(p7.filename,this.mActivePackageName,p7);
                    }
                }
                p6--;
            }
            this.initializePackage(p5);
        }
        
        public function stopLoading() : void {
            this.clear();
        }
        
        protected function initializeSpriteSheetFile(param1:String) : void {
            var jsonObject:Object = null;
            var fileName:String = param1;
            try {
                jsonObject = JSON.parse(this.getFileAsString(fileName));
            }
            catch(e:Error) {
                throw new Error("Can\'t convert file \'" + fileName + "\' to object; invalid JSON.",ErrorCode.JSON_PARSE_ERROR);
            }
            this.initializeSpriteSheetFromObject(jsonObject);
        }
        
        protected function initializeFile(param1:String) : void {
            if(param1.search(/^sprite_sheets\/(.*)\.json$/i) != -1) {
                this.initializeSpriteSheetFile(param1);
            }
            var p2:Array = param1.match(/composites\/data\/(.*)\.xml$/i);
            if(p2) {
                this.initializeXMLSpriteSheet(param1);
            }
            p2 = param1.match(/sprite_sheets\/data\/(.*)\.xml$/i);
            if(p2) {
                this.initializeXMLSpriteSheet(param1);
            }
            var p3:Array = param1.match(/composites\/main\/(.*)\.xml$/i);
            if(p3) {
                this.initializeCompositeSprite(param1);
            }
        }
        
        protected function initializePackage(param1:Object) : void {
            this.preparePackage(param1);
            if(this.continuePackageInitialization()) {
                if(!this.mTimer) {
                    this.mTimer = new Timer(FRAME_BREATH_TIME_MILLI_SECONDS,0);
                    this.mTimer.addEventListener(TimerEvent.TIMER,this.onTimer);
                } else {
                    this.mTimer.stop();
                }
                this.mTimer.start();
            }
        }
        
        private function preparePackage(param1:Object) : void {
            var p2:* = null;
            this.mPackageFileList = new Vector.<String>();
            for(p2 in param1) {
                this.mPackageFileList.push(p2);
            }
            this.mPackageFiles = param1;
        }
        
        private function continuePackageInitialization() : Boolean {
            var p1:int = getTimer();
            while(getTimer() - p1 < MAX_FRAME_TIME_MILLI_SECONDS / 2) {
                if(!this.initializeFileFromPackage()) {
                    break;
                }
            }
            var p2:* = this.mPackageFileList.length > 0;
            if(this.loadingCompleted) {
                dispatchEvent(new Event(Event.COMPLETE));
            }
            return p2;
        }
        
        private function initializeFileFromPackage() : Boolean {
            var p1:String = null;
            if(this.mPackageFileList.length > 0) {
                p1 = this.mPackageFileList[0];
                this.mPackageFileList.splice(0,1);
                this.initializeFile(p1);
                return true;
            }
            return false;
        }
        
        private function onTimer(param1:Event) : void {
            if(!this.continuePackageInitialization()) {
                if(this.mTimer) {
                    this.mTimer.stop();
                }
            }
        }
        
        protected function initializeCompositeSprite(param1:String) : void {
            var p2:XML = new XML(this.getFileAsString(param1));
            CompositeSpriteParser.addCompositeSprites(p2);
        }
        
        protected function initializeXMLSpriteSheet(param1:String) : void {
            var activePackageName:String = null;
            var filePath:String = param1;
            activePackageName = this.mActivePackageName;
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
                var p2:XML = new XML(getFileAsString(filePath,activePackageName));
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
                        if(getZipFile(p13,activePackageName) == null) {
                            p9 = p8[p8.length - 2] + "/" + p8[p8.length - 1];
                            p13 = p11 + "source/" + p9 + ".xml";
                        }
                        if(p3.indexOf(p9) < 0) {
                            p3.push(p9);
                            p14 = getFileAsString(p13,activePackageName);
                            p4.push(new XML(p14));
                        }
                    }
                }
                addSpriteSheet(new SpriteSheetXMLGGS(p2,p4,param1.bitmapData));
                handleItemInitialization();
            };
            ++this.mUnitializedItems;
            var imagePath:String = filePath.substr(0,filePath.length - 3) + "png";
            this.getFileAsBitmap(imagePath,onComplete);
        }
        
        protected function addSpriteSheet(param1:SpriteSheetBase) : void {
            this.mSpriteSheetContainer.addSheet(param1);
        }
        
        protected function handleItemInitialization() : void {
            --this.mUnitializedItems;
            if(this.loadingCompleted) {
                dispatchEvent(new Event(Event.COMPLETE));
            }
        }
        
        protected function initializeSpriteSheetFromObject(param1:Object) : void {
            var spriteSheetClass:Class = null;
            var dataObject:Object = param1;
            var onComplete:Function = function(param1:Bitmap):void {
                addSpriteSheet(new spriteSheetClass(dataObject,param1.bitmapData));
                handleItemInitialization();
            };
            ++this.mUnitializedItems;
            if(dataObject.image) {
                spriteSheetClass = SpriteSheetJSONGGS;
                this.getFileAsBitmap("sprite_sheets/" + dataObject.image,onComplete);
            } else {
                if(!(dataObject.name && dataObject.charCount)) {
                    throw new Error("Invalid sprite sheet data.");
                }
                spriteSheetClass = FontSheetJSONGGS;
                this.getFileAsBitmap("sprite_sheets/" + dataObject.name + ".png",onComplete);
            }
        }
        
        protected function decryptPackage(param1:ByteArray) : void {
            var p2:int = 0;
            this.mRandom = 56895 & 25147 >> 1;
            p2 = Math.min(param1.length,65536) - 1;
            while(p2 >= 0) {
                param1[p2] -= int(this.getNextRandom() * 255);
                p2 -= 2;
            }
            p2 = param1.length - 1;
            while(p2 >= 0) {
                param1[p2] -= int(this.getNextRandom() * 255);
                p2 -= int(this.getNextRandom() * 255);
            }
            var p3:int = Math.max(param1.length,65536) - 65536;
            p2 = param1.length - 1;
            while(p2 >= p3) {
                param1[p2] -= int(this.getNextRandom() * 255);
                p2 -= 2;
            }
            param1.inflate();
        }
        
        protected function getNextRandom() : Number {
            this.mRandom ^= this.mRandom << 21;
            this.mRandom ^= this.mRandom >>> 35;
            this.mRandom ^= this.mRandom << 4;
            if(this.mRandom < 0) {
                this.mRandom &= 2147483647;
            }
            return this.mRandom / 2147483647;
        }
    }
}
