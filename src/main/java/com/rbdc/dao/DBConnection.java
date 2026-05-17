package com.rbdc.dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

/**
 * DBConnection
 * ─────────────────────────────────────────────────────────────
 * Central database utility for SecureRank project (MJDM04).
 * Project: SecureRank-Cloud-Dynamic-Multi-Keyword-Search-over-Encrypted-Data
 *
 * Provides three static methods used by ALL servlets:
 *   connect()  → returns a live MySQL Connection object
 *   getData()  → runs a SELECT, returns true if any row exists
 *   getName()  → runs a SELECT, returns first column as String
 *
 * Database : securerank_db   (import securerank_database.sql first)
 * Host     : localhost:3306
 * ─────────────────────────────────────────────────────────────
 * ⚠️  Change DB_USER and DB_PASSWORD to match your MySQL setup.
 * ─────────────────────────────────────────────────────────────
 */
public class DBConnection {

    // ── Database connection settings ──────────────────────────
    private static final String DRIVER      = "com.mysql.jdbc.Driver";
    private static final String DB_URL      = "jdbc:mysql://localhost:3306/securerank_db";
    private static final String DB_USER     = "root";      // ← your MySQL username
    private static final String DB_PASSWORD = "root";       // MySQL password

    // ─────────────────────────────────────────────────────────
    // connect()
    // Returns an open MySQL Connection.
    // Returns null if connection fails — always null-check caller side.
    // ─────────────────────────────────────────────────────────
    public static Connection connect() {
        Connection con = null;
        try {
            Class.forName(DRIVER);
            con = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
        } catch (ClassNotFoundException e) {
            System.err.println("[DBConnection] MySQL JDBC Driver not found. "
                + "Add mysql-connector-java.jar to WEB-INF/lib/");
            e.printStackTrace();
        } catch (SQLException e) {
            System.err.println("[DBConnection] Connection failed: " + e.getMessage());
            e.printStackTrace();
        }
        return con;
    }

    // ─────────────────────────────────────────────────────────
    // getData(sql)
    // Runs a SELECT query.
    // Returns true  → at least one matching row found
    // Returns false → no rows found or query failed
    //
    // Usage (from any servlet):
    //   boolean valid = DBConnection.getData(
    //     "select * from data_owner where email='x' and password='y'
    //      and status='Approved'");
    // ─────────────────────────────────────────────────────────
    public static boolean getData(String sql) {
        boolean found  = false;
        Connection con = null;
        Statement  st  = null;
        ResultSet  rs  = null;
        try {
            con   = connect();
            if (con == null) return false;
            st    = con.createStatement();
            rs    = st.executeQuery(sql);
            found = rs.next();
        } catch (SQLException e) {
            System.err.println("[DBConnection.getData()] Error: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeAll(rs, st, con);
        }
        return found;
    }

    // ─────────────────────────────────────────────────────────
    // getName(sql)
    // Runs a SELECT query.
    // Returns the value of column 1, row 1 as a String.
    // Returns "" (empty string) if no row found or query failed.
    //
    // Usage (from any servlet):
    //   String name = DBConnection.getName(
    //     "select name from data_owner where email='x'");
    // ─────────────────────────────────────────────────────────
    public static String getName(String sql) {
        String     value = "";
        Connection con   = null;
        Statement  st    = null;
        ResultSet  rs    = null;
        try {
            con = connect();
            if (con == null) return value;
            st  = con.createStatement();
            rs  = st.executeQuery(sql);
            if (rs.next()) {
                value = rs.getString(1);
            }
        } catch (SQLException e) {
            System.err.println("[DBConnection.getName()] Error: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeAll(rs, st, con);
        }
        return value;
    }

    // ─────────────────────────────────────────────────────────
    // closeAll() — internal cleanup, always called in finally
    // ─────────────────────────────────────────────────────────
    private static void closeAll(ResultSet rs, Statement st, Connection con) {
        try { if (rs  != null) rs.close();  } catch (SQLException ignored) {}
        try { if (st  != null) st.close();  } catch (SQLException ignored) {}
        try { if (con != null) con.close(); } catch (SQLException ignored) {}
    }
}
