package common.system.collection
{
	import common.system.IComparable;
	
	/**
	 * ...
	 * @author dorofiy.com
	 */
	public class PriorityQueueComparable
	{
		private var _data:Vector.<IComparable>;
		
		public function PriorityQueueComparable()
		{
			_data = new Vector.<IComparable>();
		}
		
		public function enqueue(item:IComparable):void
		{
			_data.push(item);
			var ci:int = _data.length - 1;
			while (ci > 0)
			{
				var pi:int = (ci - 1) / 2;
				if (_data[ci].compareTo(_data[pi]) >= 0)
				{
					break;
				}
				var tmp:IComparable = _data[ci];
				_data[ci] = _data[pi];
				_data[pi] = tmp;
				ci = pi;
			}
		}
		
		public function dequeue():IComparable
		{
			var li:int = _data.length - 1;
			var frontItem:IComparable = _data[0];
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
				if (rc <= li && _data[rc].compareTo(_data[ci]) < 0)
					ci = rc;
				if (_data[pi].compareTo(_data[ci]) <= 0)
				{
					break;
				}
				var tmp:IComparable = _data[pi];
				_data[pi] = _data[ci];
				_data[ci] = tmp;
				pi = ci;
			}
			return frontItem;
		}
		
		public function peek():IComparable
		{
			var frontItem:IComparable = _data[0];
			return frontItem;
		}
		
		public function get count():int
		{
			return _data.length;
		}
	
	}

}