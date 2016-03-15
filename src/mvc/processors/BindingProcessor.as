package mvc.processors
{
    import common.context.links.Link;
	import common.context.processors.IProcessor;
    import mvc.bindings.Binding;
    import mvc.constants.Args;
    import mvc.constants.Tags;
    import common.system.ClassType;
    import common.system.IDisposable;
    import common.system.reflection.Access;
    import common.system.reflection.Argument;
    import common.system.reflection.Member;
    import common.system.reflection.MetaData;
    import common.system.text.StringUtil;
    import common.system.Type;
    import common.system.utils.formatString;
    import flash.utils.Dictionary;
    
    /**
     * ...
     * @author dorofiy.com
     */
    public class BindingProcessor implements IProcessor, IDisposable
    {
        private var _binding:Binding;
        private var _types:Dictionary;
        
        public function BindingProcessor(binding:Binding)
        {
            _binding = binding;
            _types = new Dictionary();
        }
        
        /* INTERFACE com.okapp.mvc.processors.IProcessor */
        
        public function setup(bean:Link):void
        {
            if (StringUtil.isNotEmpty(bean.name))
            {
                _types[bean.name] = bean.instance;
            }
        }
        
        public function process(bean:Link):void
        {
            var type:Type = ClassType.getType(bean.instance);
            bindMembers(bean.instance, Vector.<Member>(type.fields));
            bindMembers(bean.instance, Vector.<Member>(type.getProperties(Access.READWRITE)));
            bindMembers(bean.instance, Vector.<Member>(type.getProperties(Access.WRITEONLY)));
        }
        
        /* INTERFACE common.system.IDisposable */
        
        public function dispose():void
        {
            _types = null;
        }
        
        private function bindMembers(instance:Object, members:Vector.<Member>):void
        {
            var metadatas:Vector.<MetaData>;
            var args:Vector.<Argument>;
            for each (var member:Member in members)
            {
                metadatas = member.getMetaData(Tags.BINDING);
                if (metadatas.length != 0)
                {
                    for each (var meta:MetaData in metadatas)
                    {
                        args = meta.getArgument(Args.SOURCE);
                        for each (var arg:Argument in args)
                        {
                            var path:String = arg.value;
                            var pathArray:Array = path.split(".");
                            if (pathArray.length != 2)
                            {
                                throw new ArgumentError(formatString("ArgumentError:{0}.process", ClassType.getQualifiedClassName(this)));
                            }
                            var from:Object = _types[pathArray[0]];
                            if (from)
                            {
                                _binding.bind(from, pathArray[1], instance, member.name);
                                _binding.update(from, pathArray[1]);
                            }
                        }
                    }
                }
            }
        }
    }
}