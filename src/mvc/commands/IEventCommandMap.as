package mvc.commands
{
    
    /**
     * ...
     * @author dorofiy.com
     */
    public interface IEventCommandMap
    {
        function map(key:Object, eventType:Class = null):ICommandMapper;
        function unmap(key:Object, eventType:Class = null):ICommanMapperRemove;
    }
}