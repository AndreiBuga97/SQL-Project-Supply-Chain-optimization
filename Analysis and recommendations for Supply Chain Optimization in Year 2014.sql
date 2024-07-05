
-- Analysis and recommendations for Supply Chain Optimization in Year 2014.
-- Data Base used: Adventure Works 2016


-- Example of test: Checking if there is any product that does not have an associated vnedor.

select pv.[Name]
from Purchasing.Vendor pv
	left join Purchasing.Vendor v
		on pv.BusinessEntityID = v.BusinessEntityID
where v.BusinessEntityID is null

-- Checking if there are purchase orders without order details. This could indicate an issue with the order registration process.

select h.PurchaseOrderID
from Purchasing.PurchaseOrderHeader h
	left join Purchasing.PurchaseOrderDetail d
		on h.PurchaseOrderID=d.PurchaseOrderID
WHERE d.PurchaseOrderDetailID is null

-- Checking if there are products that have not been purchased in year 2014. These products may be considered to be removed from inventory.
-- Below is a query showing a list of ProductID and their names that have not been ordered in 2014:

select P.ProductID, P.[Name]
from Production.Product P
where not exists (
    select 1 
    from Purchasing.PurchaseOrderDetail POD
    join Purchasing.PurchaseOrderHeader POH on POD.PurchaseOrderID = POH.PurchaseOrderID
    where POD.ProductID = P.ProductID AND YEAR(POH.OrderDate) = 2014
				)
-- To verify the accuracy of the data obtained from the above query, we are querying for ProductID 1:


select POH.OrderDate, POD.ProductID
from Purchasing.PurchaseOrderDetail POD
	join Purchasing.PurchaseOrderHeader POH
		on POD.PurchaseOrderID = POH.PurchaseOrderID
where POD.ProductID = 1 AND YEAR(POH.OrderDate) = 2014


--  Checking if we have products that haven't been ordered .

-- Conclusion, all the products have been ordered at least once - no null values.

select d.ProductID,
	v.[Name] as ProductName
from Purchasing.Vendor v
	join Purchasing.PurchaseOrderHeader h
		on v.BusinessEntityID=h.VendorID
	left join Purchasing.PurchaseOrderDetail d
		on h.PurchaseOrderID=d.PurchaseOrderID
where d.ProductID is null ;

-- Analyzing the trend for years (2012-2014)

-- Showing the top 5 least ordered products in year 2014.

with ProductsOrdered as (
						select  d.ProductID,
								p.[Name] as ProductName,
								v.[Name] as VendorName,
								FORMAT(SUM(d.OrderQty),'#,###') as TotalOrderQty2014,
								FORMAT(SUM(d.LineTotal),'#,###') as TotalAmount2014,
								RANK() over (order by  SUM(d.OrderQty) asc,SUM(d.LineTotal) asc) as ProductRank
						from Purchasing.PurchaseOrderDetail d
							join Purchasing.PurchaseOrderHeader h
								on d.PurchaseOrderID=h.PurchaseOrderID
							join Purchasing.Vendor v
								on v.BusinessEntityID=h.VendorID
							join Production.Product p
								on p.ProductID=d.ProductID
						where YEAR(h.OrderDate)=2014
						group by d.ProductID,p.[Name],v.[Name]
						)
select top 5  ProductID,
	ProductName,
	VendorName,
	TotalAmount2014,
	TotalOrderQty2014,
	ProductRank
from ProductsOrdered;


-- Showing the top 5 least ordered products in year 2013.

with ProductsOrdered as (
						select  d.ProductID,
								p.[Name] as ProductName,
								v.[Name] as VendorName,
								FORMAT(SUM(d.OrderQty),'#,###') as TotalOrderQty2013,
								FORMAT(SUM(d.LineTotal),'#,###') as TotalAmount2013,
								RANK() over (order by  SUM(d.OrderQty) asc,SUM(d.LineTotal) asc) as ProductRank
						from Purchasing.PurchaseOrderDetail d
							join Purchasing.PurchaseOrderHeader h
								on d.PurchaseOrderID=h.PurchaseOrderID
							join Purchasing.Vendor v
								on v.BusinessEntityID=h.VendorID
							join Production.Product p
								on p.ProductID=d.ProductID
						where YEAR(h.OrderDate)=2013
						group by d.ProductID,p.[Name],v.[Name]
						)
