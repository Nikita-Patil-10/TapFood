<%--
    login.jsp — TapFood Login Page
    Location: src/main/webapp/jsp/login.jsp
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${pageTitle}</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        body {
            min-height: 100vh;
            display: grid;
            grid-template-columns: 1fr 1fr;
            background: var(--bg);
        }

        /* Left panel */
        .auth-left {
            background: linear-gradient(145deg, var(--primary) 0%, #a00230 40%, var(--accent) 80%, var(--orange) 100%);
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            padding: 60px 48px;
            position: relative;
            overflow: hidden;
        }
        .auth-left::before {
            content: '';
            position: absolute;
            width: 400px; height: 400px;
            background: rgba(255,255,255,0.06);
            border-radius: 50%;
            top: -100px; right: -100px;
        }
        .auth-left::after {
            content: '';
            position: absolute;
            width: 300px; height: 300px;
            background: rgba(255,255,255,0.04);
            border-radius: 50%;
            bottom: -80px; left: -80px;
        }
        .auth-left-content { position: relative; z-index: 1; text-align: center; color: #fff; }
        .auth-logo { font-size: 64px; margin-bottom: 16px; }
        .auth-brand { font-size: 42px; font-weight: 900; letter-spacing: -2px; margin-bottom: 8px; }
        .auth-tagline { font-size: 15px; opacity: 0.8; margin-bottom: 40px; line-height: 1.6; }
        .auth-features { display: flex; flex-direction: column; gap: 14px; text-align: left; }
        .auth-feature {
            display: flex; align-items: center; gap: 12px;
            background: rgba(255,255,255,0.12);
            border: 1px solid rgba(255,255,255,0.2);
            border-radius: 12px;
            padding: 12px 16px;
            font-size: 14px; font-weight: 500;
        }
        .auth-feature-icon { font-size: 20px; }

        /* Right panel */
        .auth-right {
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 60px 48px;
        }
        .auth-form-wrap {
            width: 100%;
            max-width: 420px;
        }
        .auth-form-title {
            font-size: 28px;
            font-weight: 900;
            letter-spacing: -0.5px;
            margin-bottom: 6px;
            color: var(--text-dark);
        }
        .auth-form-sub {
            font-size: 14px;
            color: var(--text-light);
            margin-bottom: 32px;
        }
        .auth-form-sub a { color: var(--primary); font-weight: 600; }

        /* Form fields */
        .form-group { margin-bottom: 18px; }
        .form-label {
            display: block;
            font-size: 13px;
            font-weight: 700;
            color: var(--text-dark);
            margin-bottom: 8px;
            letter-spacing: 0.2px;
        }
        .form-input {
            width: 100%;
            padding: 13px 16px;
            border: 1.5px solid var(--border);
            border-radius: 12px;
            font-size: 14px;
            font-family: inherit;
            color: var(--text-dark);
            background: #fff;
            transition: all 0.2s;
            outline: none;
        }
        .form-input:focus {
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(200,2,56,0.08);
        }
        .form-input::placeholder { color: var(--text-light); }
        .form-input.error-field { border-color: #dc2626; }

        /* Password wrapper */
        .input-wrap { position: relative; }
        .pw-toggle {
            position: absolute; right: 14px; top: 50%;
            transform: translateY(-50%);
            cursor: pointer; color: var(--text-light);
            font-size: 13px; font-weight: 600;
            user-select: none;
        }
        .pw-toggle:hover { color: var(--primary); }

        /* Error box */
        .error-box {
            background: #fef2f2;
            border: 1px solid #fecaca;
            border-radius: 10px;
            padding: 12px 16px;
            font-size: 13.5px;
            color: #dc2626;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        /* Submit button */
        .submit-btn {
            width: 100%;
            padding: 14px;
            background: linear-gradient(135deg, var(--primary), var(--accent));
            color: #fff;
            border: none;
            border-radius: 12px;
            font-size: 15px;
            font-weight: 700;
            cursor: pointer;
            transition: all 0.2s;
            margin-top: 8px;
            box-shadow: 0 4px 16px rgba(200,2,56,0.3);
        }
        .submit-btn:hover {
            transform: translateY(-1px);
            box-shadow: 0 6px 20px rgba(200,2,56,0.4);
        }

        /* Divider */
        .divider {
            display: flex; align-items: center; gap: 12px;
            margin: 24px 0;
            font-size: 12px; color: var(--text-light); font-weight: 500;
        }
        .divider::before, .divider::after {
            content: ''; flex: 1; height: 1px; background: var(--border);
        }

        /* Bottom link */
        .auth-switch {
            text-align: center;
            font-size: 14px;
            color: var(--text-mid);
            margin-top: 20px;
        }
        .auth-switch a { color: var(--primary); font-weight: 700; }

        @media (max-width: 768px) {
            body { grid-template-columns: 1fr; }
            .auth-left { display: none; }
            .auth-right { padding: 40px 24px; }
        }
    </style>
</head>
<body>

<!-- LEFT PANEL -->
<div class="auth-left">
    <div class="auth-left-content">
        <div class="auth-logo">🍔</div>
        <div class="auth-brand">TapFood</div>
        <p class="auth-tagline">
            India's most loved food delivery platform.<br>
            Thousands of dishes, one tap away.
        </p>
        <div class="auth-features">
            <div class="auth-feature">
                <span class="auth-feature-icon">🚀</span>
                <span>Lightning-fast delivery in 30 mins</span>
            </div>
            <div class="auth-feature">
                <span class="auth-feature-icon">🍽️</span>
                <span>10+ top-rated restaurants</span>
            </div>
            <div class="auth-feature">
                <span class="auth-feature-icon">💰</span>
                <span>Exclusive deals & offers daily</span>
            </div>
            <div class="auth-feature">
                <span class="auth-feature-icon">🔒</span>
                <span>100% secure payments</span>
            </div>
        </div>
    </div>
</div>

<!-- RIGHT PANEL — FORM -->
<div class="auth-right">
    <div class="auth-form-wrap">

        <h1 class="auth-form-title">Welcome back 👋</h1>
        <p class="auth-form-sub">
            Don't have an account?
            <a href="${pageContext.request.contextPath}/register">Sign up free</a>
        </p>

        <!-- Flash success (from registration) -->
        <c:if test="${not empty sessionScope.successMessage}">
            <div style="background:#f0fdf4;border:1px solid #bbf7d0;border-radius:10px;padding:12px 16px;font-size:13.5px;color:#15803d;margin-bottom:20px;display:flex;align-items:center;gap:8px;">
                ✅ ${sessionScope.successMessage}
            </div>
            <c:remove var="successMessage" scope="session"/>
        </c:if>

        <!-- Error -->
        <c:if test="${not empty error}">
            <div class="error-box">❌ ${error}</div>
        </c:if>

        <form action="${pageContext.request.contextPath}/login" method="post" id="loginForm">

            <div class="form-group">
                <label class="form-label" for="email">Email Address</label>
                <input class="form-input ${not empty error ? 'error-field' : ''}"
                       type="email" id="email" name="email"
                       value="${not empty emailValue ? emailValue : ''}"
                       placeholder="you@example.com"
                       required autocomplete="email">
            </div>

            <div class="form-group">
                <label class="form-label" for="password">Password</label>
                <div class="input-wrap">
                    <input class="form-input ${not empty error ? 'error-field' : ''}"
                           type="password" id="password" name="password"
                           placeholder="Enter your password"
                           required autocomplete="current-password">
                    <span class="pw-toggle" onclick="togglePw('password', this)">Show</span>
                </div>
            </div>

            <button type="submit" class="submit-btn" id="submitBtn">
                Login to TapFood →
            </button>

        </form>

        <div class="divider">OR</div>

        <div class="auth-switch">
            New to TapFood?
            <a href="${pageContext.request.contextPath}/register">Create a free account</a>
        </div>

        <div style="text-align:center;margin-top:12px;">
            <a href="${pageContext.request.contextPath}/home"
               style="font-size:13px;color:var(--text-light);">
                ← Continue browsing without login
            </a>
        </div>

    </div>
</div>

<script>
function togglePw(fieldId, btn) {
    const field = document.getElementById(fieldId);
    if (field.type === 'password') {
        field.type = 'text';
        btn.textContent = 'Hide';
    } else {
        field.type = 'password';
        btn.textContent = 'Show';
    }
}

// Loading state on submit
document.getElementById('loginForm').addEventListener('submit', function() {
    const btn = document.getElementById('submitBtn');
    btn.textContent = 'Logging in...';
    btn.disabled = true;
});
</script>
</body>
</html>
