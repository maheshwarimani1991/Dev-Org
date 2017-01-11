/* 
 Name          : uploadCSVcontroller
 Description   : uploadCSVcontroller Apex Class function is to allow Bulk Upload by VF page. 
                 
 Author        : Himanshu Maheshwari (Compro Technologies)
 Creation Date : 04-Dec-2014
 Modified Date : 02-Mar-2015

************************************************************ 
   Dear maintainer:
 
   Once you are done trying to 'optimize' this routine,
   and have realized what a terrible mistake that was,
   please increment the following counter as a warning
   to the next guy:
  
   total_hours_wasted_here = 42

************************************************************
*/
public class uploadCSVcontroller {
    public Blob contentFile { get; set; }
    public String nameFile { get; set; }
    public Integer rowCount { get; set; }
    public Integer SuccessRowCount { get; set; }
    public Integer FailureRowCount { get; set; }
    public Integer inputCharacterMax = 100000;
    public List<String> lines = new List<String>();
    public List <ErrorWrapper> errList {get;set;}
    public String objName {get; set;}
    public Attachment AttachmentSuccessObj {get; set;}
    public Attachment AttachmentErrorObj {get; set;}
    
    public void Results() {
        errList = new List <ErrorWrapper>(); 
        List<Account> parsedCSV = new List<Account>();
        rowCount = 0;
        SuccessRowCount = 0;
        FailureRowCount = 0;
        System.debug('~~~~'+contentFile);
        if (contentFile != null){
            String fileString = '';
            try{
                fileString = contentFile.toString();
            }catch(Exception e){
                String hexString = EncodingUtil.convertToHex(contentFile);
                System.assertEquals(0, hexString.length() & 1);
                final Integer bytesCount = hexString.length() >> 1;
                String[] bytes = new String[bytesCount];
                for(Integer i = 0; i < bytesCount; ++i)
                    bytes[i] =  hexString.mid(i << 1, 2);
                fileString = EncodingUtil.urlDecode('%' + String.join(bytes, '%'), 'UTF-8');  
            }          
            system.debug('&&&&'+fileString);
            
            if(objName == 'Feasibilty')
                parseCSV(fileString, false);
            //else if(objName == 'Feasibility Task')
            //    parseCSVFT(fileString, false);
        }
        lines = new List<String>();
    }    
    
