package  {
	
	import flash.display.MovieClip;
	import fl.controls.Button;
	import fl.controls.TextArea;
	import fl.controls.CheckBox;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.filesystem.File;
	import com.mathiaspaumgarten.utils.Scan;
	
	public class Main extends MovieClip {
		
		/* ---- UI ---- */
		public var browseButton:Button;
		public var scanButton:Button;
		public var outputField:TextArea;
		public var skipField:TextArea;
		public var XMLbox:CheckBox;
		public var ASbox:CheckBox;
		public var MXML:CheckBox;
		
		private var baseFile:File;
		private var boxes:Array;
		
		public function Main() {
			super();
			
			boxes = [XMLbox, ASbox, PBKbox, MXMLbox, JSbox];
			
			browseButton.addEventListener(MouseEvent.CLICK, onBrowseClick);
			scanButton.addEventListener(MouseEvent.CLICK, onScanClick);
		}
		
		private function onBrowseClick(event:MouseEvent):void {
			baseFile = new File();
			
			baseFile.addEventListener(Event.SELECT, onFileSelected);
			baseFile.addEventListener(Event.CANCEL, onFileCancel);
			baseFile.browseForDirectory("Choose a directory as root directory of your project.");
		}
		
		private function onFileSelected(event:Event):void {
			pathField.text = baseFile.nativePath;
		}
		
		private function onFileCancel(event:Event):void {
			baseFile = null;
		}
		
		private function onScanClick(event:MouseEvent):void {
			if (!baseFile) {
				outputField.text = "There is no directory to scan! Browse for a directory!"
				return;
			}
			
			var scanner:Scan = new Scan();
			scanner.fileTypes = fileFilter;
			scanner.keywords = ["function ", "class ", "if ", "switch ", "package "];
			scanner.skipFolder = skipFilter;
			
			outputField.text = scanner.getStats(baseFile);
		}
		
		private function get fileFilter():Array {
			var returnArray:Array = [];
			
			for each(var box:CheckBox in boxes) {
				if (box.selected) returnArray.push(box.label);
			}
			
			return returnArray;
		}
		
		private function get skipFilter():Array {
			return skipField.text.split(" ").join("").split(",");
		}
	}
	
}
