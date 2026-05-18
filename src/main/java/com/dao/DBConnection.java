package com.dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import com.beans.UserKeyBean;

/**
 * DBConnection
 * ─────────────────────────────────────────────────────────────
 * Central database utility for SecureRank project (MJDM04).
 * Project: SecureRank-Cloud-Dynamic-Multi-Keyword-Search-over-Encrypted-Data
 *
 * Methods:
 *   connect()     → open MySQL connection
 *   getData()     → SELECT → true if row exists
 *   getName()     → SELECT → returns first column value as String
 *   getDOKeys()   → SELECT from store table → returns List of mk values
 *   sendKeys()    → INSERT into ukeys → sends master key to DC
 *
 * Database : securerank_db
 * JDBC     : jdbc:mysql://localhost:3306/securerank_db
 * User     : root / root
 * ─────────────────────────────────────────────────────────────
 */
public class DBConnection {

    private static final String DRIVER      = "com.mysql.jdbc.Driver";
    private static final String DB_URL      = "jdbc:mysql://localhost:3306/securerank_db";
    private static final String DB_USER     = "root";
    private static final String DB_PASSWORD = "root";

    // ─────────────────────────────────────────────────────────
    // connect() — returns open MySQL Connection
    // Returns null if connection fails — check at caller side
    // ─────────────────────────────────────────────────────────
    public static Connection connect() {
        Connection con = null;
        try {
            Class.forName(DRIVER);
            con = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
        } catch (ClassNotFoundException e) {
            System.err.println("[DBConnection] Driver not found: " + e.getMessage());
        } catch (SQLException e) {
            System.err.println("[DBConnection] Connection failed: " + e.getMessage());
        }
        return con;
    }

    // ─────────────────────────────────────────────────────────
    // getData(sql)
    // Runs a SELECT query.
    // Returns true  → at least one row found
    // Returns false → no rows or query failed
    //
    // Usage:
    //   boolean valid = DBConnection.getData(
    //     "select * from doregister where email='x' and status1='Approved'");
    // ─────────────────────────────────────────────────────────
    public static boolean getData(String sql) {
        boolean    found = false;
        Connection con   = null;
        Statement  st    = null;
        ResultSet  rs    = null;
        try {
            con   = connect();
            if (con == null) return false;
            st    = con.createStatement();
            rs    = st.executeQuery(sql);
            found = rs.next();
        } catch (SQLException e) {
            System.err.println("[DBConnection.getData()] " + e.getMessage());
        } finally {
            closeAll(rs, st, con);
        }
        return found;
    }

    // ─────────────────────────────────────────────────────────
    // getName(sql)
    // Runs SELECT — returns column 1, row 1 as String.
    // Returns "" if no row found or error.
    //
    // Usage:
    //   String name = DBConnection.getName(
    //     "select name from doregister where email='x'");
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
            System.err.println("[DBConnection.getName()] " + e.getMessage());
        } finally {
            closeAll(rs, st, con);
        }
        return value;
    }

    // ─────────────────────────────────────────────────────────
    // getDOKeys(sql)
    // Fetches the master key (mk) from the store table for a file.
    // Returns List<String> of mk values.
    //
    // Called by: SendKeysToDC.java
    // store table columns: id, fid, mk
    //
    // Usage:
    //   List<String> keys = DBConnection.getDOKeys(
    //     "select * from store where fid='1'");
    //   Iterator<String> itr = keys.iterator();
    //   while (itr.hasNext()) { key1 = itr.next(); }
    // ─────────────────────────────────────────────────────────
    public static List<String> getDOKeys(String sql) {
        List<String> keys = new ArrayList<String>();
        Connection   con  = null;
        Statement    st   = null;
        ResultSet    rs   = null;
        try {
            con = connect();
            if (con == null) return keys;
            st  = con.createStatement();
            rs  = st.executeQuery(sql);
            while (rs.next()) {
                String mk = rs.getString("mk");
                if (mk != null) {
                    keys.add(mk);
                }
            }
        } catch (SQLException e) {
            System.err.println("[DBConnection.getDOKeys()] " + e.getMessage());
        } finally {
            closeAll(rs, st, con);
        }
        return keys;
    }

    // ─────────────────────────────────────────────────────────
    // sendKeys(sql, kb)
    // Inserts a master key record into the ukeys table.
    // Returns rows inserted: 1 = success, 0 = failed.
    //
    // Called by: SendKeysToDC.java
    // ukeys table columns: fid, doid, uid, key1
    //
    // Usage:
    //   int i = DBConnection.sendKeys(
    //     "insert into ukeys values(?,?,?,?)", userKeyBean);
    // ─────────────────────────────────────────────────────────
    public static int sendKeys(String sql, UserKeyBean kb) {
        int               rows = 0;
        Connection        con  = null;
        PreparedStatement ps   = null;
        try {
            con = connect();
            if (con == null) return 0;
            ps  = con.prepareStatement(sql);
            ps.setString(1, kb.getFid());   // fid  — file ID
            ps.setString(2, kb.getDoid());  // doid — Data Owner email
            ps.setString(3, kb.getUid());   // uid  — Data Consumer email
            ps.setString(4, kb.getKey1());  // key1 — master key value
            rows = ps.executeUpdate();
        } catch (SQLException e) {
            System.err.println("[DBConnection.sendKeys()] " + e.getMessage());
        } finally {
            try { if (ps  != null) ps.close();  } catch (SQLException ignored) {}
            try { if (con != null) con.close(); } catch (SQLException ignored) {}
        }
        return rows;
    }

    // ─────────────────────────────────────────────────────────
    // closeAll() — internal: closes RS, Statement, Connection
    // ─────────────────────────────────────────────────────────
    private static void closeAll(ResultSet rs, Statement st, Connection con) {
        try { if (rs  != null) rs.close();  } catch (SQLException ignored) {}
        try { if (st  != null) st.close();  } catch (SQLException ignored) {}
        try { if (con != null) con.close(); } catch (SQLException ignored) {}
    }
}
