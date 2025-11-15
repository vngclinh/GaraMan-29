
package model;

import java.util.ArrayList;

public class UsedService {
    private int id;
    private float unitPrice;
    private int quantity;
    private Service service;
    private ArrayList<ServiceTechstaff> listTechstaff;

    public UsedService() {
    }

    public UsedService(int id, float unitPrice, int quantity, Service service, ArrayList<ServiceTechstaff> listTechstaff) {
        this.id = id;
        this.unitPrice = unitPrice;
        this.quantity = quantity;
        this.service = service;
        this.listTechstaff = listTechstaff;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public float getUnitPrice() {
        return unitPrice;
    }

    public void setUnitPrice(float unitPrice) {
        this.unitPrice = unitPrice;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public Service getService() {
        return service;
    }

    public void setService(Service service) {
        this.service = service;
    }

    public ArrayList<ServiceTechstaff> getListTechstaff() {
        return listTechstaff;
    }

    public void setListTechstaff(ArrayList<ServiceTechstaff> listTechstaff) {
        this.listTechstaff = listTechstaff;
    }
    
}