select top 5  ProductID,
	ProductName,
	VendorName,
	TotalAmount2013,
	TotalOrderQty2013,
	ProductRank
from ProductsOrdered;

-- Showing the top 5 least ordered products in year 2012.

with ProductsOrdered as (
						select  d.ProductID,
								p.[Name] as ProductName,
								v.[Name] as VendorName,
								FORMAT(SUM(d.OrderQty),'#,###') as TotalOrderQty2012,
								FORMAT(SUM(d.LineTotal),'#,###') as TotalAmount2012,
								RANK() over (order by  SUM(d.OrderQty) asc,SUM(d.LineTotal) asc) as ProductRank
						from Purchasing.PurchaseOrderDetail d
							join Purchasing.PurchaseOrderHeader h
								on d.PurchaseOrderID=h.PurchaseOrderID
							join Purchasing.Vendor v
								on v.BusinessEntityID=h.VendorID
							join Production.Product p
								on p.ProductID=d.ProductID
						where YEAR(h.OrderDate)=2012
						group by d.ProductID,p.[Name],v.[Name]
						)
select top 5  ProductID,
	ProductName,
	VendorName,
	TotalAmount2012,
	TotalOrderQty2012,
	ProductRank
from ProductsOrdered;


-- Showing the top 5 least ordered products in Q4, 2014.


with ProductsOrdered as (
						select  d.ProductID,
								p.[Name] as ProductName,
								v.[Name] as VendorName,
								FORMAT(SUM(d.OrderQty),'#,###') as TotalOrderQtyQ4,
								FORMAT(SUM(d.LineTotal),'#,###') as TotalAmountQ4,
								RANK() over (order by SUM(d.OrderQty) asc, SUM(d.LineTotal) asc) as ProductRank
						from Purchasing.PurchaseOrderDetail d
							join Purchasing.PurchaseOrderHeader h
								on d.PurchaseOrderID=h.PurchaseOrderID
							join Purchasing.Vendor v
								on v.BusinessEntityID=h.VendorID
							join Production.Product p
								on p.ProductID=d.ProductID
						where DATEPART(QUARTER,h.OrderDate)=4
						group by d.ProductID,p.[Name],v.[Name]
						)
select top 5  ProductID,
	ProductName,
	VendorName,
	TotalOrderQtyQ4,
	TotalAmountQ4,
	ProductRank
from ProductsOrdered;
-- Top 5 least  ordered and products in last the Month of 2014.

with ProductsOrdered as (
						select  d.ProductID,
								p.[Name] as ProductName,
								v.[Name] as VendorName,
								FORMAT(SUM(d.OrderQty),'#,###') as TotalOrderQtyLastMonth,
								FORMAT(SUM(d.LineTotal),'#,###') as TotalAmountLastMonth,
								RANK() over (order by SUM(d.OrderQty) asc, SUM(d.LineTotal) asc) as ProductRank
						from Purchasing.PurchaseOrderDetail d
							join Purchasing.PurchaseOrderHeader h
								on d.PurchaseOrderID=h.PurchaseOrderID
							join Purchasing.Vendor v
								on v.BusinessEntityID=h.VendorID
							join Production.Product p
								on p.ProductID=d.ProductID
						where DATEPART(MONTH,h.OrderDate)=12
						group by d.ProductID,p.[Name],v.[Name]
						)
select top 5  ProductID,
	ProductName,
	VendorName,
	TotalOrderQtyLastMonth,
	TotalAmountLastMonth,
	ProductRank
from ProductsOrdered;

-- Showing the top 10 least used vendors used in 2014.

with ProductsOrdered as (
						select  v.BusinessEntityID as VendorID,
								v.[Name] as VendorName,
								v.CreditRating,
								v.PreferredVendorStatus,
								v.ActiveFlag,
								FORMAT(SUM(d.OrderQty),'#,###') as TotalOrderQty2014,
								RANK() over (order by SUM(d.OrderQty) asc) as ProductRank
						from Purchasing.PurchaseOrderDetail d
							join Purchasing.PurchaseOrderHeader h
								on d.PurchaseOrderID=h.PurchaseOrderID
							join Purchasing.Vendor v
								on v.BusinessEntityID=h.VendorID
						where YEAR(h.OrderDate)=2014
						group by v.BusinessEntityID,v.[Name],v.CreditRating,v.PreferredVendorStatus,v.ActiveFlag
						)
