package model;

public class ServiceStats extends Service{
    private float totalRevenue;
    private int totalQuantity;

    public ServiceStats() {
        super();
    }

    public ServiceStats(int id, String name, float price, int estimatedTime, String description, float totalRevenue, int quantity) {
        super(id, name, price, estimatedTime, description);
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
