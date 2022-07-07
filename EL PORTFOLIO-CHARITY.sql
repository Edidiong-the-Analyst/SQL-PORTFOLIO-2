SELECT *
FROM [EntryLevelProgram Tasks]..Donation_Data 


SELECT *
FROM [EntryLevelProgram Tasks]..Donation_Data dd1
JOIN [EntryLevelProgram Tasks]..Donor_Data2 DD2
	ON dd1.id = DD2.id



-- WHICH STATE HAS THE HIGHEST NUMBER OF DONORS?
SELECT  state, COUNT(id) as DonorState_count
FROM [EntryLevelProgram Tasks]..Donation_Data 
Group by state
Order by 2 desc


-- WHICH JOB FIELD HAS THE HIGHEST NUMBER OF DONORS?
SELECT  job_field, COUNT(id) as DonorJF_count
FROM [EntryLevelProgram Tasks]..Donation_Data 
Group by job_field
Order by 2 desc



-- WHAT IS THE NUMBER OF FEMALE AND MALE DONORS?
SELECT  gender, COUNT(id) as DonorGender_count
FROM [EntryLevelProgram Tasks]..Donation_Data 
Group by gender
Order by 2 desc


-- WHAT IS THE NUMBER OF FEMALE AND MALE DONORS ACROSS DIFF STATES AND JOB FIELD?
SELECT  state, job_field, gender, COUNT(id) as Donorcount
FROM [EntryLevelProgram Tasks]..Donation_Data 
Group by state, gender, job_field


-- WHAT IS THE NUMBER OF FEMALE AND MALE DONORS ACROSS DIFF STATES?
SELECT  state, gender, COUNT(id) as Donorcount
FROM [EntryLevelProgram Tasks]..Donation_Data 
Group by state, gender
Order by 3 desc


--DOES CAR MAKE OF DONORS HAVE AN INFLUENCE ON THE DONATION AMOUNTS?
SELECT Distinct(DD2.car),Sum(dd1.donation) SumofDonationbyCarMake, Avg(dd1.donation) AvgofDonationbyCarMake
FROM [EntryLevelProgram Tasks]..Donation_Data dd1
JOIN [EntryLevelProgram Tasks]..Donor_Data2 DD2
	ON dd1.id = DD2.id
GROUP BY DD2.car
ORDER BY 2 desc


-- WHICH GENDER DONATES MOST?
SELECT gender, SUM(donation) as DonationSumbyGender
FROM [EntryLevelProgram Tasks]..Donation_Data 
Group by gender
Order by 2 desc



-- WHICH STATES DONATES MOST?
SELECT state, SUM(donation) as DonationSumbyState
FROM [EntryLevelProgram Tasks]..Donation_Data 
Group by state
Order by 2 desc


-- WHICH JOB FIELD DONATES MOST?
SELECT job_field, SUM(donation) as DonationSumbyJobfield
FROM [EntryLevelProgram Tasks]..Donation_Data 
Group by job_field
Order by 2 desc


--WHAT DONATION FREQUENCY TENDS TO HAVE THE HIGHEST DONATION VALUES?
SELECT Distinct(DD2.donation_frequency),Sum(dd1.donation) SumofDonation, Avg(dd1.donation) AvgofDonation
FROM [EntryLevelProgram Tasks]..Donation_Data dd1
JOIN [EntryLevelProgram Tasks]..Donor_Data2 DD2
	ON dd1.id = DD2.id
GROUP BY DD2.donation_frequency
ORDER BY 2 desc
