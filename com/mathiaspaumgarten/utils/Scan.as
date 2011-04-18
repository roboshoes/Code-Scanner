package com.mathiaspaumgarten.utils {
	
	import flash.events.EventDispatcher;
	import flash.filesystem.File;
	import flash.events.Event;
	import flash.filesystem.FileStream;
	import flash.filesystem.FileMode;
	
	public class Scan extends EventDispatcher {
		
		private var numLines:int;
		private var numFiles:int;
		private var numUsedLines:int;
		private var keys:Array;
		private var values:Array;
		private var _fileTypes:Array;
		private var _skipFolder:Array;
		private var log:String;
		
		public function Scan() {
			super();
			
			_fileTypes = [];
		}
		
		public function getStats(base:File):String {
			
			if (!base.isDirectory) {
				throw new Error("Given parameter must be a directory!");
				return;
			}
			
			log = "";
			numLines = 0;
			numFiles = 0;
			numUsedLines = 0;
			values = new Array(keys.length);
			
			for (var i:int = 0; i < values.length; i++) values[i] = 0;
			
			log += "===== FILES =====\n\n";
			getStrictStats(base);
			
			return toString();
		}
		
		private function getStrictStats(base:File):void {
			var files:Array = base.getDirectoryListing();
			
			for each(var file:File in files) {
				if (_fileTypes.indexOf(file.extension) != -1 && !file.isDirectory) {
					
					log += file.nativePath + "\n";
					
					numFiles++;
					
					var fileStream:FileStream = new FileStream();
					fileStream.open(file, FileMode.READ);
					fileStream.position = 0;
					
					var fileText:String = fileStream.readUTFBytes(fileStream.bytesAvailable);
					
					while (fileText.length > 0) {
						
						var line:String;
						if (fileText.indexOf("\n") != -1) {
							line = fileText.substr(0, fileText.indexOf("\n"));
							fileText = fileText.substr(fileText.indexOf("\n") + 2);
						} else {
							line = fileText;
							fileText = "";
						}
						
						if (line.length > 0) numUsedLines++;
						numLines++;
						
						for (var i:int = 0; i < keys.length; i++) {
							values[i] += count(keys[i], line);
						}
					}
					
					fileStream.close();
					
				} else if (file.isDirectory && _skipFolder.indexOf(file.name) == -1) getStrictStats(file);
			}
		}
		
		private function count(needle:String, haystack:String):int {
			return haystack.split(needle).length - 1;
		}
		
		public override function toString():String {
			var answer:String;
			
			answer = log + "\n";
			answer += "\n\n===== STATISTICS ======\n\n"
			answer += "Files: " + numFiles.toString() + "\n";
			answer += "Lines: " + numLines.toString() + "\n";
			answer += "Lines (without empty lines): " + numUsedLines.toString() + "\n";
			
			answer += "\n\n===== KEYWORDS ======\n\n"
			for (var i:int = 0; i < keys.length; i++) {
				answer += keys[i] + ": " + values[i] + "\n";
			}
			
			return answer;
		}
		
		public function set fileTypes(value:Array):void {
			_fileTypes = value;
		}
		
		public function set keywords(value:Array):void {
			keys = value;
		}
		
		public function set skipFolder(value:Array):void {
			_skipFolder = value;
		}
	}
}
