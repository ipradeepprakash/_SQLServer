/* 
Source: 
Deborah Melkin: Mastering Dynamic SQL: https://www.youtube.com/watch?v=da8VAhwejT0

*/

Q: What is Dynamic SQL?
A: SQL statements that are created ad hoc and executed.

Agenda
----------
· Use Cases
· Security
· Syntax
· Demos
· Tips & Tricks

When to Use
. "Catch All" Queries
. End User Customized Queries
. Variables for server, database, or object names

"Catch-All" Queries: A single query that tries to account for all options available.
----------------------------------------------------------------------------------------
        WHERE (VIN = @vin OR @vin IS NULL)
        AND (BaseModelID = @BaseModelID OR @BaseModelID IS NULL)
        AND (PackageID = @PackageID OR @PackageID IS NULL)
        AND (TrueCost = @TrueCost OR @TrueCost IS NULL)
        AND (InvoicePrice = @InvoicePrice OR @InvoicePrice IS NULL)

End User Customized Queries
----------------------------------------------------------------------------------------
Application has screens that display different data based on what different clients screen.

choose.

Dealership A wants:
....................
VIN
True Cost
Invoice Price

Dealership B wants:
...................
VIN
Base Model Name
Package Name
MSRP

