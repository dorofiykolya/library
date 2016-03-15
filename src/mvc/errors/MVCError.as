package mvc.errors
{
    public class MVCError extends Error
    {
        public static const DUPLICATE_COMMAND:String = "Command with name {name} already registered in MVC";
        public static const COMMAND_NOT_FOUND:String = "Command {name} not registered in MVC";

        public function MVCError(message:String, id:int = -1)
        {
            super(message, id);
        }
    }
}
