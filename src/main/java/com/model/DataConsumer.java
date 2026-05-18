package com.model;

public class DataConsumer {

    private int id;
    private String name;
    private String email;
    private String purpose;

    public DataConsumer() {

    }

    public DataConsumer(int id, String name,
                        String email, String purpose) {

        this.id = id;
        this.name = name;
        this.email = email;
        this.purpose = purpose;
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

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPurpose() {
        return purpose;
    }

    public void setPurpose(String purpose) {
        this.purpose = purpose;
    }
}