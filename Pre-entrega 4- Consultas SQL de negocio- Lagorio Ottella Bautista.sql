use Ventas_Tech_DB;
GO
Select * from Ventas
--Consulta 1-- RESUMEN EJECUTIVO MENSUAL--

SELECT MONTH(fecha_venta) as Mes,
       SUM(cantidad * precio_unitario) as Total_facturado,
       COUNT(*) as Cantidad_Pedidos,
       AVG(cantidad * precio_unitario) as Ticket_Promedio
FROM Ventas
GROUP BY MONTH(fecha_venta);

--Consulta 2-- RANKING DE PRODUCTOS--

SELECT TOP 5 ID_Producto,
       SUM(cantidad) as  Unidades_Vendidas, 
       SUM(Precio_Unitario * cantidad) as Total_facturado
FROM Ventas
GROUP BY ID_Producto
ORDER BY Total_facturado DESC;

--Consulta 3-- CLIENTES RECURRENTES--
SELECT ID_Cliente,
       COUNT(*) as Cantidad_Pedidos,
       SUM(cantidad * Precio_Unitario) as Total_Gastado_Cliente
FROM Ventas
GROUP BY ID_Cliente
HAVING COUNT(*) > 1
ORDER BY Total_Gastado_Cliente DESC;

--Consulta 4-- PRODUCTOS POR ENCIMA/DEBAJO DEL PROMEDIO--
WITH Totales_Por_Producto AS (
    SELECT ID_Producto,
           SUM(cantidad * Precio_Unitario) AS Total_Facturado
    FROM Ventas
    GROUP BY ID_Producto
)
SELECT ID_Producto,
       Total_Facturado,
       CASE
           WHEN Total_Facturado > (SELECT AVG(Total_Facturado) FROM Totales_Por_Producto)
               THEN 'Por encima'
           ELSE 'Por debajo'
       END AS Comparacion_Promedio
FROM Totales_Por_Producto
ORDER BY Total_Facturado DESC;

--Podemos decir que cerca del 55% de la cantidad del total de las ventas del mes de marzo proviene del producto "1" con solo 3 unidades vendidas.
--El producto "2" es el más vendido, pero el que menos impacta en las ventas, ya que representa el 5,6% del total facturado.
--Solo los productos "1 y 3" facturan por encima del promedio, representando cerca del 76,8% del total de facturación. Así también se puede observar como el cliente "1 y 5" son los que más gastaron.