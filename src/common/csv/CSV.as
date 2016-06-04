package common.csv
{
	import common.system.Assert;
	import common.system.ClassType;
	import common.system.Type;
	import common.system.collection.IEnumerator;
	import common.system.reflection.Member;
	import common.system.reflection.MemberType;
	
	/**
	 * ...
	 * @author dorofiy.com
	 */
	public class CSV implements IEnumerator
	{
		private var _lineDelim:String;
		private var _valueDelim:String;
		private var _toType:Class;
		private var _type:Type;
		
		private var _lines:Array;
		private var _properties:Vector.<Member>;
		private var _line:int;
		private var _result:Vector.<Object>;
		
		private var _iterator:int;
		
		public function CSV(value:String, lineDelim:String, valueDelim:String, toType:Class)
		{
			_toType = toType;
			_valueDelim = valueDelim;
			_lineDelim = lineDelim;
			_line = 0;
			
			_type = ClassType.getInstanceType(_toType);
			
			if (isNotType(_type, false) || (_type.isVector && (isNotType(ClassType.getInstanceType(_type.vectorElementType), true))))
			{
				throw new ArgumentError("toType can't be Array, Object, Dictionary or primitive such as int, string etc...");
			}
			
			_result = new Vector.<Object>();
			_properties = new Vector.<Member>();
			
			parse(value);
			reset();
		}
		
		public function get count():int
		{
			return _result.length;
		}
		
		public function get current():Object
		{
			return _result[_iterator];
		}
		
		public function reset():void
		{
			_iterator = -1;
		}
		
		public function moveNext():Boolean
		{
			_iterator++;
			return _iterator < _result.length;
		}
		
		private function parse(value:String):void
		{
			_lines = value.split(_lineDelim);
			for (var i:int = 0; i < _lines.length; i++)
			{
				_lines[i] = String(_lines[i]).split(_valueDelim);
			}
			
			readProperties();
			readTypes();
			while (_line < _lines.length)
			{
				readLine();
			}
		}
		
		private function readProperties():void
		{
			if (!_type.isVector)
			{
				var line:Array = _lines[_line];
				
				for each (var property:String in line)
				{
					var member:Member = _type.getMember(property);
					if (member != null && (member.memberType == MemberType.FIELD || member.memberType == MemberType.PROPERTY))
					{
						_properties.push(member);
					}
					else
					{
						_properties.push(null);
					}
				}
			}
			_line++;
		}
		
		private function readTypes():void
		{
			var line:Array = _lines[_line];
			
			if (!_type.isVector)
			{
				Assert.isTrue(line.length == _properties.length);
				
				for (var i:int = 0; i < line.length; i++)
				{
					if (_properties[i])
					{
						var propertyType:Class = _properties[i].type;
						var csvType:Class = Class(ClassType.getDefinitionByName(line[i]));
						Assert.isTrue(propertyType == csvType);
					}
				}
			}
			_line++;
		}
		
		private function readLine():void
		{
			var result:Object = _type.newInstance();
			var line:Array = _lines[_line];
			var i:int = 0;
			if (!_type.isVector)
			{
				if (line.length == _properties.length)
				{
					for (i = 0; i < line.length; i++)
					{
						var member:Member = _properties[i];
						if (member)
						{
							result[member.name] = cast(line[i], member.type);
						}
					}
					_result.push(result);
				}
			}
			else
			{
				var elementType:Class = _type.vectorElementType;
				for (i = 0; i < line.length; i++)
				{
					result[i] = cast(line[i], elementType);
				}
				_result.push(result);
			}
			
			_line++;
		}
		
		private function cast(value:String, toType:Class):Object
		{
			if (toType == Number && value.indexOf(",") != -1)
			{
				value = value.replace(",", ".");
			}
			return ClassType.cast(value, toType);
		}
		
		private function isNotType(type:Type, isVector:Boolean):Boolean
		{
			return type.isArray || type.isDictionary || (type.isPrimitive && !isVector);
		}
	}
}