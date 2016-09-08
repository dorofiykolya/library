package common.system.collection
{
	
	/**
	 * ...
	 * @author dorofiy.com
	 */
	public class PriorityQueue
	{
		private var _data:Vector.<*>;
		private var _compare:Function;
		
		/**
		 * 
		 * @param function compareTo(left:*, right:*):int;
		 */
		public function PriorityQueue(compare:Function = null)
		{
			_data = new Vector.<*>();
			_compare = compare;
		}
		
		public function enqueue(item:*):void
		{
			_data.push(item);
			var ci:int = _data.length - 1;
			while (ci > 0)
			{
				var pi:int = (ci - 1) / 2;
				if (compareTo(_data[ci], _data[pi]) >= 0)
				{
					break;
				}
				var tmp:* = _data[ci];
				_data[ci] = _data[pi];
				_data[pi] = tmp;
				ci = pi;
			}
		}
		
		public function dequeue():*
		{
			var li:int = _data.length - 1;
			var frontItem:* = _data[0];
			_data[0] = _data[li];
			_data.removeAt(li);
			
			--li;
			var pi:int = 0;
			while (true)
			{
				var ci:int = pi * 2 + 1;
				if (ci > li)
				{
					break;
				}
				var rc:int = ci + 1;
				if (rc <= li && compareTo(_data[rc], _data[ci]) < 0)
					ci = rc;
				if (compareTo(_data[pi], _data[ci]) <= 0)
				{
					break;
				}
				var tmp:* = _data[pi];
				_data[pi] = _data[ci];
				_data[ci] = tmp;
				pi = ci;
			}
			return frontItem;
		}
		
		public function peek():*
		{
			var frontItem:* = _data[0];
			return frontItem;
		}
		
		public function get count():int
		{
			return _data.length;
		}
		
		private function compareTo(left:*, right:*):int
		{
			if (_compare != null)
			{
				return _compare(left, right);
			}
			if (left > right) return 1;
			if (left < right) return -1;
			return 0;
		}
	}

}