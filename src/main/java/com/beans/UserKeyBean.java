package com.beans;

/**
 * UserKeyBean
 * ─────────────────────────────────────────────────────────────
 * Bean class used by PKG module to transfer key data
 * between servlets and the DAO layer.
 *
 * Used in: SendKeysToDC.java → DBConnection.sendKeys()
 *
 * Fields:
 *   fid   — File ID the key is associated with
 *   doid  — Data Owner email (file owner)
 *   uid   — Data Consumer email (key recipient)
 *   key1  — The master key value being sent to DC
 * ─────────────────────────────────────────────────────────────
 */
public class UserKeyBean {

    private String fid;   // File ID
    private String doid;  // Data Owner email
    private String uid;   // Data Consumer email (key recipient)
    private String key1;  // Master key value

    public UserKeyBean() {}

    // ── Getters ───────────────────────────────────────────────
    public String getFid()  { return fid;  }
    public String getDoid() { return doid; }
    public String getUid()  { return uid;  }
    public String getKey1() { return key1; }

    // ── Setters ───────────────────────────────────────────────
    public void setFid(String fid)   { this.fid  = fid;  }
    public void setDoid(String doid) { this.doid = doid; }
    public void setUid(String uid)   { this.uid  = uid;  }
    public void setKey1(String key1) { this.key1 = key1; }

    @Override
    public String toString() {
        return "UserKeyBean{fid='" + fid + "', doid='" + doid
             + "', uid='" + uid + "', key1='" + key1 + "'}";
    }
}
