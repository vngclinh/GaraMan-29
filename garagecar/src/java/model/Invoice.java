package model;

import java.time.LocalDateTime;
import java.util.ArrayList;

public class Invoice {
    private int id;
    private LocalDateTime creationTime;
    private float total;
    private String status;
    private Customer customer;
    private Employee staff;
    private Car car;
    private Slot slot;
    private Payment payment;
    private ArrayList<UsedService> listService;
    private ArrayList<UsedPart> listPart;

    public Invoice() {
    }

    public Invoice(int id, LocalDateTime creationTime, float total, String status, Customer customer, Employee staff, Car car, Slot slot, Payment payment, ArrayList<UsedService> listService, ArrayList<UsedPart> listPart) {
        this.id = id;
        this.creationTime = creationTime;
        this.total = total;
        this.status = status;
        this.customer = customer;
        this.staff = staff;
        this.car = car;
        this.slot = slot;
        this.payment = payment;
        this.listService = listService;
        this.listPart = listPart;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public LocalDateTime getCreationTime() {
        return creationTime;
    }

    public void setCreationTime(LocalDateTime creationTime) {
        this.creationTime = creationTime;
    }

    public float getTotal() {
        return total;
    }

    public void setTotal(float total) {
        this.total = total;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Customer getCustomer() {
        return customer;
    }

    public void setCustomer(Customer customer) {
        this.customer = customer;
    }

    public Employee getStaff() {
        return staff;
    }

    public void setStaff(Employee staff) {
        this.staff = staff;
    }

    public Car getCar() {
        return car;
    }

    public void setCar(Car car) {
        this.car = car;
    }

    public Slot getSlot() {
        return slot;
    }

    public void setSlot(Slot slot) {
        this.slot = slot;
    }

    public Payment getPayment() {
        return payment;
    }

    public void setPayment(Payment payment) {
        this.payment = payment;
    }

    public ArrayList<UsedService> getListService() {
        return listService;
    }

    public void setListService(ArrayList<UsedService> listService) {
        this.listService = listService;
    }

    public ArrayList<UsedPart> getListPart() {
        return listPart;
    }

    public void setListPart(ArrayList<UsedPart> listPart) {
        this.listPart = listPart;
    }
    
}