select top 10 VendorID,
	VendorName,
	TotalOrderQty2014,
	ProductRank,
	CreditRating,
	PreferredVendorStatus,
	ActiveFlag
from ProductsOrdered
where CreditRating <>1

-- Creating the pannel in order to check data easier.

select h.PurchaseOrderID,h.VendorID,h.OrderDate,h.SubTotal,
	d.OrderQty, d.ProductID, d.LineTotal,d.ReceivedQty,d.RejectedQty,d.StockedQty,
	v.BusinessEntityID, v.[Name] as VendorName, v.CreditRating, v.PreferredVendorStatus, v.ActiveFlag,
	pv.AverageLeadTime, pv.StandardPrice, pv.MinOrderQty, pv.MaxOrderQty,
	s.ShipMethodID, s.[Name] as ShipMethodName, s.ShipBase, s.ShipRate,
	i.Quantity,
	p.[Name] as ProductName, p.ProductNumber, p.StandardCost, p.ListPrice
into #pannel_Data2014
from Purchasing.PurchaseOrderDetail d
		join Purchasing.PurchaseOrderHeader h
			on d.PurchaseOrderID=h.PurchaseOrderID
		join Purchasing.Vendor v
			on v.BusinessEntityID=h.VendorID
		join Purchasing.ShipMethod s
			on h.ShipMethodID=s.ShipMethodID
		join Production.Product p
			on p.ProductID=d.ProductID
		join Production.ProductInventory i
			on p.ProductID=i.ProductID
		join Purchasing.ProductVendor pv
			on pv.ProductID=p.ProductID
where YEAR(h.OrderDate)=2014


-- Testing the pannel

select *
from #pannel_Data2014


select SubTotal
from Purchasing.PurchaseOrderHeader
where VendorID=1678 and PurchaseOrderID=1962

-- INVENTORY:

select  i.ProductID,
		p.[name] as ProductName,
		v.StandardPrice,
		p.StandardCost,
        SUM(i.Quantity) as InventoryQty
from Production.ProductInventory i
	join Production.Product p
		on p.ProductID=i.ProductID
	join Purchasing.ProductVendor v
		on p.ProductID=v.ProductID
where p.StandardCost=0
group by i.ProductID, p.[Name],v.StandardPrice,	p.StandardCost
order by i.ProductID

-- Question: Why there are 338 Products that have StandardCost=0?


select  i.ProductID,
		p.[name] as ProductName,
		v.StandardPrice,
		Round(p.StandardCost,2),
        SUM(i.Quantity) as InventoryQty,
		SUM(i.Quantity)*p.StandardCost as InventoryTotalAmountPerProduct,
		SUM(i.Quantity)*v.StandardPrice as InventoryAmountPerStandardPriceProduct
from Production.ProductInventory i
	join Production.Product p
		on p.ProductID=i.ProductID
	join Purchasing.ProductVendor v
		on p.ProductID=v.ProductID
where p.StandardCost<>0 and p.ListPrice<>0
group by i.ProductID, p.[Name],v.StandardPrice,	p.StandardCost
order by InventoryTotalAmountPerProduct desc

-- List of Products in Stock for Inventory:

select  i.ProductID,
		p.[name] as ProductName,
		v.StandardPrice,
		Round(p.StandardCost,2),
        SUM(i.Quantity) as InventoryQty,
		Format(SUM(i.Quantity)*p.StandardCost,'#,###') as InventoryTotalAmountPerProduct,
		Format(SUM(i.Quantity)*v.StandardPrice,'#,###') as InventoryAmountPerStandardPriceProduct
from Production.ProductInventory i
	join Production.Product p
		on p.ProductID=i.ProductID
	join Purchasing.ProductVendor v
		on p.ProductID=v.ProductID
where p.StandardCost<>0 and p.ListPrice<>0
group by i.ProductID, p.[Name],v.StandardPrice,	p.StandardCost
order by InventoryTotalAmountPerProduct desc


-- Things to do to improve the inventory:

-- First Check the top 5  least Products Ordered;

