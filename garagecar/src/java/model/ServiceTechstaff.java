package model;

public class ServiceTechstaff {
    private int id;
    private Employee technician;

    public ServiceTechstaff() {
    }

    public ServiceTechstaff(int id, Employee technician) {
        this.id = id;
        this.technician = technician;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public Employee getTechnician() {
        return technician;
    }

    public void setTechnician(Employee technician) {
        this.technician = technician;
    }
    
}
