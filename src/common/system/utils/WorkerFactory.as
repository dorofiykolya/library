package common.system.utils
{
	import com.codeazur.as3swf.data.SWFSymbol;
	import com.codeazur.as3swf.SWF;
	import com.codeazur.as3swf.tags.ITag;
	import com.codeazur.as3swf.tags.TagDoABC;
	import com.codeazur.as3swf.tags.TagEnableDebugger2;
	import com.codeazur.as3swf.tags.TagEnd;
	import com.codeazur.as3swf.tags.TagFileAttributes;
	import com.codeazur.as3swf.tags.TagShowFrame;
	import com.codeazur.as3swf.tags.TagSymbolClass;
	import common.system.ClassType;
	import flash.display.Sprite;
	import flash.system.Worker;
	import flash.system.WorkerDomain;
	import flash.utils.ByteArray;
	
	/**
	 * ...
	 * @author dorofiy.com
	 */
	public class WorkerFactory
	{
		
		public function WorkerFactory()
		{
		
		}
		
		public static function get isSupported():Boolean
		{
			return Worker.isSupported;
		}
		
		public static function createWorker(type:Class, bytes:ByteArray, debug:Boolean = true, domain:WorkerDomain = null):Worker
		{
			if (!(type == Sprite || ClassType.isSubclassOf(type, Sprite)))
			{
				throw new ArgumentError(ClassType.getQualifiedClassName(WorkerFactory) + ", type must extend the " + ClassType.getQualifiedClassName(Sprite));
			}
			
			var swf:SWF = new SWF(bytes);
			var tags:Vector.<ITag> = swf.tags;
			var className:String = ClassType.getQualifiedClassName(type).replace(/::/g, ".");
			var abcName:String = className.replace(/\./g, "/");
			var classTag:ITag;
			
			for each (var tag:ITag in tags)
			{
				if (tag is TagDoABC && TagDoABC(tag).abcName == abcName)
				{
					classTag = tag;
					break;
				}
			}
			
			if (classTag)
			{
				swf = new SWF();
				swf.version = 17;
				swf.tags.push(new TagFileAttributes());
				if (debug)
					swf.tags.push(new TagEnableDebugger2());
				swf.tags.push(classTag);
				var symbolTag:TagSymbolClass = new TagSymbolClass();
				symbolTag.symbols.push(SWFSymbol.create(0, className));
				swf.tags.push(symbolTag);
				swf.tags.push(new TagShowFrame());
				swf.tags.push(new TagEnd());
				
				var swfBytes:ByteArray = new ByteArray();
				swf.publish(swfBytes);
				swfBytes.position = 0;
				
				if (!domain)
					domain = WorkerDomain.current;
				
				return domain.createWorker(swfBytes);
			}
			return null;
		}
	}
}