package com.tap.model;

/**
 * OrderItem.java
 * Location: src/main/java/com/tap/model/OrderItem.java
 *
 * Maps to the `order_items` table in MySQL.
 * Price is a SNAPSHOT — the price at time of ordering,
 * not the current menu price (which may have changed).
 */
public class OrderItem {

    private int    orderItemId;
    private int    orderId;
    private int    menuId;
    private int    quantity;
    private double price;       // snapshot at order time

    // ── Joined from MenuItem — for display ────────────────────
    private String name;
    private String image;
    private boolean isVeg;

    // ─── Constructors ─────────────────────────────────────────

    public OrderItem() {}

    /** Constructor for saving a new order item */
    public OrderItem(int orderId, int menuId, int quantity, double price) {
        this.orderId  = orderId;
        this.menuId   = menuId;
        this.quantity = quantity;
        this.price    = price;
    }

    /** Full constructor — used when reading from DB with JOIN */
    public OrderItem(int orderItemId, int orderId, int menuId,
                     int quantity, double price,
                     String name, String image, boolean isVeg) {
        this.orderItemId = orderItemId;
        this.orderId     = orderId;
        this.menuId      = menuId;
        this.quantity    = quantity;
        this.price       = price;
        this.name        = name;
        this.image       = image;
        this.isVeg       = isVeg;
    }

    // ─── Getters ──────────────────────────────────────────────

    public int     getOrderItemId() { return orderItemId; }
    public int     getOrderId()     { return orderId;     }
    public int     getMenuId()      { return menuId;      }
    public int     getQuantity()    { return quantity;    }
    public double  getPrice()       { return price;       }
    public String  getName()        { return name;        }
    public String  getImage()       { return image;       }
    public boolean isVeg()          { return isVeg;       }

    // ─── Setters ──────────────────────────────────────────────

    public void setOrderItemId(int orderItemId) { this.orderItemId = orderItemId; }
    public void setOrderId    (int orderId)     { this.orderId     = orderId;     }
    public void setMenuId     (int menuId)      { this.menuId      = menuId;      }
    public void setQuantity   (int quantity)    { this.quantity    = quantity;    }
    public void setPrice      (double price)    { this.price       = price;       }
    public void setName       (String name)     { this.name        = name;        }
    public void setImage      (String image)    { this.image       = image;       }
    public void setVeg        (boolean isVeg)   { this.isVeg       = isVeg;       }

    // ─── Helper Methods ───────────────────────────────────────

    /** Line total = price × quantity */
    public double getLineTotal() {
        return price * quantity;
    }

    /** Formatted line total e.g. "₹178" */
    public String getFormattedLineTotal() {
        return "₹" + String.format("%.0f", getLineTotal());
    }

    /** Formatted unit price e.g. "₹89" */
    public String getFormattedPrice() {
        return "₹" + String.format("%.0f", price);
    }

    @Override
    public String toString() {
        return "OrderItem{orderItemId=" + orderItemId +
               ", menuId=" + menuId +
               ", name='" + name + '\'' +
               ", price=" + price +
               ", quantity=" + quantity +
               ", lineTotal=" + getLineTotal() + '}';
    }
}
