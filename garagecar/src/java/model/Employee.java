package model;

import java.io.Serializable;
import java.sql.Date;

public class Employee extends SystemUser implements Serializable {
    private int id;
    private String position;
    
    public Employee(){
        super();
    }
    
    public Employee(int id, String fullname, String phoneNum, Date dob, String address, String username, String password, String email, String position){
        super(id, fullname, phoneNum, dob, address, username, password, email);
        this.position = position;
    }
    public String setPosition(String position){
        return this.position=position;
    }
    public String getPosition(){
        return this.position;
    }
}
