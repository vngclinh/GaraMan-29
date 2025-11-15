package model;

import java.time.LocalDateTime;

public class Appointment {
    private int id;
    private LocalDateTime creationTime;
    private LocalDateTime appointmentTime;
    private String status;
    private String note;
    private Customer customer;

    public Appointment() {
        this.creationTime = LocalDateTime.now();
    }

    public Appointment( LocalDateTime appointmentTime, String status, String note, Customer c) {
        this.creationTime = LocalDateTime.now();
        this.appointmentTime = appointmentTime;
        this.status = status;
        this.note = note;
        this.customer = c;
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

    public LocalDateTime getAppointmentTime() {
        return appointmentTime;
    }

    public void setAppointmentTime(LocalDateTime appointmentTime) {
        this.appointmentTime = appointmentTime;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }

    public Customer getCustomer() {
        return this.customer;
    }

    public void setCustomer(Customer c) {
        this.customer = c;
    }
    
}
