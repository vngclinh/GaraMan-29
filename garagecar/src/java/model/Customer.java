package model;

import java.io.Serializable;
import java.sql.Date;
import java.util.ArrayList;

public class Customer extends SystemUser implements Serializable {
    private int id;
    private ArrayList<Car> listCar;
    public Customer() {
        super(); 
    }

    public Customer(int id, String fullname, String phoneNum, Date dob, String address, String username, String password, String email) {
        super(id, fullname, phoneNum, dob, address, username, password, email);
    }
}
