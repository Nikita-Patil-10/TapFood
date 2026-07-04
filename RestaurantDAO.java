package com.tap.dao;

import com.tap.model.Restaurant;
import java.util.List;

/**
 * RestaurantDAO.java
 * Location: src/main/java/com/tap/dao/RestaurantDAO.java
 *
 * Interface defining all DB operations for the Restaurant entity.
 * Implementation: com.tap.daoimpl.RestaurantDAOImpl
 */
public interface RestaurantDAO {

    /** Get all active restaurants — used on homepage */
    List<Restaurant> getAllActiveRestaurants();

    /** Get single restaurant by ID — used on restaurant detail/menu page */
    Restaurant getRestaurantById(int restaurantId);

    /** Search restaurants by name or cuisine type */
    List<Restaurant> searchRestaurants(String keyword);

    /** Get top-rated restaurants (ratings >= 4.5) */
    List<Restaurant> getTopRatedRestaurants();

    /** Get restaurants sorted by fastest delivery time */
    List<Restaurant> getRestaurantsByDeliveryTime();

    /** Get pure-veg restaurants only */
    List<Restaurant> getVegRestaurants();

    /** Get restaurants by cuisine type e.g. "South Indian", "Italian" */
    List<Restaurant> getRestaurantsByCuisine(String cuisineType);
}
