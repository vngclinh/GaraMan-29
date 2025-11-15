package model;

public class Part {
    private int id;
    private String name;
    private float price;
    private int remainQuantity;
    private String description;

    public Part() {
    }

    public Part(String name, float price, int remainQuantity, String description) {
        this.name = name;
        this.price = price;
        this.remainQuantity = remainQuantity;
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

    public int getRemainQuantity() {
        return remainQuantity;
    }

    public void setRemainQuantity(int remainQuantity) {
        this.remainQuantity = remainQuantity;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }
    
}
