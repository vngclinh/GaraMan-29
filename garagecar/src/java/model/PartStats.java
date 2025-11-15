package model;

public class PartStats extends Part {
    private float totalRevenue;
    private int totalQuantity;

    public PartStats() {
        super();
    }

    public PartStats(String name, float price, int remainQuantity, String description,  float totalRevenue, int quantity) {
        super(name, price, remainQuantity, description);
        this.totalQuantity=quantity;
        this.totalRevenue=totalRevenue;
    }

    public float getTotalRevenue() {
        return totalRevenue;
    }

    public void setTotalRevenue(float totalRevenue) {
        this.totalRevenue = totalRevenue;
    }

    public int getTotalQuantity() {
        return totalQuantity;
    }

    public void setTotalQuantity(int totalQuantity) {
        this.totalQuantity = totalQuantity;
    }
    
}
