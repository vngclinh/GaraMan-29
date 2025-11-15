package model;

public class Service {
    private int id;
    private String name;
    private float price;
    private int estimatedTime;
    private String description;

    public Service() {
    }

    public Service(int id, String name, float price, int estimatedTime, String description) {
        this.id = id;
        this.name = name;
        this.price = price;
        this.estimatedTime = estimatedTime;
        this.description = description;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public float getPrice() {
        return price;
    }

    public void setPrice(float price) {
        this.price = price;
    }

    public int getEstimatedTime() {
        return estimatedTime;
    }

    public void setEstimatedTime(int estimatedTime) {
        this.estimatedTime = estimatedTime;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }
    
    
}
