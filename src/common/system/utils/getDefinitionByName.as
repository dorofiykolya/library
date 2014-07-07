package common.system.utils
{
	import flash.system.ApplicationDomain;
	import flash.utils.getDefinitionByName;
	
	/**
	 * ...
	 * @author dorofiy.com
	 */
	public function getDefinitionByName(applicationDomain:ApplicationDomain, name:String):Object
	{
		if (applicationDomain.hasDefinition(name))
		{
			return applicationDomain.getDefinition(name);
		}
		return null;
	}

}