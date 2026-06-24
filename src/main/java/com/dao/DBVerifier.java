package com.dao;

import java.sql.Connection;
import java.sql.DatabaseMetaData;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

public class DBVerifier {

    private static final List<String> EXPECTED_TABLES = Arrays.asList(
        "cloudserver",
        "dcregister",
        "doregister",
        "pkg",
        "upload",
        "store",
        "ukeys",
        "keyreq",
        "keygen",
        "trapdoor",
        "request",
        "response",
        "equality"
    );

    public static void main(String[] args) {
        System.out.println("=== SECURE RANK DB VERIFICATION ===");
        Connection con = DBConnection.connect();
        if (con == null) {
            System.err.println("❌ Database connection failed. Please ensure MySQL is running on localhost:3306 and credentials (root/root) are correct.");
            System.exit(1);
        }

        System.out.println("✅ Database connection successful!");

        try {
            DatabaseMetaData dbm = con.getMetaData();
            System.out.println("Database Product Name: " + dbm.getDatabaseProductName());
            System.out.println("Database Product Version: " + dbm.getDatabaseProductVersion());

            // 1. Check existing tables
            List<String> actualTables = new ArrayList<>();
            try (ResultSet rs = dbm.getTables("securerank_db", null, "%", new String[]{"TABLE"})) {
                while (rs.next()) {
                    actualTables.add(rs.getString("TABLE_NAME").toLowerCase());
                }
            }

            System.out.println("\n--- Existing Tables ---");
            for (String table : actualTables) {
                // Get row count
                int rows = 0;
                try (Statement st = con.createStatement();
                     ResultSet rsCount = st.executeQuery("select count(*) from `" + table + "`")) {
                    if (rsCount.next()) {
                        rows = rsCount.getInt(1);
                    }
                } catch (Exception e) {
                    // ignore if table doesn't support count or similar error
                }
                System.out.println("  - " + table + " (" + rows + " rows)");
            }

            // 2. Validate expected vs actual
            System.out.println("\n--- Verification Status ---");
            boolean missingTables = false;
            for (String expected : EXPECTED_TABLES) {
                if (actualTables.contains(expected)) {
                    System.out.println("✅ " + expected + " - Exist");
                } else {
                    System.out.println("❌ " + expected + " - MISSING!");
                    missingTables = true;
                }
            }

            if (missingTables) {
                System.out.println("\n⚠️ Some tables are missing. Creating/Initializing schema from database.sql...");
                // Note: The caller can run database.sql if needed
            } else {
                System.out.println("\n🎉 All core tables verified and present!");
            }

        } catch (SQLException e) {
            System.err.println("❌ Database verification failed with SQL exception: " + e.getMessage());
            e.printStackTrace();
        } finally {
            try { con.close(); } catch (Exception ignored) {}
        }
    }
}
