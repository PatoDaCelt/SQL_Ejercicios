# Análisis de E-commerce

Este proyecto consiste en un análisis de datos integral utilizando **PostgreSQL** para explorar el comportamiento de ventas, preferencias de clientes y rendimiento de categorías en un entorno de comercio electrónico. 

## Objetivo
Se tiene el objetivo de utilizar los datos de ventas en información estrategica que ayude a responder preguntas y se puede mejorar el negocio.

## Tecnologías utilizadas
* **Base de Datos:** PostgreSQL
* **Lenguaje:** SQL

## Estructura de la BD
Tabla: ecommerce_sales:

| Columna | Tipo de Dato | Descripción |
| :--- | :--- | :--- |
| `user_id` | VARCHAR(50) | Identificador único del cliente |
| `product_id` | VARCHAR(50) | Identificador único del producto |
| `category` | VARCHAR(100) | Categoría del producto (Sports, Beauty, etc.) |
| `price_rs` | NUMERIC | Precio original en Rupias |
| `discount_percent`| INT | Porcentaje de descuento aplicado |
| `final_price_rs` | NUMERIC | Precio final tras el descuento |
| `payment_method` | VARCHAR(50) | Método de pago utilizado |
| `purchase_date` | DATE | Fecha de la transacción |

## Querys realizadas
### Query_1:
Se encuentra que categorías del e-commerce ganan más dinero.
Clothing	    531	115314.84
Books	        534	111149.35
Home & Kitchen	549	110328.08
Sports	        520	108518.79
Toys	        523	107289.69
Beauty	        505	104215.10
Electronics	    498	100462.23

### Query_2:
Se encuentra los métodos de pago que más se usan para hacer compras dentro del e-commerce.
Credit Card	     760
UPI	             757
Debit Card	     731
Net Banking	     716
Cash on Delivery 696

### Query_3:
Se encontraron los meses con más ventas y el total recaudado.
month            total_sales  monthly_rev
October   - 2024	362	       76034.51
April     - 2024	362	       74365.13
July      - 2024	346	       72798.23
August    - 2024	344	       71506.96
March     - 2024	355	       71325.40