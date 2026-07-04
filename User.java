package com.tap.model;

import java.time.LocalDateTime;

/**
 * User.java
 * Location: src/main/java/com/tap/model/User.java
 *
 * Maps to the `user` table in MySQL.
 * Stored in HttpSession after login as SESSION_USER.
 */
public class User {

    private int           userId;
    private String        username;
    private String        password;      // BCrypt hash — never expose in JSP
    private String        email;
    private String        phone;
    private String        address;
    private String        role;          // "CUSTOMER" or "ADMIN"
    private boolean       isActive;
    private LocalDateTime createdDate;

    // ─── Constructors ─────────────────────────────────────────

    public User() {}

    /** Constructor for registration */
    public User(String username, String password, String email,
                String phone, String address, String role) {
        this.username  = username;
        this.password  = password;
        this.email     = email;
        this.phone     = phone;
        this.address   = address;
        this.role      = role;
        this.isActive  = true;
    }

    /** Full constructor — used when reading from DB */
    public User(int userId, String username, String password, String email,
                String phone, String address, String role,
                boolean isActive, LocalDateTime createdDate) {
        this.userId      = userId;
        this.username    = username;
        this.password    = password;
        this.email       = email;
        this.phone       = phone;
        this.address     = address;
        this.role        = role;
        this.isActive    = isActive;
        this.createdDate = createdDate;
    }

    // ─── Getters ──────────────────────────────────────────────

    public int           getUserId()     { return userId;      }
    public String        getUsername()   { return username;    }
    public String        getPassword()   { return password;    }
    public String        getEmail()      { return email;       }
    public String        getPhone()      { return phone;       }
    public String        getAddress()    { return address;     }
    public String        getRole()       { return role;        }
    public boolean       isActive()      { return isActive;    }
    public LocalDateTime getCreatedDate(){ return createdDate; }

    // ─── Setters ──────────────────────────────────────────────

    public void setUserId     (int userId)              { this.userId      = userId;      }
    public void setUsername   (String username)          { this.username    = username;    }
    public void setPassword   (String password)          { this.password    = password;    }
    public void setEmail      (String email)             { this.email       = email;       }
    public void setPhone      (String phone)             { this.phone       = phone;       }
    public void setAddress    (String address)           { this.address     = address;     }
    public void setRole       (String role)              { this.role        = role;        }
    public void setActive     (boolean isActive)         { this.isActive    = isActive;    }
    public void setCreatedDate(LocalDateTime createdDate){ this.createdDate = createdDate; }

    // ─── Helper Methods ───────────────────────────────────────

    public boolean isAdmin() {
        return "ADMIN".equalsIgnoreCase(this.role);
    }

    public boolean isCustomer() {
        return "CUSTOMER".equalsIgnoreCase(this.role);
    }

    /** Returns first name only — useful for greeting in navbar */
    public String getFirstName() {
        if (username == null || username.trim().isEmpty()) return "";
        return username.trim().split("\\s+")[0];
    }

    @Override
    public String toString() {
        return "User{userId=" + userId +
               ", username='" + username + '\'' +
               ", email='" + email + '\'' +
               ", role='" + role + '\'' +
               ", isActive=" + isActive + '}';
    }
}
