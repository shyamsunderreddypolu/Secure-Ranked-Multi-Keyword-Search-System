package com.dao;

import java.io.BufferedReader;
import java.io.FileReader;
import java.sql.Connection;
import java.sql.Statement;

public class DBSchemaImporter {

    public static void main(String[] args) {
        String sqlFile = "DATABASE/database.sql";
        System.out.println("=== SECURE RANK DB SCHEMA IMPORT ===");
        
        Connection con = DBConnection.connect();
        if (con == null) {
            System.err.println("❌ Database connection failed.");
            System.exit(1);
        }

        try (BufferedReader br = new BufferedReader(new FileReader(sqlFile));
             Statement st = con.createStatement()) {
            
            StringBuilder sb = new StringBuilder();
            String line;
            while ((line = br.readLine()) != null) {
                // Skip comments and empty lines
                if (line.trim().startsWith("--") || line.trim().startsWith("/*") || line.trim().isEmpty()) {
                    continue;
                }
                sb.append(line).append("\n");
                
                // If the line ends with a semicolon, execute it
                if (line.trim().endsWith(";")) {
                    String query = sb.toString().trim();
                    // Remove trailing semicolon for JDBC execution
                    if (query.endsWith(";")) {
                        query = query.substring(0, query.length() - 1);
                    }
                    
                    // We skip CREATE DATABASE and USE statements to avoid permission/session errors in some JDBC contexts,
                    // since we are already connected to securerank_db URL.
                    if (query.toUpperCase().startsWith("CREATE DATABASE") || query.toUpperCase().startsWith("USE ")) {
                        sb.setLength(0);
                        continue;
                    }

                    try {
                        st.execute(query);
                        System.out.println("Executed: " + query.substring(0, Math.min(query.length(), 60)) + "...");
                    } catch (Exception e) {
                        System.err.println("⚠️ Failed to execute: " + query.substring(0, Math.min(query.length(), 60)) + "... Reason: " + e.getMessage());
                    }
                    sb.setLength(0); // clear buffer
                }
            }
            System.out.println("🎉 Database initialization completed successfully!");

        } catch (Exception e) {
            System.err.println("❌ DB import failed: " + e.getMessage());
            e.printStackTrace();
        } finally {
            try { con.close(); } catch (Exception ignored) {}
        }
    }
}
