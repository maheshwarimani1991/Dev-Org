public class ManagerUtility{
    private List<UserRole> userRoles = new List<UserRole>();
    private List<User> users;
        
    /*
    * @param Id - Its the current user id to be got from UserInfo.getUserId() 
    */
    public List<user> findUserRoleHierarchy(Id currentUserId){
        List<user> returnVal = null;
        // 
        Id userRoleId = [SELECT UserRoleId FROM User where id=:currentUserId][0].UserRoleId;

        System.debug(+ UserRoleId);

        invokeSubRoles(userRoleId);
        if(!userRoles.isEmpty()){
            Set<Id> userRoleIds = new Set<Id>();
            for(UserRole ur: userRoles){
                userRoleIds.add(ur.id);
            }
             users = [SELECT id, name, lastName, isActive FROM User WHERE UserRoleId IN: userRoleIds];
           // system.debug('The users below the current user are: '+users);
            returnVal = users;
        }
        return returnVal;
    }

    private void invokeSubRoles(Id roleId){
        UserRole userRoleObj = null;
        try{
            userRoleObj = [SELECT id, ParentRoleId FROM UserRole WHERE ParentRoleId =: roleId and ParentRoleId <> null][0];
        }catch(Exception ex){}
        
        if(userRoleObj!= null){
            userRoles.add(userRoleObj);
            invokeSubRoles(userRoleObj.id);
        }
    }
}