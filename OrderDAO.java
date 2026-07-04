package com.tap.dao;

import com.tap.model.Order;
import com.tap.model.OrderItem;
import java.util.List;

/**
 * OrderDAO.java
 * Location: src/main/java/com/tap/dao/OrderDAO.java
 *
 * Interface defining all DB operations for Orders.
 * Implementation: com.tap.daoimpl.OrderDAOImpl
 */
public interface OrderDAO {

    /**
     * Place a new order. Inserts into `orders` table.
     * @return the generated orderId, or -1 if failed
     */
    int placeOrder(Order order);

    /**
     * Save all items for an order into `order_items` table.
     * Called immediately after placeOrder().
     */
    boolean saveOrderItems(List<OrderItem> items);

    /** Get a single order with its items by orderId */
    Order getOrderById(int orderId);

    /** Get all orders for a user — for order history page */
    List<Order> getOrdersByUser(int userId);

    /** Get order items for a specific order */
    List<OrderItem> getOrderItems(int orderId);

    /** Update order status — used by admin or tracking */
    boolean updateOrderStatus(int orderId, String status);
}
