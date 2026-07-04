package com.tap.dao;

import com.tap.model.CartItem;
import java.util.List;

/**
 * CartDAO.java
 * Location: src/main/java/com/tap/dao/CartDAO.java
 */
public interface CartDAO {

    /** Get all cart items for a user — JOINs menu+restaurant tables */
    List<CartItem> getCartByUser(int userId);

    /** Add item to cart. If item already exists, increments quantity. */
    boolean addToCart(int userId, int menuId, int quantity);

    /** Remove a single item from cart by cartId */
    boolean removeFromCart(int cartId);

    /** Update quantity of a specific cart item */
    boolean updateQuantity(int cartId, int quantity);

    /** Delete ALL cart items for a user — called after order or restaurant switch */
    boolean clearCart(int userId);

    /** Count total items (sum of quantities) in cart — for navbar badge */
    int getCartCount(int userId);

    /** Calculate subtotal of all items in cart */
    double getCartSubtotal(int userId);

    /** Check if a specific menu item is already in user's cart */
    boolean isItemInCart(int userId, int menuId);

    /** Get cartId for a specific user+menu combination */
    int getCartId(int userId, int menuId);

    /**
     * Get the restaurantId of items currently in cart.
     * Returns 0 if cart is empty.
     * Used to detect restaurant switching.
     */
    int getCartRestaurantId(int userId);

    /**
     * Get the restaurant name of items currently in cart.
     * Returns empty string if cart is empty.
     */
    String getCartRestaurantName(int userId);
}