    public void parseCSV(String contents,Boolean skipHeaders) {
        // Get All custom Setting header and field API Name.
        Map<String, CSV_Mapping_Feasibility_Request__c> csvHeaderMap = CSV_Mapping_Feasibility_Request__c.getAll();
        Map<Integer, Boolean> checkHeaderMap = new Map<Integer, Boolean>();
        
        Map<String, Schema.sObjectField> ftype = Schema.SObjectType.Account.fields.getMap();
        List <Account> fList = new List <Account>();
        List<List<String>> allFields = new List<List<String>>();
        
        Integer pivot = Contents.indexOf( '\r', Integer.valueOf(Math.floor(Contents.length()/2)) );
        
        if ( pivot > inputCharacterMax ) {
            divideString(contents);
        }
        else {
            contents = contents.replaceAll(',"""',',"DBLQT').replaceall('""",','DBLQT",');
            contents = contents.replaceAll('""','DBLQT');
            lines = contents.split('\r');
        }
        
        //CSV for Success and error files.
        String csvSuccessFileString = '';
        String csvErrorFileString = '';
        
        Integer num = 0;
        boolean header = true;
        List <String> fieldapi = new List <String>();
        for(String line: lines) {
            if(num != 0)
                header = false;    
            // check for blank CSV lines (only commas)
            if (line.replaceAll(',','').trim().length() == 0)    continue;               //break;
            
            System.debug('Line:::::....'+Line);
            List<String> fields = line.split(',');
            List<String> cleanFields = new List<String>();
            String compositeField;
            Boolean makeCompositeField = false;
            integer i = 0;
            Account f = new Account();
            
            for(String field: fields) {
                if(header == true){
                    String hName = field.replaceAll('DBLQT','"');
                    if(csvHeaderMap.get(hName) != NULL){
                        fieldapi.add(csvHeaderMap.get(hName).API_Name__c);
                        checkHeaderMap.put(i,TRUE);
                    }else{
                        checkHeaderMap.put(i,FALSE);
                    }
                    i++;
                }
                else{
                    if(checkHeaderMap.get(i)){
                        if (field.startsWith('"') && field.endsWith('"')) {
                            String str = field.replaceAll('"','');
                            str = str.replaceAll('DBLQT','"');
                            f.put(fieldapi[i], str);
                            i++;
                        } else if (field.startsWith('"')) {
                            makeCompositeField = true;
                            compositeField = field;
                        } else if (field.endsWith('"')) {
                            compositeField += ',' + field;
                            compositeField = compositeField.replaceAll('"','');
                            f.put(fieldapi[i], compositeField.replaceAll('DBLQT','"'));
                            makeCompositeField = false;
                            i++;
                        } else if (makeCompositeField) {
                            compositeField +=  ',' + field;
                        } else {
                            /*if(fieldapi[i] == 'Bandwidth_Value__c'){
                                if(field != '')
                                    f.Bandwidth_Lookup__r = new Bandwidth__c( Unique__c = field);
                            }else if(fieldapi[i] == 'F_Feasibility_Pincode__c'){
                                if(field != '')
                                    f.F_Feasibility_Pincode__r = new Feasibility_Location__c( Unique__c = field);
                            }else if(fieldapi[i] == 'T_Feasibility_Pincode__c'){
                                if(field != '')
                                    f.T_Feasibility_Pincode__r = new Feasibility_Location__c( Unique__c = field);
                            }else if(fieldapi[i] == 'Airtel_POP__c'){
                                if(field != '')
                                    f.Airtel_POP_Address__r = new Airtel_POP__c( External_ID__c = field);
                            }else if(fieldapi[i] == 'Opportunity__c'){
                                if(field != '')
                                    f.Opportunity__r = new Opportunity( External_Id__c = field);
                            }else{*/
                                String typ;
                                try{
                                    typ = String.valueOf(ftype.get(fieldapi[i]).getDescribe().getType());
                                }catch(Exception e){
                                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'You have imported the incorrect csv.'));    
                                    //break;
                                    return;
                                }
                                if(typ=='INTEGER'){
                                    f.put(fieldapi[i], integer.valueOf(field.replaceAll('DBLQT','"')));
                                } else if(typ=='BOOLEAN'){
                                    f.put(fieldapi[i], Boolean.valueOf(field.replaceAll('DBLQT','"')));
                                } else if(typ=='DOUBLE'){
                                    if(field.replaceAll('DBLQT','"') != '')
                                        f.put(fieldapi[i], Double.valueOf(field.replaceAll('DBLQT','"')));
                                } else if(typ=='DECIMAL'){
                                    if(field.replaceAll('DBLQT','"') != '')
                                        f.put(fieldapi[i], Decimal.valueOf(field.replaceAll('DBLQT','"')));
                                } else if(typ=='CURRENCY'){
                                    if(field.replaceAll('DBLQT','"') != '')
                                        f.put(fieldapi[i], Decimal.valueOf(field.replaceAll('DBLQT','"')));
                                } else if(typ=='DATE'){
                                    if(field.replaceAll('DBLQT','"') != '')
                                        f.put(fieldapi[i], date.parse(field.replaceAll('DBLQT','"')));
                                } else if(typ=='DATETIME'){
                                    if(field.replaceAll('DBLQT','"') != '')
                                        f.put(fieldapi[i], datetime.valueOf(field.replaceAll('DBLQT','"')));
                                } else{
                                    f.put(fieldapi[i], field.replaceAll('DBLQT','"'));
                                }
                            //}
                            i++;
                        }
                    }
                }
            }
            if(num !=0 )
                fList.add(f);
            num++;
        }
        System.debug('Feasibility__c-=-=---'+fList);
        
        //Schema.SObjectField f = Account.Fields.Account_Unique_Id__c;
        //Database.UpsertResult[] srList = Database.upsert(accList,f,false);
        Database.UpsertResult[] srList = Database.upsert(fList,false);

        //Query all new created FR's so FR # can be included in Success file
        Set<Id> frIdSet = new Set<Id>();

        for (Database.UpsertResult sr : srList)
            frIdSet.add(sr.getId());

        Map<Id, Account> frSuccessMap = new Map<Id, Account>([SELECT Id, Name FROM Account WHERE Id IN :frIdSet]);

        
        integer i = 0;
        
        // Adding Success and Error Header Name to CSV file
        csvSuccessFileString = lines[0] + ', Feasibilty #, Salesforce Id, Status';
        csvErrorFileString = lines[0] + ',Error,Status';
        
        // Iterate through each returned result
        for (Database.UpsertResult sr : srList) {
            if (sr.isSuccess()) {
                //Adding Success rows in CSV success file with Salesforce Id and Status.
                csvSuccessFileString = csvSuccessFileString + lines[i+1] + ',' + frSuccessMap.get(sr.getId()).Name + ',' + sr.getId() + ',' + 'Success,';
                SuccessRowCount++;
            }
            else {
                FailureRowCount++;
                //Adding Error rows in CSV error file with Error and Status.
                csvErrorFileString = csvErrorFileString + lines[i+1] + ',' + '"' + sr.getErrors()[0].getMessage() + '"' + ',' + 'Error,';
                // Operation failed, so get all errors
                for(Database.Error err : sr.getErrors()) {
                    System.debug('The following error has occurred.');                    
                    System.debug(err.getStatusCode() + ': ' + err.getMessage());
                    System.debug('Account fields that affected this error: ' + err.getFields());
                    System.debug('Error in Row :::::::'+i);
                    System.debug('Error in Account :::::::'+fList[i]);
                    errList.add(new ErrorWrapper(i,String.valueOf(err.getStatusCode()),err.getMessage()));
                }
            }
            i++;
        }
        
        rowCount = fList.size();
        
        //Insert Bulk Upload record. 
        /*Bulk_Upload__c bu = new Bulk_Upload__c();
        bu.Ownerid = UserInfo.getUserId();
        bu.File_Name__c = nameFile.split('\\.')[0];
        bu.Status__c = 'Completed';
        bu.Success_Records__c = SuccessRowCount;
        bu.Failure_Records__c = FailureRowCount;
        bu.Total_Records__c = rowCount;
        bu.Upload_Type__c = objName;
        insert bu;*/
        
        
        //Generating Success and Error Blob from Success and error String.
        Blob csvSuccessBlob = Blob.valueOf(csvSuccessFileString);
        Blob csvErrorBlob = Blob.valueOf(csvErrorFileString);
        List<Attachment> attchList = new List<Attachment>();
        
        //Attaching Success and Error CSV File.
        AttachmentSuccessObj = new Attachment(Body = csvSuccessBlob, Name = 'success_'+ nameFile.split('\\.')[0] + '_' +System.now().format('yyyy-MMM-dd-hh-mm-ss') + '.csv');//, parentId = bu.Id);
        AttachmentErrorObj = new Attachment(Body = csvErrorBlob, Name = 'error_'+ nameFile.split('\\.')[0] + '_' +System.now().format('yyyy-MMM-dd-hh-mm-ss') + '.csv');//, parentId = bu.Id);
        
        attchList.add(AttachmentSuccessObj);
        attchList.add(AttachmentErrorObj);
        
        if(attchList.size() > 0)
            insert attchlist;
        
    }
    
    //For Feasibility Task.
    //public void parseCSVFT(String contents,Boolean skipHeaders) {
        
        // Get All custom Setting header and field API Name.
        /*Map<String, CSV_Mapping_Account> csvHeaderMap = CSV_Mapping_Account.getAll();
        Map<Integer, Boolean> checkHeaderMap = new Map<Integer, Boolean>();
                
        Map<String, Schema.sObjectField> ftype = Schema.SObjectType.Account.fields.getMap();
        List <Account> fTaskList = new List <Account>();
        List<List<String>> allFields = new List<List<String>>();
        
        Integer pivot = Contents.indexOf( '\r', Integer.valueOf(Math.floor(Contents.length()/2)) );
        
        if ( pivot > inputCharacterMax ) {
            divideString(contents);
        }
        else {
            contents = contents.replaceAll(',"""',',"DBLQT').replaceall('""",','DBLQT",');
            contents = contents.replaceAll('""','DBLQT');
      
            if(contents.contains('\r'))
                lines = contents.split('\r');
            else
                lines = contents.split('\n');
            
            
        }*/
        
        //CSV for Success and error files.
        /*String csvSuccessFileString = '';
        String csvErrorFileString = '';
        
        Integer num = 0;
        boolean header = true;
        List <String> fieldapi = new List <String>();
        for(String line: lines) {
            if(num != 0)
                header = false;    
        
            // check for blank CSV lines (only commas)
            if (line.replaceAll(',','').trim().length() == 0) continue;               //break;
            
            List<String> fields = line.split(',');
            List<String> cleanFields = new List<String>();
            String compositeField;
            Boolean makeCompositeField = false;
            integer i = 0;
            Account ft = new Account();
            
            for(String field: fields) {
                //System.debug('~~~~~~~~~~~~~~~~~~ohhhh yEss abhiii...'+field+'.......'+header);
                //if(i == 0 && header != true)
                //    field = field.substring(1,field.length());
                if(header == true){
                    String hName = field.replaceAll('"','');
                    hName = hName.replaceAll('DBLQT','"');
                    if(csvHeaderMap.get(hName) != NULL){
                         fieldapi.add(csvHeaderMap.get(hName).API_Name__c);
                        checkHeaderMap.put(i,TRUE);
                    }else{
                        checkHeaderMap.put(i,FALSE);
                    }
                    i++;
                }
                else{
                    if(checkHeaderMap.get(i)){                
                        if (field.startsWith('"') && field.endsWith('"')) {
                            String str = field.replaceAll('"','');
                            str = str.replaceAll('DBLQT','"');
                            ft.put(fieldapi[i], str);
                            i++;
                        } else if (field.startsWith('"')) {
                            makeCompositeField = true;
                            compositeField = field;
                        } else if (field.endsWith('"')) {
                            compositeField += ',' + field;
                            compositeField = compositeField.replaceAll('"','');
                            ft.put(fieldapi[i], compositeField.replaceAll('DBLQT','"'));
                            makeCompositeField = false;
                            i++;
                        } else if (makeCompositeField) {
                            compositeField +=  ',' + field;
                        } else {
                            if(fieldapi[i] == 'Bandwidth_Lookup__c'){
                                if(field != '')
                                    ft.Bandwidth_Lookup__r = new Bandwidth__c( Unique__c = field);
                            }else if(fieldapi[i] == 'Feasibility_Pincode__c'){
                                if(field != '')
                                    ft.Feasibility_Pincode__r = new Feasibility_Location__c( Unique__c = field);
                            }else{
                                String typ;
                                try{
                                    typ = String.valueOf(ftype.get(fieldapi[i]).getDescribe().getType());
                                }catch(Exception e){
                                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'You have imported the incorrect csv.'));    
                                    return;
                                    //break;
                                } 
                                //String typ = String.valueOf(ftype.get(fieldapi[i]).getDescribe().getType());
                                System.debug('--------+++++++++++++++++++++++-------'+fieldapi[i]+'======='+typ);
                               
                                String fieldValue = field.replaceAll('DBLQT','"');
                                if(fieldValue == '"')
                                    fieldValue='';
                                if(typ=='INTEGER'){
                                    ft.put(fieldapi[i], integer.valueOf(fieldValue));
                                } else if(typ=='BOOLEAN'){
                                    ft.put(fieldapi[i], Boolean.valueOf(fieldValue));
                                } else if(typ=='DOUBLE'){
                                    if(field.replaceAll('DBLQT','"') != '')
                                        ft.put(fieldapi[i], Double.valueOf(fieldValue));
                                } else if(typ=='DECIMAL'){
                                    if(field.replaceAll('DBLQT','"') != '')
                                        ft.put(fieldapi[i], Decimal.valueOf(fieldValue));
                                } else if(typ=='CURRENCY'){
                                    if(field.replaceAll('DBLQT','"') != '')
                                        ft.put(fieldapi[i], Decimal.valueOf(fieldValue));
                                } else if(typ=='DATE'){
                                    if(field.replaceAll('DBLQT','"') != '')
                                        ft.put(fieldapi[i], date.parse(fieldValue));
                                } else if(typ=='DATETIME'){
                                    if(field.replaceAll('DBLQT','"') != '')
                                        ft.put(fieldapi[i], datetime.valueOf(fieldValue));
                                } else{
                                    ft.put(fieldapi[i], fieldValue);
                                }
                            }
                            i++;
                        }
                    }
                }
            }
            System.debug('~~~~~~~~~~~~~~~~~~~~~~~~~~'+fieldapi);
            if(num !=0 )
                fTaskList.add(ft);
            num++;
        }
        
        Schema.SObjectField f = Account.Fields.External_Id__c;
        Database.UpsertResult[] srList = Database.upsert(fTaskList,f,false);
        
        integer i = 0;
        
        // Adding Success and Error Header Name to CSV file
        csvSuccessFileString = lines[0] + ', Salesforce Id, Status';
        csvErrorFileString = lines[0] + ', Error, Status';
        
        // Iterate through each returned result
        for (Database.UpsertResult sr : srList) {
            if (sr.isSuccess()) {
                //Adding Success rows in CSV success file with Salesforce Id and Status.
                csvSuccessFileString = csvSuccessFileString + lines[i+1] + ',' + sr.getId() + ',' + 'Success,';
                SuccessRowCount++;
                // Operation was successful, so get the ID of the record that was processed
                System.debug('Successfully inserted account. Account ID: ' + sr.getId());
            }
            else {
                FailureRowCount++;
                //Adding Error rows in CSV error file with Error and Status.
                csvErrorFileString = csvErrorFileString + lines[i+1] + ',' + '"' + sr.getErrors()[0].getMessage() + '"' + ',' + 'Error,';
                // Operation failed, so get all errors                
                for(Database.Error err : sr.getErrors()) {
                    System.debug('The following error has occurred.');                    
                    System.debug(err.getStatusCode() + ': ' + err.getMessage());
                    System.debug('Account fields that affected this error: ' + err.getFields());
                    System.debug('Error in Row :::::::'+i);
                    System.debug('Error in Account :::::::'+fTaskList[i]);
                    errList.add(new ErrorWrapper(i,String.valueOf(err.getStatusCode()),err.getMessage()));
                }
            }
            i++;
        }
        
        rowCount = fTaskList.size();
        
        //Insert Bulk Upload record. 
        Bulk_Upload__c bu = new Bulk_Upload__c();
        bu.Ownerid = UserInfo.getUserId();
        bu.File_Name__c = nameFile.split('\\.')[0];
        bu.Status__c = 'Completed';
        bu.Success_Records__c = SuccessRowCount;
        bu.Failure_Records__c = FailureRowCount;
        bu.Total_Records__c = rowCount;
        bu.Upload_Type__c = objName;
        insert bu;
        
        //Generating Success and Error Blob from Success and error String.
        Blob csvSuccessBlob = Blob.valueOf(csvSuccessFileString);
        Blob csvErrorBlob = Blob.valueOf(csvErrorFileString);
        
        List<Attachment> attchList = new List<Attachment>();
        
        //Attaching Success and Error CSV File.
        if(srList.size() > 0){
            AttachmentSuccessObj = new Attachment(Body = csvSuccessBlob, Name = 'success_'+ nameFile.split('\\.')[0] + '_' +System.now().format('yyyy-MMM-dd-hh-mm-ss') + '.csv', parentId = bu.Id);
            AttachmentErrorObj = new Attachment(Body = csvErrorBlob, Name = 'error_'+ nameFile.split('\\.')[0] + '_' +System.now().format('yyyy-MMM-dd-hh-mm-ss') + '.csv', parentId = bu.Id);
            
            attchList.add(AttachmentSuccessObj);
            attchList.add(AttachmentErrorObj);
            
            if(attchList.size() > 0)
                insert attchlist;
        }
        
        
    }*/
    
    public void divideString(String input) {
        
        Integer pivot = input.indexOf( '\r', Integer.valueOf(Math.floor(input.length() / 2)) );
        
        String left = input.substring(0,pivot);
        String right = input.substring(pivot);
        
        if ( pivot < inputCharacterMax ) {
        // split left and right chunks, add to allLines
            left = left.replaceAll(',"""',',"DBLQT').replaceall('""",','DBLQT",');
            left = left.replaceAll('""','DBLQT');
            right = right.replaceAll(',"""',',"DBLQT').replaceall('""",','DBLQT",');
            right = right.replaceAll('""','DBLQT');
            List<String> leftLines = left.split('\r');
            List<String> rightLines = right.split('\r');
            lines.addAll(leftLines);
            lines.addAll(rightLines);
        }
        else {
        // divide and conquer!
            divideString(left);
            divideString(right);
        }
    }
    
    public class ErrorWrapper {
        public Integer row {get; set;}
        //public String ErrorField {get; set;}
        public String ErrorCode {get; set;}
        public String ErrorMessage {get; set;}
        public ErrorWrapper(Integer rw, String errCde, String errmsg){
            row = rw;
            //ErrorField = errFld;
            ErrorCode = errcde;
            ErrorMessage = errmsg;
        }
    }
}