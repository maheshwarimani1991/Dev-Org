public class SessionSampleController {

    private String AWSCredentialName = 'NAME OF KEY TO USE'; //Modify this string variable to be the name of the AWS Credential record that contains the proper AWS keys and secret

	public S3.AmazonS3 as3 { get; private set; } //This object represents an instance of the Amazon S3 toolkit and makes all the Web Service calls to AWS. 
	public S3.ListBucketResult listbucket {get;set;}
    public S3.ListEntry[] bucketList {get;set;}    
    public S3.ListAllMyBucketsEntry[] allBucketList {get;set;}

	public String selectedBucket {get;set;}
    public String listBucketErrorMsg {get;set;}
    public String OwnerId {get;set;}

    public String bucketToList {get;set;}  // Set on form post when bucket selected

    public PageReference constructor(){
    	try{
			AWSKeys credentials = new AWSKeys(AWSCredentialName);
			as3 = new S3.AmazonS3(credentials.key,credentials.secret);
			listBucketErrorMsg =null;
		}catch(AWSKeys.AWSKeysException AWSEx){
		     ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.FATAL, AWSEx.getMessage());
			 ApexPages.addMessage(errorMsg);
		}
       return null;	
    }

	//Method to return a string array for all the buckets in your AWS S3 account
	public String[] allBuckets { 
		get {
			try{
				Datetime now = Datetime.now();
				//This performs the Web Service call to Amazon S3 and retrieves all the Buckets in your AWS Account. 
				S3.ListAllMyBucketsResult allBuckets = as3.ListAllMyBuckets(
					as3.key,
					now,
					as3.signature('ListAllMyBuckets',now)
				);
				
				S3.ListAllMyBucketsList bucketList = allBuckets.Buckets;
		
				//Store the Canonical User Id for your account
				OwnerId = allBuckets.Owner.Id;
		
				S3.ListAllMyBucketsEntry[] buckets = bucketList.Bucket;

				allBucketList = buckets;
		
				String[] bucketNames = new String[]{};
		
				//Loop through each bucket entry to get the bucket name and store in string array. 
				for(S3.ListAllMyBucketsEntry bucket: buckets){
					 bucketNames.add(bucket.name);
				}
		    	return bucketNames;
    	
			} catch (System.NullPointerException e) {
		   		return null;
			} catch(Exception ex){
			   ApexPages.addMessages(ex);
			   return null;	
			}
		}
		set;
	 }
	 
	 //This is used by the sample Visualforce page to display the list of all buckets created in your AWS account. 
	 public List<SelectOption> getBucketNames() {
   	 	List<SelectOption> options = new List<SelectOption>();
   	 	
   	 	String[] bckts = allBuckets;
   	 	if(bckts!=null){
	   	 	for(String bucket : allBuckets){
	   	 	   options.add(new SelectOption(bucket,bucket));	
	   	 	}
	   	 	return options;
   	 	}
   	 	else
   	 	  return null;
     }

	public PageReference listBucket(){
		try{
			listBucketErrorMsg=  null;
		    Datetime now = Datetime.now();
			Integer maxNumberToList = 25; //Set the number of Objects to return for a specific Bucket
			String Prefix = null; //Limits the response to keys that begin with the indicated prefix. You can use prefixes to separate a bucket into different sets of keys in a way similar to how a file system uses folders. This is an optional argument.
			String Marker = null; //Indicates where in the bucket to begin listing. The list includes only keys that occur alphabetically after marker. This is convenient for pagination: To get the next page of results use the last key of the current page as the marker. The most keys you'd like to see in the response body. The server might return less than this number of keys, but will not return more. This is an optional argument.
			String Delimiter = null; //Causes keys that contain the same string between the prefix and the first occurrence of the delimiter to be rolled up into a single result element in the CommonPrefixes collection. These rolled-up keys are not returned elsewhere in the response. 
			
			System.debug('Going to execute S3 ListBucket service for bucket: ' + bucketToList);
			
			//This performs the Web Service call to Amazon S3 and retrieves all the objects in the specified bucket
			S3.ListBucketResult objectsForBucket = as3.ListBucket(
				bucketToList, 
				Prefix, 
				Marker,
				maxNumberToList, 
				Delimiter,
				as3.key,
				now,
				as3.signature('ListBucket',now),
				as3.secret)
			;
	        bucketList = objectsForBucket.Contents;
	    
		    return null;
		}catch(System.CalloutException callout){
		  ApexPages.addMessages(callout);
		  listBucketErrorMsg = 	callout.getMessage();
		  return null; 	
	    }catch(Exception ex){
		    listBucketErrorMsg = 	ex.getMessage();
		    ApexPages.addMessages(ex);
		    return null;	
		}
	}
	

	public pageReference redirectToS3Key() {
        //get the filename in urlencoded format
        String filename = EncodingUtil.urlEncode(ApexPages.currentPage().getParameters().get('filename'), 'UTF-8');
        Datetime now = DateTime.now();
        Datetime expireson = now.AddSeconds(120);
        Long Lexpires = expireson.getTime()/1000;
        
        String stringtosign = 'GET\n\n\n'+Lexpires+'\n/'+bucketToList+'/'+filename;
        String signed = make_sig(stringtosign);
        String codedsigned = EncodingUtil.urlEncode(signed,'UTF-8');
        String url = 'http://'+bucketToList+'.s3.amazonaws.com/'+filename+'?AWSAccessKeyId='+as3.key+'&Expires='+Lexpires+'&Signature='+signed;
        PageReference newPage = new PageReference(url);
        return newPage;
        
    }
    //method that will sign
    private String make_sig(string canonicalBuffer) {        
        String macUrl ;
        String signingKey = EncodingUtil.base64Encode(Blob.valueOf(as3.secret));
        Blob mac = Crypto.generateMac('HMacSHA1', blob.valueof(canonicalBuffer),blob.valueof(as3.secret)); 
        macUrl = EncodingUtil.base64Encode(mac);                
        return macUrl;
    }

}