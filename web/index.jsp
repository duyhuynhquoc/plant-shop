<%-- 
    Document   : index
    Created on : Jan 25, 2022, 2:29:44 PM
    Author     : duyhu
--%>

<%@page import="duyhq.dao.AccountDAO"%>
<%@page import="duyhq.dto.Account"%>
<%@page import="duyhq.dao.PlantDAO"%>
<%@page import="duyhq.dto.Plant"%>
<%@page import="java.util.ArrayList"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Welcome</title>
    </head>
    <body>
        <% 
            String name = (String) session.getAttribute("name");
            String email = (String) session.getAttribute("email");

            Cookie[] c = request.getCookies();

            boolean login = false;

            Account acc = null;

            String token = "";

            if (name == null) {
                if (c != null) {
                    for (Cookie aCookie : c) {
                        if (aCookie.getName().equals("selector")) {
                            token = aCookie.getValue();
                            acc = AccountDAO.getAccountByToken(token);
                            if (acc != null) {
                                name = acc.getFullname();
                                email = acc.getEmail();
                                login = true;
                            }
                        }
                    }
                }
            } else {
                acc = AccountDAO.getAccountByEmail(email);
                login = true;
            }
            
            if (login && acc.getRole() == 1) {
                response.sendRedirect("adminIndex.jsp");
            }

            if (!login) {
        %>
            <%@include file="header.jsp" %>
        <% } else {%>
            <%@include file="header_loginedUser.jsp" %>
        <% } %>
        
        <%
            String keyword = request.getParameter("txtsearch");
            String searchby = request.getParameter("searchby");
            
            ArrayList<Plant> list;
            String[] tmp = {"out of stock", "available"};
            
            if (keyword == null && searchby == null) {
                list = PlantDAO.getPlants("", "");
            } else {
                list = PlantDAO.getPlants(keyword, searchby);
            }
            
            if (list != null || !list.isEmpty()) {
                for (Plant p: list) {
                    %>
                    
                    <table class="product">
                        <tr>
                            <td><img src="<%= p.getImgpath()%>" class="plantimg" /></td>
                            <td>Product ID: <%= p.getId() %></td>
                            <td>Product name: <%= p.getName() %></td>
                            <td>Price: <%= p.getPrice() %></td>
                            <td>Status: <%= p.getStatus() %></td>
                            <td>Category: <%= p.getCatename() %></td>
                            <td><a href="mainController?action=addtocart&pid=<%=p.getId()%>">Add to cart</a></td>
                        </tr>
                    </table>
                    
                    <%
                }
            }
        %>
        
        <div class="clear"></div>
        <footer>
            <%@include file="footer.jsp" %>
        </footer>
    </body>
</html>
