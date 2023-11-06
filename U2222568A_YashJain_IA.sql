-- Q1
SELECT DISTINCT generalLoc
FROM postalCodeTBL;

-- Q2
SELECT COUNT(*) AS SpeedLimitIncidentCount
FROM incidentTypeTBL
WHERE detail LIKE '%speed limit%';

-- Q3 
SELECT YEAR(STR_TO_DATE(date, "%M %e, %Y")) AS year, incidentType, COUNT(*) AS total 
FROM incidentTBL
GROUP BY year, incidentType
ORDER BY year, incidentType;

-- Q4
SELECT YEAR(STR_TO_DATE(c.date, "%M %e, %Y")) AS ComplaintYear, c.issue AS IssueCategory, 
       COUNT(*) AS TotalComplaints,
       SUM(CASE WHEN cu.gender = 0 THEN 1 ELSE 0 END) AS FemaleComplaints,
       SUM(CASE WHEN cu.gender = 1 THEN 1 ELSE 0 END) AS MaleComplaints
FROM complaintTBL c
INNER JOIN customerTBL cu ON c.customerID = cu.customerID
WHERE YEAR(STR_TO_DATE(c.date, "%M %e, %Y")) BETWEEN 2010 AND 2018
GROUP BY ComplaintYear, IssueCategory
ORDER BY ComplaintYear, IssueCategory;


-- Q5
select substring(startdate,-4) as year,postalcodetbl.generalLoc,
sum(fee_per_hour*ceiling(timediff(concat(endtime_hr,':',endtime_min, ':',endtime_ss),concat(starttime_hr,':',starttime_min,':',starttime_ss)))) as total_customer_value
from orderTBL 
join customerTBL on ordertbl.customerID = customertbl.customerID #join -> on common vals
join postalCodeTBL on customerTBL.postal = postalcodeTBL.postalCode 
join vehicleTBL on orderTBL.vehicleID = vehicleTBL.vehicleID
group by year,generalloc
order by year,generalloc;


-- Q6
SELECT
  YEAR(STR_TO_DATE(c.date, '%M %d, %Y')) AS year,
  v.vehicleID,
  AVG(v.total_distance_km) AS avg_distance
FROM complaintTBL c
INNER JOIN customerTBL cu
ON cu.customerID = c.customerID 
INNER JOIN orderTBL o
ON cu.customerID = o.customerID
INNER JOIN vehicleTBL v
ON o.vehicleID = v.vehicleID
GROUP BY
  YEAR(STR_TO_DATE(c.date, '%M %d, %Y')),
  v.vehicleID  
ORDER BY
  year, vehicleID;

-- Q7
SELECT
  CASE
    WHEN c.driving_age_yr BETWEEN 21 AND 30 THEN '21-30'   
    WHEN c.driving_age_yr BETWEEN 31 AND 50 THEN '31-50'
    ELSE '51+'
  END AS age_group,
  c.gender,
  v.brand,
  v.model,
  COUNT(*) * 100.0 / SUM(COUNT(*)) OVER() AS percentage  
FROM customerTBL c
JOIN orderTBL o ON c.customerID = o.customerID
JOIN vehicleTBL v ON o.vehicleID = v.vehicleID
GROUP BY age_group, gender, brand, model
ORDER BY age_group, gender, brand, model;

-- Q8
SELECT DISTINCT c.customerID, o.vehicleID
FROM customerTBL c
JOIN orderTBL o ON c.customerID = o.customerID 
GROUP BY c.customerID, o.vehicleID
HAVING COUNT(*) > 1;

-- Q9
SELECT
  c.customerID,
  CONCAT(SUBSTR(o.startLoc, 1, 2), '-', SUBSTR(o.endLoc, 1, 2)) AS loc_pair,
  COUNT(*) AS num_rentals,
  AVG(o.distance_m) AS avg_distance
FROM customerTBL c
JOIN orderTBL o ON c.customerID = o.customerID
GROUP BY c.customerID, loc_pair
ORDER BY c.customerID, loc_pair;

-- Q10
SELECT
  YEAR(STR_TO_DATE(startDate, "%d-%b-%Y")) AS order_year,
  c.customerID,
  SUM(o.distance_m * v.CO2avg_NEDC / 1000) AS total_NEDC,
  SUM(o.distance_m * v.CO2avg_WLTP / 1000) AS total_WLTP
FROM orderTBL o
JOIN customerTBL c ON o.customerID = c.customerID
JOIN vehicleTBL v ON o.vehicleID = v.vehicleID
GROUP BY order_year, c.customerID  
ORDER BY order_year, c.customerID;




