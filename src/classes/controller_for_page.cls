public with sharing class controller_for_page {

    public List<Account> display_list = new List<Account>(); //list for all Account records and fields
    public List<String> current_list = new List<String>(); //list for holding many record Ids
    public List<String> next_list = new List<String>(); //list for holding record Ids that are after the current records
    public List<String> previous_list = new List<String>(); //list for holding record Ids that are before the current records
    Integer list_size = 50; //number of records to display on the page
    
    //initiates the controller and displays some initial data when the page loads
    public controller_for_page() {
        Integer record_counter = 0; //counter
        for (Account a : [SELECT Id FROM Account ORDER BY Name LIMIT 10000]) { //for a bunch of accounts
            if (record_counter < list_size) { //if we have not yet reached our maximum list size
                current_list.add(a.Id); //add the Id of the record to our current list
            } else { //otherwise, we reached our list size maximum
                next_list.add(a.Id); //add the Id to our next_list
            }
            record_counter++;
        }
    }
    
    public List<Account> getRecordsToDisplay() {
        Set<String> record_ids = new Set<String>(); //set for holding distinct Ids
        Boolean records_added = record_ids.addAll(current_list); //add all the records from our current_list list
        display_list = [SELECT AccountNumber, Id, Name, OwnerId, Phone, Site, Type FROM Account WHERE Id in : record_ids ORDER BY Name]; //query for the details of the records you want to display
        return display_list; //return the list of full records
    }
    
    public Integer getCurrentSize() {
        return current_list.size(); //number of record in current_list
    }
    
    public Integer getPrevSize() {
        return previous_list.size(); //number of record in previous_list
    }
    
    public Integer getNextSize() {
        return next_list.size(); //number of record in next_list
    }

}