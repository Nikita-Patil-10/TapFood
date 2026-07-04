package com.tap.model;

import java.time.LocalDateTime;

/**
 * MenuItem.java
 * Location: src/main/java/com/tap/model/MenuItem.java
 *
 * Maps to the `menu` table in MySQL.
 * Named MenuItem (not Menu) to avoid conflict with java.awt.Menu.
 */
public class MenuItem {

    private int           menuId;
    private int           restaurantId;
    private String        name;
    private double        price;
    private String        description;
    private String        image;
    private boolean       isVeg;
    private boolean       isBestseller;
    private boolean       isAvailable;
    private String        category;        // e.g. "Starters", "Mains", "Desserts"
    private String        spiceLevel;      // "MILD", "MEDIUM", "HOT", "EXTRA_HOT"
    private LocalDateTime createdDate;

    // ─── Constructors ─────────────────────────────────────────

    public MenuItem() {}

    public MenuItem(int menuId, int restaurantId, String name, double price,
                    String description, String image, boolean isVeg,
                    boolean isBestseller, boolean isAvailable,
                    String category, String spiceLevel) {
        this.menuId       = menuId;
        this.restaurantId = restaurantId;
        this.name         = name;
        this.price        = price;
        this.description  = description;
        this.image        = image;
        this.isVeg        = isVeg;
        this.isBestseller = isBestseller;
        this.isAvailable  = isAvailable;
        this.category     = category;
        this.spiceLevel   = spiceLevel;
    }

    // ─── Getters ──────────────────────────────────────────────

    public int           getMenuId()       { return menuId;       }
    public int           getRestaurantId() { return restaurantId; }
    public String        getName()         { return name;         }
    public double        getPrice()        { return price;        }
    public String        getDescription()  { return description;  }
    public String        getImage()        { return image;        }
    public boolean       isVeg()           { return isVeg;        }
    public boolean       isBestseller()    { return isBestseller; }
    public boolean       isAvailable()     { return isAvailable;  }
    public String        getCategory()     { return category;     }
    public String        getSpiceLevel()   { return spiceLevel;   }
    public LocalDateTime getCreatedDate()  { return createdDate;  }

    // ─── Setters ──────────────────────────────────────────────

    public void setMenuId      (int menuId)               { this.menuId       = menuId;       }
    public void setRestaurantId(int restaurantId)          { this.restaurantId = restaurantId; }
    public void setName        (String name)               { this.name         = name;         }
    public void setPrice       (double price)              { this.price        = price;        }
    public void setDescription (String description)        { this.description  = description;  }
    public void setImage       (String image)              { this.image        = image;        }
    public void setVeg         (boolean isVeg)             { this.isVeg        = isVeg;        }
    public void setBestseller  (boolean isBestseller)      { this.isBestseller = isBestseller; }
    public void setAvailable   (boolean isAvailable)       { this.isAvailable  = isAvailable;  }
    public void setCategory    (String category)           { this.category     = category;     }
    public void setSpiceLevel  (String spiceLevel)         { this.spiceLevel   = spiceLevel;   }
    public void setCreatedDate (LocalDateTime createdDate) { this.createdDate  = createdDate;  }

    // ─── Helper Methods ───────────────────────────────────────

    /** Returns formatted price e.g. "₹89" */
    public String getFormattedPrice() {
        return "₹" + String.format("%.0f", price);
    }

    /** Returns "VEG" or "NON-VEG" label */
    public String getDietLabel() {
        return isVeg ? "VEG" : "NON-VEG";
    }

    /** Returns spice level as display emoji+text */
    public String getSpiceLevelDisplay() {
        if (spiceLevel == null) return "";
        switch (spiceLevel.toUpperCase()) {
            case "MILD":       return "🟢 Mild";
            case "MEDIUM":     return "🟡 Medium";
            case "HOT":        return "🔴 Hot";
            case "EXTRA_HOT":  return "🌶 Extra Hot";
            default:           return spiceLevel;
        }
    }

    @Override
    public String toString() {
        return "MenuItem{menuId=" + menuId +
               ", name='" + name + '\'' +
               ", price=" + price +
               ", isVeg=" + isVeg +
               ", isAvailable=" + isAvailable + '}';
    }
}
