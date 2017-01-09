public class FloorStatusCTR {

    public Map<mightymani__Floor__c, List<mightymani__Apartment__c>> floorMap {get; set;}
    public String roomId {get; set;}
    
    public FloorStatusCTR(){
        floorMap = new Map<mightymani__Floor__c, List<mightymani__Apartment__c>>();
        for(Floor__c fl : [SELECT Id, Name, (SELECT Id, mightymani__Room_Number__c, mightymani__Status__c FROM mightymani__Apartments__r ORDER BY mightymani__Room_Number__c) FROM mightymani__Floor__c]){
            floorMap.put(fl, fl.mightymani__Apartments__r);
        }
    }
    
    public PageReference UpdateRoomStatus() {
        System.debug('Room Id :::::::::::::' + roomId);
        return null;
    }
}