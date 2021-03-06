package common.system.reflection
{
    import common.system.TypeObject;
    
    /**
     * ...
     * @author dorofiy.com
     */
    public class MetaData extends TypeObject
    {
        internal var _name:String;
        internal var _arguments:Vector.<Argument>;
        
        public function MetaData()
        {
        
        }
        
        public function get name():String
        {
            return _name;
        }
        
        public function get arguments():Vector.<Argument>
        {
            return _arguments.slice();
        }
        
        public function getArgument(name:String):Vector.<Argument>
        {
            var result:Vector.<Argument> = new Vector.<Argument>();
            for each (var arg:Argument in _arguments)
            {
                if (arg._name == name)
                {
                    result[result.length] = arg;
                }
            }
            return result;
        }
    }
}