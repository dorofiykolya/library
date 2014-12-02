package common.system
{
    import flash.system.ApplicationDomain;
    import flash.utils.Dictionary;
    
    /**
     * ...
     * @author dorofiy.com
     */
    public dynamic class Cache extends TypeObject
    {
        //--------------------------------------------------------------------------
        //	PRIVATE VARIABLES STATIC
        //--------------------------------------------------------------------------
        
        private static var _instance:Cache;
        
        //--------------------------------------------------------------------------
        //	INTERNAL VARIABLES 
        //--------------------------------------------------------------------------
        
        internal var typeCache:Dictionary;
        internal var enumValueCache:Dictionary;
        internal var enumCollectionCache:Dictionary;
        internal var storage:Dictionary;
        internal var storageValues:Dictionary;
        
        //----------------------------------
        //	CONSTRUCTOR
        //----------------------------------
        
        public function Cache()
        {
            typeCache = new Dictionary();
            enumValueCache = new Dictionary();
            enumCollectionCache = new Dictionary();
            storage = new Dictionary();
            storageValues = new Dictionary();
        }
        
        //--------------------------------------------------------------------------
        //     
        //	PUBLIC METHODS 
        //     
        //--------------------------------------------------------------------------
        
        public function clear():void
        {
            clearDictionary(this);
            clearDictionary(typeCache);
            clearDictionary(enumValueCache);
            clearDictionary(enumCollectionCache);
            clearDictionary(storage);
            clearDictionary(storageValues);
        }
        
        public function setValue(key:Object, value:Object):Object
        {
            storageValues[key] = value;
            return value;
        }
        
        public function removeValue(key:Object):void
        {
            delete storageValues[key];
        }
        
        public function hasValue(key:Object):Boolean
        {
            return key in storageValues;
        }
        
        public function getValue(key:Object):*
        {
            return storageValues[key];
        }
        
        public function setStorageValue(storageName:String, key:Object, value:Object):Object
        {
            getStorage(storageName).storageValues[key] = value;
            return value;
        }
        
        public function getStorageValue(storageName:String, key:Object):*
        {
            return getStorage(storageName).storageValues[key];
        }
        
        public function hasStorageValue(storageName:String, key:Object):Boolean
        {
            return key in getStorage(storageName).storageValues;
        }
        
        public function getStorage(storageName:String):Cache
        {
            var result:Cache = storage[storageName];
            if (result == null)
            {
                result = new Cache();
                storage[storageName] = result;
            }
            return result;
        }
        
        //--------------------------------------------------------------------------
        //     
        //	INTERNAL METHODS 
        //     
        //--------------------------------------------------------------------------
        
        internal function getTypeCache(type:Class, isFactory:Boolean):Type
        {
            var kind:TypeCache = this.typeCache[type];
            if (kind)
            {
                if (isFactory)
                {
                    return kind.factoryType;
                }
                return kind.classType;
            }
            return null;
        }
        
        internal function setTypeCache(type:Class, isFactory:Boolean, value:Type):void
        {
            var kind:TypeCache = this.typeCache[type];
            if (kind == null)
            {
                kind = new TypeCache();
                this.typeCache[type] = kind;
            }
            if (isFactory)
            {
                kind.factoryType = value;
            }
            else
            {
                kind.classType = value;
            }
        }
        
        internal function getEnum(enumClass:Class, value:Object):Enum
        {
            var classDic:Dictionary = enumValueCache[enumClass];
            if (classDic)
            {
                return classDic[value] as Enum;
            }
            return null;
        }
        
        internal function containsEnumClass(enumClass:Class):Boolean
        {
            return enumClass in enumValueCache;
        }
        
        internal function setEnumClass(enumClass:Class):void
        {
            if ((enumClass in enumValueCache) == false)
            {
                enumValueCache[enumClass] = new Dictionary();
            }
        }
        
        internal function getEnums(enumClass:Class):Vector.<Enum>
        {
            return enumCollectionCache[enumClass];
        }
        
        internal function setEnums(enumClass:Class, value:Vector.<Enum>):void
        {
            enumCollectionCache[enumClass] = value;
        }
        
        internal function setEnum(enumClass:Class, value:Object, current:Enum):void
        {
            var classDic:Dictionary = enumValueCache[enumClass];
            if (classDic == null)
            {
                classDic = new Dictionary();
                enumValueCache[enumClass] = classDic;
            }
            classDic[value] = current;
        }
        
        //--------------------------------------------------------------------------
        //     
        //	PRIVATE METHODS 
        //     
        //--------------------------------------------------------------------------
        
        private function clearDictionary(value:Object):void
        {
            for (var key:Object in value)
            {
                delete value[key];
            }
        }
        
        //----------------------------------
        //	INSTANCE
        //----------------------------------
        
        public static function get cache():Cache
        {
            return _instance ? _instance : _instance = new Cache();
        }
    }
}
import common.system.Type;
class TypeCache
{
    public var factoryType:Type;
    public var classType:Type;
}