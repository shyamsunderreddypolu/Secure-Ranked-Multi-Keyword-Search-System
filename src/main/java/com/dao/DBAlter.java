package com.dao;

import java.sql.Connection;
import java.sql.Statement;

public class DBAlter {
    public static void main(String[] args) {
        Connection con = DBConnection.connect();
        if (con == null) {
            System.err.println("Database connection failed.");
            System.exit(1);
        }
        try (Statement st = con.createStatement()) {
            st.execute("ALTER TABLE response ADD COLUMN score DOUBLE DEFAULT 0.0 COMMENT 'TF-IDF relevance score'");
            System.out.println("✅ Column 'score' added to 'response' table successfully!");
        } catch (Exception e) {
            System.out.println("⚠️ Column 'score' may already exist or failed to add: " + e.getMessage());
        } finally {
            try { con.close(); } catch (Exception ignored) {}
        }
    }
}
