package model;

public class Slot {
    private int id;
    private String name;
    private String note;
    
    public Slot(){
        
    }
    public Slot(int id, String name, String note){
        this.id=id;
        this.name=name;
        this.note= note;
    }

    public int getId() {
        return id;
    }

    public String getName() {
        return name;
    }

    public String getNote() {
        return note;
    }

    public void setId(int id) {
        this.id = id;
    }

    public void setName(String name) {
        this.name = name;
    }

    public void setNote(String note) {
        this.note = note;
    }
    
}