with ProductsOrdered as (
						select  d.ProductID,
								p.[Name] as ProductName,
								v.[Name] as VendorName,
								FORMAT(SUM(d.OrderQty),'#,###') as TotalOrderQty2014,
								FORMAT(SUM(d.LineTotal),'#,###') as TotalAmount2014,
								RANK() over (order by  SUM(d.OrderQty) asc, SUM(d.LineTotal) asc) as ProductRank
						from Purchasing.PurchaseOrderDetail d
							join Purchasing.PurchaseOrderHeader h
								on d.PurchaseOrderID=h.PurchaseOrderID
							join Purchasing.Vendor v
								on v.BusinessEntityID=h.VendorID
							join Production.Product p
								on p.ProductID=d.ProductID
						where YEAR(h.OrderDate)=2014
						group by d.ProductID,p.[Name],v.[Name]
						)
select top 5  ProductID,
	ProductName,
	VendorName,
	TotalAmount2014,
	TotalOrderQty2014,
	ProductRank
from ProductsOrdered;

-- Second, comparing them to the Inventory List above;
/*
	QUESTION: 
	Why the Standard Cost and List Price is 0?

	OBSERVATION:
	We can see that even though we have a significant stock in Inventory List, the Standard Cost, List Price, InventoryAmountPerInventoryProduct and InventoryAmountPerListPriceProduct are 0.

	RECOMMANDATIONS:
	a) A Marketing campaign, promotion to sell those products so we can clear the inventory stock;
	b) Inform the Buying Department that those products are no longer avalilable to order.

	*/

select  i.ProductID,
		p.[name] as ProductName,
		p.ListPrice,
		p.StandardCost,
        SUM(i.Quantity) as InventoryQty,
		SUM(i.Quantity)*p.StandardCost as InventoryAmountPerInventoryProduct,
		SUM(i.Quantity)*p.ListPrice as InventoryAmountPerListPriceProduct
from Production.ProductInventory i
	join Production.Product p
		on p.ProductID=i.ProductID
where p.ProductID in (451,453,381,448,450)
group by i.ProductID, p.[Name],p.ListPrice,	p.StandardCost
order by InventoryAmountPerInventoryProduct desc

-- fnGetProductInventory Function - This function provides the current stock for a specific product. (It could be a tool for the daily activity for the inventory manager).

create function fnGetProductInventory (@prmProductID int)
returns int
as
begin
	declare @Inventory int;

	select @Inventory=SUM(Quantity)
	from Production.ProductInventory
	where ProductID=@prmProductID;

	return @Inventory;
end;

-- Example of a query from wich we can retrieve relevant data for verifying the newly created function:

select ProductID,
		SUM	(Quantity) as TotalStock
from Production.ProductInventory
group by ProductID
order by TotalStock desc

--Calling the function :

select dbo.fnGetProductInventory(379);



/* Checking if there are vendors who have not received orders in the last 18  and 24 months.
These suppliers could be reviewed for possible discontinuation of the business relationship. */

-- A query to show the vendors who have not received orders for 18 months:

--18 Months

select BusinessEntityID,
		[Name] as VendorName,
		ActiveFlag,
		PreferredVendorStatus,
		CreditRating
from Purchasing.Vendor
where BusinessEntityID not in (
								select VendorID
								from Purchasing.PurchaseOrderHeader
								where OrderDate>DATEADD(month, -18, '2014-12-31')
								)
								--18 Vendors 
--24 Months

select BusinessEntityID as VendorID,
		[Name] as VendorName,
		ActiveFlag,
		PreferredVendorStatus,
		CreditRating
from Purchasing.Vendor
where BusinessEntityID not in (
								select VendorID
								from Purchasing.PurchaseOrderHeader 
								where OrderDate>DATEADD(month, -24, '2014-12-31')
								)
								--18 Vendors 



-- Calculating he delivery deadline :
 /*
OBSERVATIONS: Out of 86 vendors, 78 estimated a delivery time of 35 days. 8 of these vendors offer a minimum term of 45 days, which is too long from our perspective.

RECOMENDATIONS:
a) Inform the necessary departments to engage with the 7 vendors and change/optimize the delivery procedure to achieve a reduced delivery time.
b) Modify performance ratings

*/

