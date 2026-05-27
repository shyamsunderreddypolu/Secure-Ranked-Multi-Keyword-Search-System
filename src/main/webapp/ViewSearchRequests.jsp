<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="javax.servlet.http.HttpSession,java.sql.*" %>
<%
    HttpSession s=request.getSession(false);
    if(s==null||s.getAttribute("csemail")==null){response.sendRedirect("CloudControllerLogin.jsp");return;}
    Connection con=com.dao.DBConnection.connect();
    ResultSet rs=null;Statement st=null;
    try{st=con.createStatement();rs=st.executeQuery("select Rid,uid,fid,Receiver,Status from request order by Rid desc");}catch(Exception e){e.printStackTrace();}
%>
<!DOCTYPE html><html lang="en"><head><meta charset="UTF-8"><title>Search Requests — SecureRank</title>
<link href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@400;500;600&family=DM+Mono:wght@400;500&display=swap" rel="stylesheet">
<style>
*{box-sizing:border-box;margin:0;padding:0}
:root{--c:#534AB7;--cl:#EEEDFE;--border:rgba(0,0,0,0.09);--white:#fff;--gray:#F7F6F3;--muted:#5F5E5A;--faint:#A0A09A;--r:10px;--rl:14px}
body{font-family:'DM Sans',sans-serif;background:var(--gray)}
nav{background:var(--white);border-bottom:1px solid var(--border);padding:0 32px;height:60px;display:flex;align-items:center;justify-content:space-between}
.nt{font-size:15px;font-weight:600}.ns{font-size:11px;color:var(--muted);font-family:'DM Mono',monospace}
.bb{font-size:12px;padding:6px 14px;background:var(--gray);border:1px solid var(--border);border-radius:var(--r);text-decoration:none;color:var(--muted)}
.bb:hover{border-color:var(--c);color:var(--c)}
.pw{max-width:960px;margin:32px auto;padding:0 24px}
.ph{margin-bottom:20px}.ph h2{font-size:20px;font-weight:600}.ph p{font-size:13px;color:var(--muted);margin-top:4px}
.tc{background:var(--white);border:1px solid var(--border);border-radius:var(--rl);overflow:hidden}
.tt{padding:16px 20px;border-bottom:1px solid var(--border);display:flex;justify-content:space-between}
.ttl{font-size:14px;font-weight:600}.tts{font-size:12px;color:var(--muted);font-family:'DM Mono',monospace}
table{width:100%;border-collapse:collapse}
thead th{padding:10px 14px;text-align:left;font-size:11px;font-weight:500;color:var(--faint);text-transform:uppercase;background:var(--gray);border-bottom:1px solid var(--border);letter-spacing:.05em}
tbody tr{border-bottom:1px solid var(--border)}tbody tr:last-child{border-bottom:none}tbody tr:hover{background:#FAFAF8}
tbody td{padding:12px 14px;font-size:13px;vertical-align:middle}
.mono{font-family:'DM Mono',monospace;font-size:11px;color:var(--muted)}
.sb{display:inline-block;font-size:11px;padding:3px 9px;border-radius:999px;background:var(--cl);color:var(--c);font-weight:500}
.er td{text-align:center;padding:40px;color:var(--faint)}
</style></head><body>
<nav>
  <div><div class="nt">Search Activity</div><div class="ns">Admin · SecureRank</div></div>
  <a href="CSHome.jsp" class="bb">← Dashboard</a>
</nav>
<div class="pw">
  <div class="ph"><h2>Search Requests</h2><p>All search requests submitted by Data Consumers against the encrypted cloud index.</p></div>
  <div class="tc">
    <div class="tt"><div class="ttl">Request Log</div><div class="tts">request table</div></div>
    <table>
      <thead><tr><th>Req ID</th><th>Data Owner</th><th>File ID</th><th>Data Consumer</th><th>Status</th></tr></thead>
      <tbody>
        <%boolean hr=false;if(rs!=null){while(rs.next()){hr=true;%>
        <tr>
          <td class="mono"><%=rs.getString("Rid")%></td>
          <td class="mono"><%=rs.getString("uid")%></td>
          <td class="mono"><%=rs.getString("fid")%></td>
          <td class="mono"><%=rs.getString("Receiver")%></td>
          <td><span class="sb"><%=rs.getString("Status")%></span></td>
        </tr>
        <%}}if(!hr){%><tr class="er"><td colspan="5">No search requests yet.</td></tr><%}%>
      </tbody>
    </table>
  </div>
</div>
<%try{if(rs!=null)rs.close();}catch(Exception e){}try{if(st!=null)st.close();}catch(Exception e){}try{if(con!=null)con.close();}catch(Exception e){}%>
</body></html>
