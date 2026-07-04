package com.tap.model;

/**
 * CartItem.java
 * Location: src/main/java/com/tap/model/CartItem.java
 *
 * Maps to the `cart` table in MySQL.
 * Also carries MenuItem details (via JOIN) for display purposes
 * so JSPs don't need separate lookups.
 */
public class CartItem {

    private int    cartId;
    private int    userId;
    private int    menuId;
    private int    quantity;

    // ── Joined from MenuItem — populated by DAO JOIN query ────
    private String name;
    private double price;
    private String image;
    private boolean isVeg;
    private int    restaurantId;
    private String restaurantName;

    // ─── Constructors ─────────────────────────────────────────

    public CartItem() {}

    /** Basic constructor — used when adding to cart */
    public CartItem(int userId, int menuId, int quantity) {
        this.userId   = userId;
        this.menuId   = menuId;
        this.quantity = quantity;
    }

    /** Full constructor — used when reading from DB with JOIN */
    public CartItem(int cartId, int userId, int menuId, int quantity,
                    String name, double price, String image, boolean isVeg,
                    int restaurantId, String restaurantName) {
        this.cartId         = cartId;
        this.userId         = userId;
        this.menuId         = menuId;
        this.quantity       = quantity;
        this.name           = name;
        this.price          = price;
        this.image          = image;
        this.isVeg          = isVeg;
        this.restaurantId   = restaurantId;
        this.restaurantName = restaurantName;
    }

    // ─── Getters ──────────────────────────────────────────────

    public int     getCartId()         { return cartId;         }
    public int     getUserId()         { return userId;         }
    public int     getMenuId()         { return menuId;         }
    public int     getQuantity()       { return quantity;       }
    public String  getName()           { return name;           }
    public double  getPrice()          { return price;          }
    public String  getImage()          { return image;          }
    public boolean isVeg()             { return isVeg;          }
    public int     getRestaurantId()   { return restaurantId;   }
    public String  getRestaurantName() { return restaurantName; }

    // ─── Setters ──────────────────────────────────────────────

    public void setCartId        (int cartId)           { this.cartId         = cartId;         }
    public void setUserId        (int userId)            { this.userId         = userId;         }
    public void setMenuId        (int menuId)            { this.menuId         = menuId;         }
    public void setQuantity      (int quantity)          { this.quantity       = quantity;       }
    public void setName          (String name)           { this.name           = name;           }
    public void setPrice         (double price)          { this.price          = price;          }
    public void setImage         (String image)          { this.image          = image;          }
    public void setVeg           (boolean isVeg)         { this.isVeg          = isVeg;          }
    public void setRestaurantId  (int restaurantId)      { this.restaurantId   = restaurantId;   }
    public void setRestaurantName(String restaurantName) { this.restaurantName = restaurantName; }

    // ─── Helper Methods ───────────────────────────────────────

    /** Total price for this line item = price × quantity */
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
        return "CartItem{cartId=" + cartId +
               ", menuId=" + menuId +
               ", name='" + name + '\'' +
               ", price=" + price +
               ", quantity=" + quantity +
               ", lineTotal=" + getLineTotal() + '}';
    }
}
