package common.composite
{
    import common.system.IDisposable;
    import common.system.TypeObject;
    
    /**
     * ...
     * @author dorofiy.com
     */
    public class ComponentController extends TypeObject implements IBehaviourController, IDisposable
    {
        //--------------------------------------------------------------------------
        //     
        //	INTERNAL VARIABLES 
        //     
        //--------------------------------------------------------------------------
        
        internal var _entity:Entity;
        
        //--------------------------------------------------------------------------
        //     
        //	PRIVATE VARIABLES 
        //     
        //--------------------------------------------------------------------------
        
        private var _collection:ComponentControllerCollection;
        
        //----------------------------------
        //	CONSTRUCTOR
        //----------------------------------
        
        public function ComponentController(target:Entity)
        {
            _entity = target;
            _collection = new ComponentControllerCollection();
        }
        
        //--------------------------------------------------------------------------
        //     
        //	PUBLIC METHODS 
        //     
        //--------------------------------------------------------------------------
        
        /* INTERFACE common.entity.IBehaviourController */
        
        public function add(behaviour:ComponentBehaviour):ComponentBehaviour
        {
            var invokerController:ComponentController = behaviour._controller;
            if (invokerController != this)
            {
                if (invokerController)
                {
                    invokerController.remove(behaviour);
                }
                _collection.add(behaviour);
                behaviour._controller = this;
                behaviour.attachInvoker();
            }
            return behaviour
        }
        
        public function remove(behaviour:ComponentBehaviour):ComponentBehaviour
        {
            _collection.remove(behaviour);
            behaviour._controller = null;
            behaviour.detachInvoker();
            return behaviour;
        }
        
        /* INTERFACE common.system.IDisposable */
        
        public function dispose():void
        {
            _collection.dispose();
        }
    }
}