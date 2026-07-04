package com.tap.model;

import java.time.LocalDateTime;

/**
 * Restaurant.java
 * Location: src/main/java/com/tap/model/Restaurant.java
 *
 * Maps to the `restaurant` table in MySQL.
 * Carries colorPrimary + colorSecondary for dynamic theming.
 */
public class Restaurant {

    private int           restaurantId;
    private String        name;
    private String        address;
    private String        city;
    private String        phone;
    private double        ratings;
    private boolean       isActive;
    private String        imagePath;
    private int           deliveryTime;      // in minutes
    private double        deliveryFee;
    private double        minOrderAmount;
    private String        description;
    private String        cuisineType;
    private String        colorPrimary;      // hex e.g. "#FDA501"
    private String        colorSecondary;    // hex e.g. "#C80238"
    private String        offerText;         // e.g. "50% OFF up to ₹100"
    private LocalDateTime createdDate;

    // ─── Constructors ─────────────────────────────────────────

    public Restaurant() {}

    /** Minimal constructor for listing cards */
    public Restaurant(int restaurantId, String name, String address,
                      String city, double ratings, String imagePath,
                      int deliveryTime, double deliveryFee,
                      String cuisineType, String colorPrimary,
                      String colorSecondary, String offerText, boolean isActive) {
        this.restaurantId   = restaurantId;
        this.name           = name;
        this.address        = address;
        this.city           = city;
        this.ratings        = ratings;
        this.imagePath      = imagePath;
        this.deliveryTime   = deliveryTime;
        this.deliveryFee    = deliveryFee;
        this.cuisineType    = cuisineType;
        this.colorPrimary   = colorPrimary;
        this.colorSecondary = colorSecondary;
        this.offerText      = offerText;
        this.isActive       = isActive;
    }

    // ─── Getters ──────────────────────────────────────────────

    public int           getRestaurantId()   { return restaurantId;   }
    public String        getName()           { return name;           }
    public String        getAddress()        { return address;        }
    public String        getCity()           { return city;           }
    public String        getPhone()          { return phone;          }
    public double        getRatings()        { return ratings;        }
    public boolean       isActive()          { return isActive;       }
    public String        getImagePath()      { return imagePath;      }
    public int           getDeliveryTime()   { return deliveryTime;   }
    public double        getDeliveryFee()    { return deliveryFee;    }
    public double        getMinOrderAmount() { return minOrderAmount; }
    public String        getDescription()    { return description;    }
    public String        getCuisineType()    { return cuisineType;    }
    public String        getColorPrimary()   { return colorPrimary;   }
    public String        getColorSecondary() { return colorSecondary; }
    public String        getOfferText()      { return offerText;      }
    public LocalDateTime getCreatedDate()    { return createdDate;    }

    // ─── Setters ──────────────────────────────────────────────

    public void setRestaurantId  (int restaurantId)          { this.restaurantId   = restaurantId;   }
    public void setName          (String name)                { this.name           = name;           }
    public void setAddress       (String address)             { this.address        = address;        }
    public void setCity          (String city)                { this.city           = city;           }
    public void setPhone         (String phone)               { this.phone          = phone;          }
    public void setRatings       (double ratings)             { this.ratings        = ratings;        }
    public void setActive        (boolean isActive)           { this.isActive       = isActive;       }
    public void setImagePath     (String imagePath)           { this.imagePath      = imagePath;      }
    public void setDeliveryTime  (int deliveryTime)           { this.deliveryTime   = deliveryTime;   }
    public void setDeliveryFee   (double deliveryFee)         { this.deliveryFee    = deliveryFee;    }
    public void setMinOrderAmount(double minOrderAmount)      { this.minOrderAmount = minOrderAmount; }
    public void setDescription   (String description)         { this.description    = description;    }
    public void setCuisineType   (String cuisineType)         { this.cuisineType    = cuisineType;    }
    public void setColorPrimary  (String colorPrimary)        { this.colorPrimary   = colorPrimary;   }
    public void setColorSecondary(String colorSecondary)      { this.colorSecondary = colorSecondary; }
    public void setOfferText     (String offerText)           { this.offerText      = offerText;      }
    public void setCreatedDate   (LocalDateTime createdDate)  { this.createdDate    = createdDate;    }

    // ─── Helper Methods ───────────────────────────────────────

    /** Returns formatted rating e.g. "4.5" */
    public String getFormattedRating() {
        return String.format("%.1f", ratings);
    }

    /** Returns delivery time as display string e.g. "25-30 mins" */
    public String getDeliveryTimeDisplay() {
        return deliveryTime + "-" + (deliveryTime + 5) + " mins";
    }

    /** Returns formatted delivery fee e.g. "₹30" or "FREE" */
    public String getDeliveryFeeDisplay() {
        if (deliveryFee <= 0) return "FREE";
        return "₹" + (int) deliveryFee;
    }

    /** True if restaurant has an active offer badge */
    public boolean hasOffer() {
        return offerText != null && !offerText.trim().isEmpty();
    }

    @Override
    public String toString() {
        return "Restaurant{restaurantId=" + restaurantId +
               ", name='" + name + '\'' +
               ", cuisineType='" + cuisineType + '\'' +
               ", ratings=" + ratings +
               ", isActive=" + isActive + '}';
    }
}
