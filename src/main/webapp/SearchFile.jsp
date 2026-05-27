<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="javax.servlet.http.HttpSession,java.sql.*" %>
<%
    HttpSession s = request.getSession(false);
    if(s==null||s.getAttribute("dcemail")==null){response.sendRedirect("DCLogin.jsp");return;}
    String dcEmail=(String)s.getAttribute("dcemail");
    String dcName=(String)s.getAttribute("dcname");
    Connection con=com.dao.DBConnection.connect();
    ResultSet rs=null;Statement st=null;
    try{st=con.createStatement();rs=st.executeQuery("select id,name,trap from trapdoor where uid='"+dcEmail+"' order by id desc");}catch(Exception e){e.printStackTrace();}
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"><title>Search Files — SecureRank</title>
  <link href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@400;500;600&family=DM+Mono:wght@400;500&display=swap" rel="stylesheet">
  <style>
    *{box-sizing:border-box;margin:0;padding:0}
    :root{--c:#854F0B;--cl:#FAEEDA;--border:rgba(0,0,0,0.09);--white:#fff;--gray:#F7F6F3;--muted:#5F5E5A;--faint:#A0A09A;--r:10px;--rl:14px}
    body{font-family:'DM Sans',sans-serif;background:var(--gray)}
    nav{background:var(--white);border-bottom:1px solid var(--border);padding:0 32px;height:60px;display:flex;align-items:center;justify-content:space-between}
    .nt{font-size:15px;font-weight:600}.ns{font-size:11px;color:var(--muted);font-family:'DM Mono',monospace}
    .bb{font-size:12px;padding:6px 14px;background:var(--gray);border:1px solid var(--border);border-radius:var(--r);text-decoration:none;color:var(--muted)}
    .bb:hover{border-color:var(--c);color:var(--c)}
    .pw{max-width:860px;margin:32px auto;padding:0 24px}
    .ph{margin-bottom:22px}.ph h2{font-size:20px;font-weight:600}.ph p{font-size:13px;color:var(--muted);margin-top:4px}
    .tc{background:var(--white);border:1px solid var(--border);border-radius:var(--rl);overflow:hidden}
    .tt{padding:16px 20px;border-bottom:1px solid var(--border);display:flex;justify-content:space-between;align-items:center}
    .ttl{font-size:14px;font-weight:600}.tts{font-size:12px;color:var(--muted);font-family:'DM Mono',monospace}
    table{width:100%;border-collapse:collapse}
    thead th{padding:10px 16px;text-align:left;font-size:11px;font-weight:500;color:var(--faint);text-transform:uppercase;background:var(--gray);border-bottom:1px solid var(--border);letter-spacing:0.05em}
    tbody tr{border-bottom:1px solid var(--border)}
    tbody tr:last-child{border-bottom:none}
    tbody tr:hover{background:#FAFAF8}
    tbody td{padding:12px 16px;font-size:13px;vertical-align:middle}
    .mono{font-family:'DM Mono',monospace;font-size:11px;color:var(--muted)}
    .tv{max-width:200px;overflow:hidden;text-overflow:ellipsis;white-space:nowrap;font-family:'DM Mono',monospace;font-size:11px;color:var(--c)}
    .bts{font-size:12px;font-weight:500;color:var(--c);text-decoration:none;padding:5px 14px;border:1px solid var(--c);border-radius:var(--r)}
    .bts:hover{background:var(--c);color:#fff}
    .er td{text-align:center;padding:40px;color:var(--faint);font-size:13px}
    .gl{margin-bottom:28px}
    .bga{font-size:13px;font-weight:500;color:var(--c);text-decoration:none}
  </style>
</head>
<body>
<nav>
  <div><div class="nt">Search Encrypted Files</div><div class="ns">Data Consumer · <%= dcName %></div></div>
  <a href="DCHome.jsp" class="bb">← Dashboard</a>
</nav>
<div class="pw">
  <div class="ph"><h2>Submit Search Trapdoor</h2><p>Select a keyword trapdoor below and click "Search" to find matching encrypted files using Boolean keyword search.</p></div>
  <div class="gl"><a href="GenerateTrapdoor.jsp" class="bga">+ Generate new trapdoor first</a></div>
  <div class="tc">
    <div class="tt"><div class="ttl">Your Trapdoors</div><div class="tts">trapdoor table</div></div>
    <table>
      <thead><tr><th>#</th><th>Keyword</th><th>Encrypted Trapdoor</th><th>Action</th></tr></thead>
      <tbody>
        <%boolean hr=false;int c=1;if(rs!=null){while(rs.next()){hr=true;String kw=rs.getString("name");String tr=rs.getString("trap");%>
        <tr>
          <td class="mono"><%=c++%></td>
          <td><strong><%=kw%></strong></td>
          <td><div class="tv" title="<%=tr%>"><%=tr%></div></td>
          <td><a href="SearchFile?keyword=<%=kw%>" class="bts">Search →</a></td>
        </tr>
        <%}}if(!hr){%><tr class="er"><td colspan="4">No trapdoors yet. <a href="GenerateTrapdoor.jsp" style="color:var(--c);font-weight:500;">Generate one first</a>.</td></tr><%}%>
      </tbody>
    </table>
  </div>
</div>
<%try{if(rs!=null)rs.close();}catch(Exception e){}try{if(st!=null)st.close();}catch(Exception e){}try{if(con!=null)con.close();}catch(Exception e){}%>
</body>
</html>
