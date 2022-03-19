/*
Cleaning Data in SQL Queries
*/

--Select * from dbo.NashvilleHousing

-----------------------------------------------------------------------------------------------

-- Standardize Date Format

Select SaleDateConverted, CONVERT(Date, SaleDate) from dbo.NashvilleHousing

UPDATE dbo.NashvilleHousing
SET SaleDate = CONVERT(Date, SaleDate)

ALTER TABLE dbo.NashvilleHousing
ADD SaleDateConverted Date

UPDATE dbo.NashvilleHousing
SET SaleDateConverted = CONVERT(date, SaleDate)

------------------------------------------------------------------------------------------------

-- Populate Property Address data

Select * from dbo.NashvilleHousing
--Where PropertyAddress is null
order by ParcelID


Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
from dbo.NashvilleHousing a
JOIN dbo.NashvilleHousing b
ON a.ParcelID = b.ParcelID
AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress is null

Update a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
from dbo.NashvilleHousing a
JOIN dbo.NashvilleHousing b
ON a.ParcelID = b.ParcelID
AND a.[UniqueID ] <> b.[UniqueID ]

-------------------------------------------------------------------------------------------------------------

-- Breaking out Address into Individual Columns (Address, City, State)

Select PropertyAddress
From dbo.NashvilleHousing

SELECT SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) as Address, 
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress)) as City
From dbo.NashvilleHousing

ALTER TABLE dbo.NashvilleHousing
ADD PropertySplitAddress Nvarchar(255)

UPDATE dbo.NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1)

ALTER TABLE dbo.NashvilleHousing
ADD PropertySplitCity Nvarchar(255)

UPDATE dbo.NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress))

Select * from dbo.NashvilleHousing

Select OwnerAddress from dbo.NashvilleHousing

SELECT PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3),
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2),
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)
From dbo.NashvilleHousing

ALTER TABLE dbo.NashvilleHousing
ADD OwnerSplitAddress Nvarchar(255)

UPDATE dbo.NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)

ALTER TABLE dbo.NashvilleHousing
ADD OwnerSplitCity Nvarchar(255)

UPDATE dbo.NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)

ALTER TABLE dbo.NashvilleHousing
ADD OwnerSplitState Nvarchar(255)

UPDATE dbo.NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)

SELECT * FROM dbo.NashvilleHousing

---------------------------------------------------------------------------------------------------------------------------------

-- Change Y and N to Yes and No in "Sold as Vacant" field

Select Distinct SoldAsVacant, COUNT(SoldAsVacant)
From dbo.NashvilleHousing
Group by SoldAsVacant
order by 2


SELECT SoldAsVacant,
	CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
	WHEN SoldAsVacant = 'N' THEN 'No'
	ELSE SoldAsVacant
	END
From dbo.NashvilleHousing

UPDATE NashvilleHousing
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
	WHEN SoldAsVacant = 'N' THEN 'No'
	ELSE SoldAsVacant
	END

------------------------------------------------------------------------------------------------------

-- Remove Duplicates
WITH RowNumCTE AS(
SELECT *, ROW_NUMBER() OVER(PARTITION BY
								ParcelID, 
								PropertyAddress,
								SalePrice, 
								SaleDate, 
								LegalReference
								ORDER BY
								UniqueID) row_num
FROM dbo.NashvilleHousing)
--order by ParcelID

DELETE FROM RowNumCTE WHERE row_num > 1

-------------------------------------------------------------------------------------------------------

-- Delete Unused columns

ALTER TABLE dbo.NashvilleHousing DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress
ALTER TABLE dbo.NashvilleHousing DROP COLUMN SaleDate
SELECT * FROM dbo.NashvilleHousing