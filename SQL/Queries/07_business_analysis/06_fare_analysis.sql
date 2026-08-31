--- QUERIES FOR MAKING FARE ANALYSIS

---How many fare products exist?
SELECT
    COUNT(*) AS total_fare_products
FROM fare_attributes;

---What are the available fare prices?
SELECT
    fare_id,
    price,
    currency_type,
    payment_method,
    transfers
FROM fare_attributes
ORDER BY price;

---What is the minimum, maximum and average fare?
SELECT
    MIN(price) AS minimum_fare,
    MAX(price) AS maximum_fare,
    ROUND(AVG(price), 2) AS average_fare
FROM fare_attributes;

---How many fare products exist by payment method?
SELECT
    payment_method,
    COUNT(*) AS fare_product_count
FROM fare_attributes
GROUP BY payment_method
ORDER BY fare_product_count DESC;

---How many fare products allow transfers?
SELECT
    transfers,
    COUNT(*) AS fare_count
FROM fare_attributes
GROUP BY transfers
ORDER BY transfers;

---What fare applies between each origin and destination?

SELECT
    fr.origin_id,
    fr.destination_id,
    fr.fare_id,
    fa.price,
    fa.currency_type
FROM fare_rules AS fr
INNER JOIN fare_attributes AS fa
    ON fr.fare_id = fa.fare_id
ORDER BY
    fr.origin_id,
    fr.destination_id,
    fa.price;

---Which origin-destination pairs have multiple fares?
SELECT
    origin_id,
    destination_id,
    GROUP_CONCAT(DISTINCT fare_id ORDER BY fare_id) AS fare_ids,
    COUNT(DISTINCT fare_id) AS fare_count
FROM fare_rules
GROUP BY
    origin_id,
    destination_id
HAVING COUNT(DISTINCT fare_id) > 1
ORDER BY
    fare_count DESC;