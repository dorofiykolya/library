package common.system.reflection
{
	import common.system.ClassType;
    import common.system.TypeObject;
    
    /**
     * ...
     * @author dorofiy.com
     */
    public class Member extends TypeObject
    {
		internal var _type:Class;
        internal var _name:String;
        internal var _metaData:Vector.<MetaData>;
        internal var _typeName:String;
        internal var _nameSpace:Namespace;
        internal var _memberType:MemberType;
        
        public function Member()
        {
        
        }
        
        public function getMetaData(name:String = null, result:Vector.<MetaData> = null):Vector.<MetaData>
        {
            result ||= new Vector.<MetaData>();
            if (_metaData)
            {
                for each (var item:MetaData in _metaData)
                {
                    if (name == null || item._name == name)
                    {
                        result[result.length] = item;
                    }
                }
            }
            return result;
        }
        
        public function get memberType():MemberType
        {
            return _memberType;
        }
        
        public function get name():String
        {
            return _name;
        }
        
        public function get metaData():Vector.<MetaData>
        {
            return _metaData ? _metaData.slice() : null;
        }
        
        public function get type():Class
        {
			if (_type != null) 
			{
				return _type;
			}
			if (_typeName != null)
			{
				_type = internalGetType(_typeName);
				return _type;
			}
            return null;
        }
        
        public function get nameSpace():Namespace
        {
            return _nameSpace;
        }
		
		internal function internalGetType(value:Object):Class
		{
			var type:String = value as String;
			if(type == null)
			{
				type = value.type;
			}
			if (type == "*")
			{
				return null;
			}
			return Class(ClassType.getDefinitionByName(type));
		}
    }
}