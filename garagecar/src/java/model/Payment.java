package model;

import java.time.LocalDateTime;

public class Payment {
    private int id;
    private String method;
    private LocalDateTime date;

    public Payment(String method, LocalDateTime date) {
        this.method = method;
        this.date = date;
    }

    public Payment() {
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getMethod() {
        return method;
    }

    public void setMethod(String method) {
        this.method = method;
    }

    public LocalDateTime getDate() {
        return date;
    }

    public void setDate(LocalDateTime date) {
        this.date = date;
    }
    
    
}
