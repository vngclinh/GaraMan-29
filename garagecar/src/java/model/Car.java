package model;

public class Car {
    private int id;
    private String plateNum;
    private String name;
    private String brand;

    public Car(String plateNum, String name, String brand) {
        this.plateNum = plateNum;
        this.name = name;
        this.brand = brand;
    }

    public Car() {
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getPlateNum() {
        return plateNum;
    }

    public void setPlateNum(String plateNum) {
        this.plateNum = plateNum;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getBrand() {
        return brand;
    }

    public void setBrand(String brand) {
        this.brand = brand;
    }
}
