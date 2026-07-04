<%--
    register.jsp — TapFood Registration Page
    Location: src/main/webapp/jsp/register.jsp
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
        .auth-left {
            background: linear-gradient(145deg, #FDA501 0%, var(--accent) 50%, var(--primary) 100%);
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            padding: 60px 48px;
            position: relative;
            overflow: hidden;
        }
        .auth-left::before {
            content: ''; position: absolute;
            width: 350px; height: 350px;
            background: rgba(255,255,255,0.07);
            border-radius: 50%;
            top: -80px; left: -80px;
        }
        .auth-left::after {
            content: ''; position: absolute;
            width: 250px; height: 250px;
            background: rgba(255,255,255,0.05);
            border-radius: 50%;
            bottom: -60px; right: -60px;
        }
        .auth-left-content { position: relative; z-index: 1; color: #fff; text-align: center; }
        .auth-logo   { font-size: 60px; margin-bottom: 16px; }
        .auth-brand  { font-size: 40px; font-weight: 900; letter-spacing: -2px; margin-bottom: 8px; }
        .auth-tagline{ font-size: 15px; opacity: 0.85; margin-bottom: 36px; line-height: 1.6; }
        .step-list   { display: flex; flex-direction: column; gap: 16px; text-align: left; }
        .step-item {
            display: flex; align-items: center; gap: 14px;
            background: rgba(255,255,255,0.14);
            border: 1px solid rgba(255,255,255,0.25);
            border-radius: 12px;
            padding: 14px 16px;
        }
        .step-num {
            width: 28px; height: 28px;
            background: rgba(255,255,255,0.25);
            border-radius: 50%;
            display: flex; align-items: center; justify-content: center;
            font-size: 13px; font-weight: 800;
            flex-shrink: 0;
        }
        .step-text { font-size: 14px; font-weight: 500; }

        .auth-right {
            display: flex; align-items: center; justify-content: center;
            padding: 48px;
            overflow-y: auto;
        }
        .auth-form-wrap { width: 100%; max-width: 440px; }

        .auth-form-title {
            font-size: 26px; font-weight: 900;
            letter-spacing: -0.5px; margin-bottom: 6px;
            color: var(--text-dark);
        }
        .auth-form-sub {
            font-size: 14px; color: var(--text-light); margin-bottom: 28px;
        }
        .auth-form-sub a { color: var(--primary); font-weight: 600; }

        .form-row { display: grid; grid-template-columns: 1fr 1fr; gap: 16px; }
        .form-group { margin-bottom: 16px; }
        .form-label {
            display: block; font-size: 13px; font-weight: 700;
            color: var(--text-dark); margin-bottom: 7px;
        }
        .form-label .optional {
            font-weight: 400; color: var(--text-light); font-size: 11px; margin-left: 4px;
        }
        .form-input {
            width: 100%; padding: 12px 14px;
            border: 1.5px solid var(--border);
            border-radius: 12px;
            font-size: 14px; font-family: inherit;
            color: var(--text-dark); background: #fff;
            transition: all 0.2s; outline: none;
        }
        .form-input:focus {
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(200,2,56,0.08);
        }
        .form-input::placeholder { color: var(--text-light); }
        .form-input.error-field  { border-color: #dc2626; }

        .input-wrap { position: relative; }
        .pw-toggle {
            position: absolute; right: 12px; top: 50%;
            transform: translateY(-50%);
            cursor: pointer; color: var(--text-light);
            font-size: 12px; font-weight: 600;
        }
        .pw-toggle:hover { color: var(--primary); }

        /* Password strength bar */
        .pw-strength { margin-top: 6px; }
        .pw-strength-bar {
            height: 4px; border-radius: 2px;
            background: var(--border);
            overflow: hidden; margin-bottom: 4px;
        }
        .pw-strength-fill {
            height: 100%; border-radius: 2px;
            transition: width 0.3s, background 0.3s;
            width: 0%;
        }
        .pw-strength-label { font-size: 11px; color: var(--text-light); }

        .error-box {
            background: #fef2f2; border: 1px solid #fecaca;
            border-radius: 10px; padding: 12px 16px;
            font-size: 13.5px; color: #dc2626;
            margin-bottom: 20px;
            display: flex; align-items: center; gap: 8px;
        }

        .submit-btn {
            width: 100%; padding: 14px;
            background: linear-gradient(135deg, var(--primary), var(--accent));
            color: #fff; border: none; border-radius: 12px;
            font-size: 15px; font-weight: 700;
            cursor: pointer; transition: all 0.2s;
            margin-top: 8px;
            box-shadow: 0 4px 16px rgba(200,2,56,0.3);
        }
        .submit-btn:hover {
            transform: translateY(-1px);
            box-shadow: 0 6px 20px rgba(200,2,56,0.4);
        }

        .terms-note {
            font-size: 12px; color: var(--text-light);
            text-align: center; margin-top: 14px; line-height: 1.6;
        }
        .terms-note a { color: var(--primary); }

        .auth-switch {
            text-align: center; font-size: 14px;
            color: var(--text-mid); margin-top: 20px;
        }
        .auth-switch a { color: var(--primary); font-weight: 700; }

        @media (max-width: 900px) {
            .form-row { grid-template-columns: 1fr; }
        }
        @media (max-width: 768px) {
            body { grid-template-columns: 1fr; }
            .auth-left { display: none; }
            .auth-right { padding: 32px 20px; }
        }
    </style>
</head>
<body>

<!-- LEFT PANEL -->
<div class="auth-left">
    <div class="auth-left-content">
        <div class="auth-logo">🍔</div>
        <div class="auth-brand">TapFood</div>
        <p class="auth-tagline">Join thousands of food lovers.<br>Your first order is just minutes away.</p>
        <div class="step-list">
            <div class="step-item">
                <div class="step-num">1</div>
                <div class="step-text">Create your free account</div>
            </div>
            <div class="step-item">
                <div class="step-num">2</div>
                <div class="step-text">Browse top restaurants near you</div>
            </div>
            <div class="step-item">
                <div class="step-num">3</div>
                <div class="step-text">Add items and place your order</div>
            </div>
            <div class="step-item">
                <div class="step-num">4</div>
                <div class="step-text">Get fresh food at your doorstep 🚀</div>
            </div>
        </div>
    </div>
</div>

<!-- RIGHT PANEL -->
<div class="auth-right">
    <div class="auth-form-wrap">

        <h1 class="auth-form-title">Create your account ✨</h1>
        <p class="auth-form-sub">
            Already have an account?
            <a href="${pageContext.request.contextPath}/login">Login here</a>
        </p>

        <c:if test="${not empty error}">
            <div class="error-box">❌ ${error}</div>
        </c:if>

        <form action="${pageContext.request.contextPath}/register" method="post" id="regForm">

            <!-- Name + Phone -->
            <div class="form-row">
                <div class="form-group">
                    <label class="form-label" for="username">Full Name</label>
                    <input class="form-input ${not empty error ? 'error-field' : ''}"
                           type="text" id="username" name="username"
                           value="${not empty usernameValue ? usernameValue : ''}"
                           placeholder="Arjun Sharma"
                           required maxlength="100">
                </div>
                <div class="form-group">
                    <label class="form-label" for="phone">
                        Phone <span class="optional">(optional)</span>
                    </label>
                    <input class="form-input"
                           type="tel" id="phone" name="phone"
                           value="${not empty phoneValue ? phoneValue : ''}"
                           placeholder="9876543210"
                           maxlength="10">
                </div>
            </div>

            <!-- Email -->
            <div class="form-group">
                <label class="form-label" for="email">Email Address</label>
                <input class="form-input ${not empty error ? 'error-field' : ''}"
                       type="email" id="email" name="email"
                       value="${not empty emailValue ? emailValue : ''}"
                       placeholder="you@example.com"
                       required autocomplete="email">
            </div>

            <!-- Password -->
            <div class="form-group">
                <label class="form-label" for="password">Password</label>
                <div class="input-wrap">
                    <input class="form-input"
                           type="password" id="password" name="password"
                           placeholder="Min. 6 characters"
                           required minlength="6"
                           oninput="checkStrength(this.value)"
                           autocomplete="new-password">
                    <span class="pw-toggle" onclick="togglePw('password', this)">Show</span>
                </div>
                <div class="pw-strength">
                    <div class="pw-strength-bar">
                        <div class="pw-strength-fill" id="strengthFill"></div>
                    </div>
                    <span class="pw-strength-label" id="strengthLabel"></span>
                </div>
            </div>

            <!-- Confirm Password -->
            <div class="form-group">
                <label class="form-label" for="confirmPassword">Confirm Password</label>
                <div class="input-wrap">
                    <input class="form-input"
                           type="password" id="confirmPassword" name="confirmPassword"
                           placeholder="Repeat your password"
                           required autocomplete="new-password">
                    <span class="pw-toggle" onclick="togglePw('confirmPassword', this)">Show</span>
                </div>
            </div>

            <!-- Address -->
            <div class="form-group">
                <label class="form-label" for="address">
                    Delivery Address <span class="optional">(optional)</span>
                </label>
                <input class="form-input"
                       type="text" id="address" name="address"
                       value="${not empty addressValue ? addressValue : ''}"
                       placeholder="12 MG Road, Bengaluru 560001">
            </div>

            <button type="submit" class="submit-btn" id="submitBtn">
                Create Account →
            </button>

        </form>

        <p class="terms-note">
            By creating an account, you agree to TapFood's
            <a href="#">Terms of Service</a> and <a href="#">Privacy Policy</a>.
        </p>

        <div class="auth-switch">
            Already have an account?
            <a href="${pageContext.request.contextPath}/login">Login here</a>
        </div>

    </div>
</div>

<script>
function togglePw(id, btn) {
    const f = document.getElementById(id);
    f.type = f.type === 'password' ? 'text' : 'password';
    btn.textContent = f.type === 'password' ? 'Show' : 'Hide';
}

function checkStrength(pw) {
    const fill  = document.getElementById('strengthFill');
    const label = document.getElementById('strengthLabel');
    let score = 0;
    if (pw.length >= 6)  score++;
    if (pw.length >= 10) score++;
    if (/[A-Z]/.test(pw)) score++;
    if (/[0-9]/.test(pw)) score++;
    if (/[^A-Za-z0-9]/.test(pw)) score++;

    const levels = [
        { w: '20%',  bg: '#dc2626', txt: 'Very weak' },
        { w: '40%',  bg: '#f97316', txt: 'Weak' },
        { w: '60%',  bg: '#eab308', txt: 'Fair' },
        { w: '80%',  bg: '#22c55e', txt: 'Good' },
        { w: '100%', bg: '#16a34a', txt: 'Strong 💪' },
    ];
    const lvl = levels[Math.max(0, score - 1)] || levels[0];
    fill.style.width      = pw.length ? lvl.w  : '0%';
    fill.style.background = lvl.bg;
    label.textContent     = pw.length ? lvl.txt : '';
}

document.getElementById('regForm').addEventListener('submit', function(e) {
    const pw  = document.getElementById('password').value;
    const cpw = document.getElementById('confirmPassword').value;
    if (pw !== cpw) {
        e.preventDefault();
        alert('Passwords do not match!');
        return;
    }
    const btn = document.getElementById('submitBtn');
    btn.textContent = 'Creating account...';
    btn.disabled    = true;
});
</script>
</body>
</html>
