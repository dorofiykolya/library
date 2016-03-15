package mvc.commands 
{
    
    /**
     * ...
     * @author dorofiy.com
     */
    public interface ICommandMapper 
    {
        function add(commandType:Class, oneTime:Boolean = false):void;
    }
}