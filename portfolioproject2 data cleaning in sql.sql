--populate property address data
select * 
from STOREDB..nationalhousing
--standardize the datetime
select SaleDate,CONVERT(date,SaleDate) as perfectDate
from STOREDB..nationalhousing


update nationalhousing
set SaleDate=CONVERT(date,SaleDate)
alter table nationalhousing
add SaleDateConverted Date;
update nationalhousing
set SaleDateConverted=CONVERT(date,SaleDate)
select SaleDateConverted,CONVERT(date,SaleDate) as perfectDate
from STOREDB..nationalhousing

--property address data

select PropertyAddress
from STOREDB..nationalhousing
where PropertyAddress is null


select *
from STOREDB..nationalhousing
--where PropertyAddress is null
order by ParcelID

select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress, isnull(a.PropertyAddress,b.PropertyAddress)
from STOREDB..nationalhousing a
join STOREDB..nationalhousing b
on a.ParcelID=b.ParcelID
and a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null



update a 
set PropertyAddress=isnull(a.PropertyAddress,b.PropertyAddress)
from STOREDB..nationalhousing a
join STOREDB..nationalhousing b
on a.ParcelID=b.ParcelID
and a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null

--breaking out address into individual columns(address,city,state)
select PropertyAddress
from STOREDB..nationalhousing
select 
substring(PropertyAddress,1,charindex(',',propertyAddress) -1) as address,
substring(PropertyAddress,charindex(',',propertyAddress) +1, len(PropertyAddress)) as address
from STOREDB..nationalhousing



alter table nationalhousing
add Propertysplitaddress nvarchar(255);

update nationalhousing
set Propertysplitaddress=substring(PropertyAddress,1,charindex(',',propertyAddress) -1)

alter table nationalhousing
add PropertysplitCity nvarchar(255);

update nationalhousing
set PropertysplitCity=substring(PropertyAddress,charindex(',',propertyAddress) +1, len(PropertyAddress))



select*
from STOREDB..nationalhousing
select OwnerAddress
from STOREDB..nationalhousing
where OwnerAddress is not null


select 
PARSENAME(replace(OwnerAddress,',',','), 1) 
,PARSENAME(replace(OwnerAddress,',',','), 2) 
,PARSENAME(replace(OwnerAddress,',',','), 3) 
from STOREDB.dbo.nationalhousing
where OwnerAddress is not null
alter table nationalhousing
add OwnersplitAddress nvarchar(255);
update nationalhousing
set  OwnersplitAddress=PARSENAME(replace(OwnerAddress,',',','), 1) 

alter table nationalhousing
add OwnersplitCity nvarchar(255);
update nationalhousing
set  OwnersplitCity=PARSENAME(replace(OwnerCity,',',','),  2) 


alter table nationalhousing
add Ownersplitstate nvarchar(255);
update nationalhousing
set Ownersplitstate=PARSENAME(replace(Ownerstate,',',','), 3) 


select*
from STOREDB..nationalhousing



--change yes and no to y anmd n

select distinct(SoldAsVacant),count(SoldAsVacant)
from STOREDB..nationalhousing
group by SoldAsVacant
order by 2


select SoldAsVacant
,case when SoldAsVacant='Y' then 'Yes'
when SoldAsVacant='N' then 'No'
else SoldAsVacant
end
from STOREDB..nationalhousing

update nationalhousing
set SoldAsVacant=case when SoldAsVacant='y' then 'yes'
when SoldAsVacant='n' then 'no'
else SoldAsVacant
end

--remove duplicates
with ROW_NUMCTE AS (


select*,
ROW_NUMBER() over(
partition by ParcelID,
PropertyAddress,
SalePrice,
SaleDate,
LegalReference
order by
UniqueID
) ROW_NUM
from STOREDB..nationalhousing
--order by ParcelID
)
SELECT *
FROM ROW_NUMCTE
WHERE ROW_NUM >1
ORDER BY PropertyAddress


--delete unused columns
select *
from STOREDB..nationalhousing

alter table STOREDB..nationalhousing
drop column ownerAddress,TaxDistrict,propertyAddress

alter table STOREDB..nationalhousing
drop column yearBuilt,FullBath,HalfBath



