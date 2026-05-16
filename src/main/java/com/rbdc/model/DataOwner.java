package com.rbdc.model;

public class DataOwner {

    private int id;
    private String name;
    private String email;
    private String password;
    private String organization;

    public DataOwner() {

    }

    public DataOwner(int id, String name, String email,
                     String password, String organization) {

        this.id = id;
        this.name = name;
        this.email = email;
        this.password = password;
        this.organization = organization;
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

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getOrganization() {
        return organization;
    }

    public void setOrganization(String organization) {
        this.organization = organization;
    }
}