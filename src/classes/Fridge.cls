public class Fridge implements KitchenUtility{
    private String modelNumber;
    private Integer numberInStock;
    public static final Integer stockThreshold=5;
    public Integer ecoRating{
        get{return ecoRating;}
        set{ecoRating=value; if(ecoRating<0) ecoRating=0;}
    }      
    public Fridge(){
        modelNumber='h.345v';
        numberInStock=0;
    }
    public Fridge(String themodelnumber,Integer thenumberinstock){
        modelNumber=themodelnumber;
        numberInStock=thenumberinstock;
    }
    public static void toDebug(Fridge aFridge){
        System.debug('Model Number-' + aFridge.modelNumber);
        System.debug('Number in Stock' + aFridge.numberInStock);
    }         
    public String getModelNumber(){
        return modelNumber;    
    }
}