package common.system.reflection
{
    import common.system.TypeObject;
    
    /**
     * ...
     * @author dorofiy.com
     */
    public class Member extends TypeObject
    {
        internal var _name:String;
        internal var _metaData:Vector.<MetaData>;
        internal var _type:Class;
        internal var _nameSpace:Namespace;
        internal var _memberType:MemberType;
        
        public function Member()
        {
        
        }
        
        public function getMetaData(name:String = null):Vector.<MetaData>
        {
            var result:Vector.<MetaData> = new Vector.<MetaData>();
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
            return _type;
        }
        
        public function get nameSpace():Namespace
        {
            return _nameSpace;
        }
    }
}