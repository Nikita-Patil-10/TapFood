package com.tap.model;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;

/**
 * Order.java
 * Location: src/main/java/com/tap/model/Order.java
 *
 * Maps to the `orders` table in MySQL.
 * Also carries a List<OrderItem> for order details display.
 */
public class Order {

    private int           orderId;
    private int           userId;
    private int           restaurantId;
    private double        totalAmount;
    private double        deliveryFee;
    private double        taxAmount;
    private String        status;          // PENDING / PREPARING / OUT_FOR_DELIVERY / DELIVERED / CANCELLED
    private String        paymentMode;     // CASH_ON_DELIVERY / ONLINE / UPI
    private String        paymentStatus;   // PENDING / PAID / FAILED
    private String        deliveryAddress;
    private String        specialNotes;
    private LocalDateTime orderDate;
    private LocalDateTime updatedAt;

    // ── Joined fields — not in orders table ───────────────────
    private String        restaurantName;
    private String        restaurantImage;
    private List<OrderItem> orderItems;

    // ─── Constructors ─────────────────────────────────────────

    public Order() {}

    /** Constructor for placing a new order */
    public Order(int userId, int restaurantId, double totalAmount,
                 double deliveryFee, double taxAmount,
                 String paymentMode, String deliveryAddress, String specialNotes) {
        this.userId          = userId;
        this.restaurantId    = restaurantId;
        this.totalAmount     = totalAmount;
        this.deliveryFee     = deliveryFee;
        this.taxAmount       = taxAmount;
        this.status          = "PENDING";
        this.paymentMode     = paymentMode;
        this.paymentStatus   = "PENDING";
        this.deliveryAddress = deliveryAddress;
        this.specialNotes    = specialNotes;
    }

    // ─── Getters ──────────────────────────────────────────────

    public int           getOrderId()         { return orderId;         }
    public int           getUserId()          { return userId;          }
    public int           getRestaurantId()    { return restaurantId;    }
    public double        getTotalAmount()     { return totalAmount;     }
    public double        getDeliveryFee()     { return deliveryFee;     }
    public double        getTaxAmount()       { return taxAmount;       }
    public String        getStatus()          { return status;          }
    public String        getPaymentMode()     { return paymentMode;     }
    public String        getPaymentStatus()   { return paymentStatus;   }
    public String        getDeliveryAddress() { return deliveryAddress; }
    public String        getSpecialNotes()    { return specialNotes;    }
    public LocalDateTime getOrderDate()       { return orderDate;       }
    public LocalDateTime getUpdatedAt()       { return updatedAt;       }
    public String        getRestaurantName()  { return restaurantName;  }
    public String        getRestaurantImage() { return restaurantImage; }
    public List<OrderItem> getOrderItems()    { return orderItems;      }

    // ─── Setters ──────────────────────────────────────────────

    public void setOrderId        (int orderId)                  { this.orderId         = orderId;         }
    public void setUserId         (int userId)                   { this.userId          = userId;          }
    public void setRestaurantId   (int restaurantId)             { this.restaurantId    = restaurantId;    }
    public void setTotalAmount    (double totalAmount)           { this.totalAmount     = totalAmount;     }
    public void setDeliveryFee    (double deliveryFee)           { this.deliveryFee     = deliveryFee;     }
    public void setTaxAmount      (double taxAmount)             { this.taxAmount       = taxAmount;       }
    public void setStatus         (String status)                { this.status          = status;          }
    public void setPaymentMode    (String paymentMode)           { this.paymentMode     = paymentMode;     }
    public void setPaymentStatus  (String paymentStatus)         { this.paymentStatus   = paymentStatus;   }
    public void setDeliveryAddress(String deliveryAddress)       { this.deliveryAddress = deliveryAddress; }
    public void setSpecialNotes   (String specialNotes)          { this.specialNotes    = specialNotes;    }
    public void setOrderDate      (LocalDateTime orderDate)      { this.orderDate       = orderDate;       }
    public void setUpdatedAt      (LocalDateTime updatedAt)      { this.updatedAt       = updatedAt;       }
    public void setRestaurantName (String restaurantName)        { this.restaurantName  = restaurantName;  }
    public void setRestaurantImage(String restaurantImage)       { this.restaurantImage = restaurantImage; }
    public void setOrderItems     (List<OrderItem> orderItems)   { this.orderItems      = orderItems;      }

    // ─── Helper Methods ───────────────────────────────────────

    /** Formatted total e.g. "₹247" */
    public String getFormattedTotal() {
        return "₹" + String.format("%.0f", totalAmount);
    }

    /** Formatted order date e.g. "19 Jun 2026, 11:30 AM" */
    public String getFormattedOrderDate() {
        if (orderDate == null) return "";
        return orderDate.format(
            DateTimeFormatter.ofPattern("dd MMM yyyy, hh:mm a"));
    }

    /**
     * Returns a CSS class name for the status badge.
     * Used in JSP: class="badge badge-${order.statusCssClass}"
     */
    public String getStatusCssClass() {
        if (status == null) return "pending";
        switch (status.toUpperCase()) {
            case "PENDING":          return "pending";
            case "PREPARING":        return "preparing";
            case "OUT_FOR_DELIVERY": return "out-for-delivery";
            case "DELIVERED":        return "delivered";
            case "CANCELLED":        return "cancelled";
            default:                 return "pending";
        }
    }

    /** Human-friendly status label */
    public String getStatusDisplay() {
        if (status == null) return "Pending";
        switch (status.toUpperCase()) {
            case "PENDING":          return "Order Placed";
            case "PREPARING":        return "Preparing";
            case "OUT_FOR_DELIVERY": return "Out for Delivery";
            case "DELIVERED":        return "Delivered";
            case "CANCELLED":        return "Cancelled";
            default:                 return status;
        }
    }

    /** Status icon emoji for display */
    public String getStatusIcon() {
        if (status == null) return "🕐";
        switch (status.toUpperCase()) {
            case "PENDING":          return "🕐";
            case "PREPARING":        return "👨‍🍳";
            case "OUT_FOR_DELIVERY": return "🚴";
            case "DELIVERED":        return "✅";
            case "CANCELLED":        return "❌";
            default:                 return "🕐";
        }
    }

    public boolean isDelivered() {
        return "DELIVERED".equalsIgnoreCase(status);
    }

    public boolean isCancelled() {
        return "CANCELLED".equalsIgnoreCase(status);
    }

    @Override
    public String toString() {
        return "Order{orderId=" + orderId +
               ", restaurantId=" + restaurantId +
               ", totalAmount=" + totalAmount +
               ", status='" + status + '\'' +
               ", orderDate=" + orderDate + '}';
    }
}
