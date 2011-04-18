package com.mathiaspaumgarten.utils {
	
	import flash.events.Event;
	
	public class ScanEvent extends Event {

		public static var COMPLETE:String = "ScanComplete";

		private var stats:String;

		public function ScanEvent(type:String, stats:String, bubbles:Boolean = true, cancable:Boolean = true) {
			super(type, bubbles, cancable);
			
			this.stats = stats;
		}
		
		public function get statistic():String {
			return stats;
		}
	}
}
