--Standarize Date Format
Select Saledate
from HousingSheet

Select saledateconv,CONVERT(date,Saledate)
From housingsheet

Update HousingSheet
Set SaleDate = CONVERT(date,Saledate)

Alter table housingsheet
Add Saledateconv Date;

Update HousingSheet
Set Saledateconv = Convert(Date,saledate)

Select saledateconv
From HousingSheet

--Populate Property address data

Select *
From housingsheet

Select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress , isnull (a.propertyaddress,b.PropertyAddress) as updateadd
From HousingSheet as A
join HousingSheet as B
	On a.ParcelID = B.ParcelID
	and A.[UniqueID ] <> b.[UniqueID ]
Where A.PropertyAddress is Null

Update A
Set propertyaddress = isnull (a.propertyaddress,b.PropertyAddress)
From HousingSheet as A
join HousingSheet as B
	On a.ParcelID = B.ParcelID
	and A.[UniqueID ] <> b.[UniqueID ]
Where A.PropertyAddress is Null

Select *
from HousingSheet
where PropertyAddress is null

--Breaking down propertyaddress into individual coloumns (Address, city , state)

 Select PropertyAddress
 From housingsheet
 
 Select 
 SUBSTRING(Propertyaddress,1,CHARINDEX(',',PropertyAddress)-1) as address
 ,SUBSTRING(Propertyaddress,CHARINDEX(',',PropertyAddress)+1, LEN (propertyaddress)) as address
 From HousingSheet 

 Alter Table housingsheet
 add propertyaddresssplit2  nvarchar(255);

 update housingsheet
 Set propertyaddress = SUBSTRING(Propertyaddress,1,CHARINDEX(',',PropertyAddress)-1)


  Alter Table housingsheet
 add propertyaddresscity2  nvarchar (255);

update housingsheet

 Set propertyaddress = SUBSTRING(Propertyaddress,CHARINDEX(',',PropertyAddress)+1, LEN (propertyaddress))

 Select *
 from HousingSheet

 --Breaking down owner address into individual coloumns (Address, city , state)

 Select 
 SUBSTRING (owneraddress, 1, CHARINDEX (',', owneraddress)-1) as Maqanmalik,
 SUBSTRING (owneraddress, CHARINDEX(',',OwnerAddress)+1, len (owneraddress)) as maqanmalik
 from housingsheet 

 --1st coloumn
 Alter table housingsheet
 add Maliqarea nvarchar(255);

 Update HousingSheet
 Set Maliqarea =  SUBSTRING (owneraddress, 1, CHARINDEX (',', owneraddress)-1)
 
 --2nd colomun

 alter table housingsheet
 add Maliqcity nvarchar (255);

 Update HousingSheet
 set maliqcity= SUBSTRING (owneraddress, CHARINDEX(',',OwnerAddress)+1, len (owneraddress)) 

 select *
 from HousingSheet

 --Changing owneraddress in new format

 Select owneraddress
 From HousingSheet

 Select
 PARSENAME(Replace (owneraddress,',','.'),3),
  PARSENAME(Replace (owneraddress,',','.'),2),
   PARSENAME(Replace (owneraddress,',','.'),1)
 From HousingSheet

--Change Y and N to Yes and NO in "Sold as vacant" field

Select distinct (soldasvacant),Count (Soldasvacant)
from HousingSheet
group by SoldAsVacant
order by 2

Select soldasvacant,
Case 
when Soldasvacant = 'Y' then 'Yes'
when Soldasvacant ='N' then 'No'
Else Soldasvacant
End
From HousingSheet

Update HousingSheet
set SoldAsVacant=Case 
when Soldasvacant = 'Y' then 'Yes'
when Soldasvacant ='N' then 'No'
Else Soldasvacant
End

--Remove Duplicates
With Rownumcte as (
Select *,
	ROW_NUMBER() over ( 
	Partition by Parcelid,
	propertyaddress,
	saleprice,
	saledate,
	legalreference
	order by 
	 uniqueid ) row_num
	 from HousingSheet
	 --order by ParcelID
select *
from Rownumcte
where row_num > 1
Order by PropertyAddress

--Delete unused coloumns
-- Delete Unused Columns



Select *
From HousingSheet


ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate

