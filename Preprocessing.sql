SELECT * FROM UsedMotorbikes

--Delete column 'Title','F1'
ALTER TABLE UsedMotorbikes
DROP COLUMN F1, Title

--Replace "trước năm 1980" to "1980"
UPDATE UsedMotorbikes
SET Reg_Date=REPLACE(Reg_Date,N'trước năm 1980','1980')

--Delete "cc", replace "Không biết rõ" to Null on column Capacity
UPDATE UsedMotorbikes
SET Capacity=REPLACE(Capacity,' cc','')

UPDATE UsedMotorbikes
SET Capacity=NULLIF(Capacity, N'Không biết rõ')

--Delete rows have column Condition = "Mới"
DELETE FROM UsedMotorbikes
WHERE Condition = N'Mới'

--Delete rows if all values is null
DELETE FROM UsedMotorbikes
WHERE COALESCE(Price, Brand, Model, Reg_Date, Km, Condition, Capacity, [Type], [Location]) IS NULL

--Delete rows if Price or Km or Reg_Date or Brand or Capacity is null
DELETE FROM UsedMotorbikes
WHERE Price IS NULL OR Km IS NULL OR Reg_Date IS NULL OR Brand IS NULL OR Capacity IS NULL

SELECT * FROM UsedMotorbikes

--Delete "đ", "." and convert varchar to money on column Price
UPDATE UsedMotorbikes
SET Price=REPLACE(Price,N' đ','')

UPDATE UsedMotorbikes
SET Price=CAST(REPLACE(Price,'.','') AS money) 

--Get Province, City from Location
UPDATE UsedMotorbikes
SET Location = CASE WHEN CHARINDEX(',', REVERSE(ISNULL(Location, ''))) > 0 THEN RIGHT(ISNULL(Location, ''), (CHARINDEX(',', REVERSE(ISNULL(Location, ''))) - 2))
ELSE ISNULL(Location, '') END 
FROM dbo.UsedMotorbikes

--Check duplicate rows
SELECT DISTINCT * FROM UsedMotorbikes

--Delete rows duplicate
GO
WITH cte AS (
    SELECT Price, Brand, Model, Reg_Date, Km, Condition, Capacity, [Type], [Location], 
        ROW_NUMBER() OVER (
            PARTITION BY
                Price, Brand, Model, Reg_Date, Km, Condition, Capacity, [Type], [Location]
            ORDER BY
                Price, Brand, Model, Reg_Date, Km, Condition, Capacity, [Type], [Location]
        ) row_num
     FROM
        UsedMotorbikes
)
DELETE FROM cte
WHERE row_num > 1

SELECT * FROM UsedMotorbikes