SELECT *
FROM   (SELECT DISTINCT b.NAME,
						COUNT(pc.BusinessEntityID) as NoOfOrders,
						pc.CreditRating as VendorQuality,
						pc.PreferredVendorStatus as PRefferedVendor,
						pc.ActiveFlag,
                        v.AverageLeadTime AS NoOfDaysforDelivery,
                        CASE
                          WHEN v.AverageLeadTime  <= 37 THEN
                          'Standard'
                          WHEN v.AverageLeadTime > 37 THEN
                          'Late'
                        END                        AS StatusVendor
        FROM   purchasing.purchaseorderheader a
                JOIN purchasing.vendor b
                       ON a.vendorid = b.businessentityid
			    JOIN Purchasing.ProductVendor v
					   ON b.BusinessEntityID=v.BusinessEntityID
			    JOIN Purchasing.Vendor pc
					   ON v.BusinessEntityID=pc.BusinessEntityID
		WHERE YEAR(OrderDate)=2014
        GROUP  BY b.NAME,
                  v.AverageLeadTime,
				  pc.CreditRating ,
				  pc.PreferredVendorStatus,
				  pc.ActiveFlag) AJ
WHERE  StatusVendor = 'Late' 
order by NoOfDaysforDelivery;

 -- How can we optimize the Purchase Orders to reduce transportation costs?

  /*
  ShipBase = Minimum shipping charge.
  ShipRate = Shipping charge per pound.
  Status   = [1 = Pending; 2 = Approved; 3 = Rejected; 4 = Complete]
  */

-- Total number of Purchase Orders for each delivery method:

SELECT COUNT(PurchaseOrderID) AS TotalOrders,
       h.ShipMethodID,
       s.[Name]
FROM   Purchasing.PurchaseOrderHeader h
       JOIN Purchasing.ShipMethod s
			ON h.ShipMethodID = s.ShipMethodID
GROUP  BY h.ShipMethodID,
          s.[Name]
ORDER  BY TotalOrders desc
 
-- Total number of purchase orders, costs per ShipMethod:


  /*
  OBSERVATIONS: 

  a) ShipMethod 3 is the only one experiencing delays, and it also has the highest costs both in ShipBase and in ShipRate. 
  b)The majority of orders are made using ShipMethod 4 and 5, BUT the costs of Ship-Method 1 are much more advantageous/cheaper. 

  RECOMMANDATIONS:

  a) Using ShipMethod 3 only in urgent cases when we have exhausted the other four options.
  b) Reviewing the policy to collaborate more with ShipMethod 1 in the future to reduce costs.

  */

SELECT COUNT(purchaseorderid)            AS NoOfOrders,
	   m.[Name],
       h.ShipMethodID,
       m.ShipBase,
       m.ShipRate,
	   RANK() OVER ( order by ShipBase+ShipRate) as RankMinCosts
FROM   Purchasing.PurchaseOrderHeader h
       RIGHT JOIN Purchasing.ShipMethod m
               ON h.ShipMethodID = m.ShipMethodID
GROUP  BY h.ShipMethodID,
          m.ShipBase,
          m.ShipRate,
		  m.[Name]
ORDER  BY RankMinCosts
 
-- How fast does each ShipMethod deliver?

SELECT COUNT(purchaseorderid)             AS NoOfOrders,
       DATEDIFF(DAY, orderdate, shipdate) AS NoOfDaysPerOrder,
       ShipMethodID
FROM   Purchasing.PurchaseOrderHeader
GROUP  BY shipmethodid, DATEDIFF(DAY, OrderDate, ShipDate) 


-- Statuses grouped by shipping method and prices:

SELECT COUNT(*)AS NoOFOrders,
       [Status],
       h.ShipMethodID,
       m.ShipBase,
       m.ShipRate
FROM   Purchasing.PurchaseOrderHeader h
       JOIN Purchasing.shipmethod m
			ON h.ShipMethodID = m.ShipMethodID
GROUP  BY status,
          h.ShipMethodID,
          m.ShipBase,
          m.ShipRate
ORDER  BY status,
          h.ShipMethodID 

-- Grouped by YEAR/QARTER:

SELECT YEAR(OrderDate)                    AS 'YEAR',
       DATEPART(QUARTER, OrderDate)       AS 'Quarter',
       COUNT(PurchaseOrderID)            AS NoOfOrders,
       h.ShipMethodID,
       m.ShipBase,
       m.ShipRate
FROM   Purchasing.purchaseorderheader h
       RIGHT JOIN Purchasing.ShipMethod m
               ON h.ShipMethodID = m.ShipMethodID
WHERE YEAR(orderdate) =2014
GROUP  BY h.ShipMethodID,
          m.ShipBase,
          m.ShipRate,
          DATEPART(QUARTER, OrderDate),
          YEAR(OrderDate)
ORDER  BY 'YEAR','Quarter', ShipMethodID
