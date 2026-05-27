<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="javax.servlet.http.HttpSession,java.sql.*" %>
<%
    HttpSession s=request.getSession(false);
    if(s==null||s.getAttribute("csemail")==null){response.sendRedirect("CloudControllerLogin.jsp");return;}
    Connection con=com.dao.DBConnection.connect();
    ResultSet rs=null;Statement st=null;
    try{st=con.createStatement();rs=st.executeQuery("select Rid,Uid,Fid,Tkey,Status,recid from equality order by Rid desc");}catch(Exception e){e.printStackTrace();}
%>
<!DOCTYPE html><html lang="en"><head><meta charset="UTF-8"><title>Equality Check — SecureRank</title>
<link href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@400;500;600&family=DM+Mono:wght@400;500&display=swap" rel="stylesheet">
<style>
*{box-sizing:border-box;margin:0;padding:0}
:root{--c:#7C6514;--cl:#F0EBD8;--teal:#0F6E56;--teal-l:#E1F5EE;--border:rgba(0,0,0,0.09);--white:#fff;--gray:#F7F6F3;--muted:#5F5E5A;--faint:#A0A09A;--r:10px;--rl:14px}
body{font-family:'DM Sans',sans-serif;background:var(--gray)}
nav{background:var(--white);border-bottom:1px solid var(--border);padding:0 32px;height:60px;display:flex;align-items:center;justify-content:space-between}
.nt{font-size:15px;font-weight:600}.ns{font-size:11px;color:var(--muted);font-family:'DM Mono',monospace}
.bb{font-size:12px;padding:6px 14px;background:var(--gray);border:1px solid var(--border);border-radius:var(--r);text-decoration:none;color:var(--muted)}
.bb:hover{border-color:var(--c);color:var(--c)}
.pw{max-width:1000px;margin:32px auto;padding:0 24px}
.ph{margin-bottom:20px}.ph h2{font-size:20px;font-weight:600}.ph p{font-size:13px;color:var(--muted);margin-top:4px}
.tc{background:var(--white);border:1px solid var(--border);border-radius:var(--rl);overflow:hidden}
.tt{padding:16px 20px;border-bottom:1px solid var(--border);display:flex;justify-content:space-between}
.ttl{font-size:14px;font-weight:600}.tts{font-size:12px;color:var(--muted);font-family:'DM Mono',monospace}
table{width:100%;border-collapse:collapse}
thead th{padding:10px 14px;text-align:left;font-size:11px;font-weight:500;color:var(--faint);text-transform:uppercase;background:var(--gray);border-bottom:1px solid var(--border);letter-spacing:.05em}
tbody tr{border-bottom:1px solid var(--border)}tbody tr:last-child{border-bottom:none}tbody tr:hover{background:#FAFAF8}
tbody td{padding:12px 14px;font-size:13px;vertical-align:middle}
.mono{font-family:'DM Mono',monospace;font-size:11px;color:var(--muted)}
.tv{max-width:130px;overflow:hidden;text-overflow:ellipsis;white-space:nowrap;font-family:'DM Mono',monospace;font-size:11px}
.sv{display:inline-block;font-size:11px;padding:3px 9px;border-radius:999px;background:var(--teal-l);color:var(--teal);font-weight:500}
.er td{text-align:center;padding:40px;color:var(--faint)}
</style></head><body>
<nav>
  <div><div class="nt">Equality Verification</div><div class="ns">Admin · SCP Boolean Check</div></div>
  <a href="CSHome.jsp" class="bb">← Dashboard</a>
</nav>
<div class="pw">
  <div class="ph"><h2>SCP Equality Verification Records</h2><p>Secure Coprocessor Boolean equality check results. Verifies that DC trapdoor matches the file's stored trapdoor key.</p></div>
  <div class="tc">
    <div class="tt"><div class="ttl">Verification Log</div><div class="tts">equality table · Tkey / Status</div></div>
    <table>
      <thead><tr><th>ID</th><th>Data Owner</th><th>File ID</th><th>Trapdoor Key</th><th>Data Consumer</th><th>Result</th></tr></thead>
      <tbody>
        <%boolean hr=false;if(rs!=null){while(rs.next()){hr=true;String tk=rs.getString("Tkey");%>
        <tr>
          <td class="mono"><%=rs.getString("Rid")%></td>
          <td class="mono"><%=rs.getString("Uid")%></td>
          <td class="mono"><%=rs.getString("Fid")%></td>
          <td><div class="tv" title="<%=tk%>"><%=tk!=null?tk.substring(0,Math.min(tk.length(),16))+"...":"-"%></div></td>
          <td class="mono"><%=rs.getString("recid")%></td>
          <td><span class="sv"><%=rs.getString("Status")%></span></td>
        </tr>
        <%}}if(!hr){%><tr class="er"><td colspan="6">No equality checks yet.</td></tr><%}%>
      </tbody>
    </table>
  </div>
</div>
<%try{if(rs!=null)rs.close();}catch(Exception e){}try{if(st!=null)st.close();}catch(Exception e){}try{if(con!=null)con.close();}catch(Exception e){}%>
</body></html>
