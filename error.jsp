<%--
    error.jsp — 404 / 500 error page
    Location: src/main/webapp/jsp/error.jsp
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" isErrorPage="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>TapFood — Error</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            background: #f5f5f5;
        }
        .box { text-align: center; padding: 48px 24px; }
        .code {
            font-size: 96px;
            font-weight: 900;
            background: linear-gradient(135deg, #C80238, #FDA501);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            line-height: 1;
            margin-bottom: 16px;
        }
        h2 { font-size: 22px; color: #1a1a1a; margin-bottom: 8px; }
        p  { color: #888; margin-bottom: 28px; font-size: 15px; }
        a {
            display: inline-block;
            background: linear-gradient(135deg, #C80238, #F92827);
            color: #fff;
            text-decoration: none;
            padding: 14px 36px;
            border-radius: 50px;
            font-weight: 700;
            font-size: 15px;
            transition: opacity 0.2s;
        }
        a:hover { opacity: 0.88; }
    </style>
</head>
<body>
    <div class="box">
        <div class="code">404</div>
        <h2>Oops! Page not found</h2>
        <p>The page you're looking for doesn't exist or has been moved.</p>
        <a href="${pageContext.request.contextPath}/home">← Back to Home</a>
    </div>
</body>
</html>
