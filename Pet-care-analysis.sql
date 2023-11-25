#Novera Maaz
#DS COHORT 4-VIOLET GROUP

ALTER TABLE pet_owners ADD primary key (OwnerID);
ALTER TABLE pets ADD PRIMARY KEY (PetID(10));
SET SQL_SAFE_UPDATES=0;

#List the names of all pet owners along with the names of their pets
SELECT p.Name AS Pet_Name , PO.Name AS Owner_name
FROM pets p
JOIN pet_owners PO ON p.OwnerID=PO.OwnerID;

#List all pets and their owner names, including pets that don't have recorded  owners.  
SELECT p.Name AS Pet_Name , PO.Name AS Owner_name
FROM pets p
LEFT JOIN pet_owners PO ON p.OwnerID=PO.OwnerID;

#Combine the information of pets and their owners, including those pets  without owners and owners without pets. 
SELECT p.Name AS Pet_Name, PO.Name AS owner_name
FROM pets p
LEFT JOIN pet_owners PO ON p.OwnerID = PO.OwnerID;

# Find the names of pets along with their owners' names and the details of the  procedures they have undergone.  
SELECT p.Name AS pet_Name, PO.Name AS owner_name, pr.ProcedureType
from pets p
JOIN pet_owners po ON po.OwnerID=p.OwnerID
JOIN Procedures_history pr ON pr.PetID = p.PetID;

#List all pet owners and the number of dogs they own. 
SELECT p.OwnerID, po.Name AS owner_name, COUNT(p.petID) AS total_dogs
FROM pet_owners po
LEFT JOIN pets p ON po.OwnerID=p.OwnerID
WHERE p.Kind = 'Dog'
GROUP BY P.OwnerID,po.Name;

#Identify pets that have not had any procedures.  
SELECT p.petID , p.Name AS pet_name
FROM pets p
LEFT JOIN procedures_history pr ON pr.PetID=P.PetID
WHERE pr.PetID IS NULL;

#Find the name of the oldest pet.  
SELECT PetID,Name, Age
FROM pets
Group BY PetID, Age
ORDER BY Age DESC
LIMIT 1;

#List all pets who had procedures that cost more than the average cost of all  procedures.  
SELECT
    p.PetID AS pet_ID,
    p.Name AS pet_Name,
    pd.price AS procedure_price
	from pets p
	LEFT JOIN procedures_history ph ON p.PetID=ph.PetID
	LEFT JOIN procedures_details pd ON ph.ProcedureType=Pd.ProcedureType 
    WHERE pd.price IS NOT NULL AND pd.price > (SELECT AVG(pd.Price) from procedures_details pd);
    
    #Find the details of procedures performed on 'Cuddles'
    SELECT p.petID, p.Name, pd.ProcedureType,ph.Date
    FROM pets p
	LEFT JOIN procedures_history ph ON p.PetID=ph.PetID
	LEFT JOIN procedures_details pd ON ph.ProcedureType=Pd.ProcedureType 
    WHERE p.Name='Cuddles'
    GROUP BY p.PetID,p.Name,pd.ProcedureType,ph.Date;
    
    #Identify pets that have not had any procedures
	SELECT p.petID, p.Name, pd.ProcedureType
    FROM pets p
	LEFT JOIN procedures_history ph ON p.PetID=ph.PetID
	LEFT JOIN procedures_details pd ON ph.ProcedureType=Pd.ProcedureType
    WHERE pd.ProcedureType IS NULL;
    
    #Create a list of pet owners along with the 
    #total cost they have spent on  procedures and display only those who have spent above the average spending.
    SELECT po.Name, SUM(pd.Price) AS Total_cost, AVG(pd.price) AS average_Price
    FROM pets p
    LEFT JOIN pet_owners po on po.OwnerID=p.OwnerID
    LEFT JOIN Procedures_history ph ON ph.PetID=p.PetID
    LEFT JOIN procedures_details pd ON ph.ProcedureType=Pd.ProcedureType 
    GROUP BY po.Name
    HAVING Total_cost > (SELECT AVG(pd.Price) FROM procedures_details pd WHERE pd.Price IS NOT NULL);
    
	#List the pets who have undergone a procedure called 'VACCINATIONS
	SELECT p.petID, p.Name, pd.ProcedureType
    FROM pets p
	LEFT JOIN procedures_history ph ON p.PetID=ph.PetID
	LEFT JOIN procedures_details pd ON ph.ProcedureType=Pd.ProcedureType 
	WHERE pd.ProcedureType = "VACCINATIONS"
    GROUP BY p.PetID,p.Name;
   
    
    #Find the owners of pets who have had a procedure called 'EMERGENCY'
	SELECT p.petID, p.Name AS pet_name, po.Name AS owner_name
	FROM pet_owners po
	LEFT JOIN pets p ON p.OwnerID=po.OwnerID
	LEFT JOIN Procedures_history ph ON ph.PetID=p.PetID
	LEFT JOIN procedures_details pd ON ph.ProcedureType=pd.ProcedureType
    WHERE pd.Description="Emergency";
    
    #Calculate the total cost spent by each pet owner on procedures
    SELECT po.OwnerID,po.Name AS owner_Name, SUM(pd.Price) AS total_price
    from pet_owners po
    LEFT JOIN pets p ON p.OwnerID=po.OwnerID
	LEFT JOIN Procedures_history ph ON ph.PetID=p.PetID
	LEFT JOIN procedures_details pd ON ph.ProcedureType=pd.ProcedureType
    GROUP BY po.OwnerID,PO.Name;
    
    #Count the number of pets of each kind
	SELECT Kind,COUNT(*) AS pet_kind
	FROM pets
	GROUP BY Kind;
    
    #Group pets by their kind and gender and count the number of pets in each  group.  
    SELECT kind,Gender,COUNT(*) AS number_of_pets
    FROM pets
    GROUP BY kind,Gender;
    
    #Show the average age of pets for each kind, but only for kinds that have more  than 5 pets. 
    SELECT Kind, count(Kind) as Number_of_pets, AVG(Age) AS Average_age
    from pets
    group by kind;
    
    #Find the types of procedures that have an average cost greater than $50
    SELECT ProcedureType , AVG(price)  AS Average_price
    FROM procedures_details
    GROUP BY ProcedureType
    HAVING Average_price >50;
    
    #Classify pets as 'Young', 'Adult', or 'Senior' based on their age. Age less then  3 Young, Age between 3and 8 Adult, else Senior. 
    SELECT Name, Age,
    CASE 
    WHEN Age < 3 THEN 'Young'
    WHEN Age BETWEEN 3 AND 8 THEN 'Adult'
    ELSE 'Senior'
    END AS classification_on_age
    from pets;
    
    #Calculate the total spending of each pet owner on procedures, labeling them  as 'Low Spender' for spending under $100, 
    #'Moderate Spender' for spending  between $100 and $500, and 'High Spender' for spending over $500.  
    SELECT po.OwnerID, po.Name, SUM(pd.price) AS total_Spending,
    CASE 
    WHEN SUM(pd.price) < 100 THEN 'Low spender'
    WHEN SUM(pd.Price) BETWEEN 100 AND 500 THEN 'Moderate Spender'
    WHEN SUM(pd.Price) > 500 THEN 'High Spender'
    END AS Spender_Type
    FROM pet_owners po
	JOIN pets p ON p.OwnerID=po.OwnerID
	JOIN Procedures_history ph ON ph.PetID=p.PetID
	JOIN procedures_details pd ON ph.ProcedureType=pd.ProcedureType
    GROUP BY po.Name,po.OwnerID;
    
    #Show the gender of pets with a custom label ('Boy' for male, 'Girl' for female)
    select PetID, Name,
    CASE
    WHEN gender = 'Male' THEN 'Boy'
    WHEN gender = 'Female' THEN 'Girl'
    END AS custom_label_gender
    FROM pets;
    
    #For each pet, display the pet's name, the number of procedures they've had,  and a status label: 'Regular' 
    #for pets with 1 to 3 procedures, 'Frequent' for 4 to  7 procedures, and 'Super User' for more than 7 procedures. 
    
    SELECT p.Name, Count(ph.procedureType) AS number_of_procedures,
    CASE 
    WHEN COUNT(ph.ProcedureType) BETWEEN 1 AND 3 THEN 'Regular'
    WHEN COUNT(ph.ProcedureType) BETWEEN 4 AND 7 THEN ' Frequent'
    WHEN COUNT(ph.ProcedureType) > 7 THEN 'Super User'
    END AS User_type
    from pets p
    JOIN procedures_history ph ON p.PetID=Ph.PetID
    GROUP BY p.PetID, P.Name;
    
    #Rank pets by age within each kind
    SELECT Name, Kind, Age,
    RANK() OVER(Partition by Kind ORDER BY Age) AS age_rank
    from pets;
    
    #Assign a dense rank to pets based on their age, regardless of kind.
     SELECT Name,Age,
     dense_rank() OVER (Order by Age) AS AGE_RANK
     from pets;
    
    #For each pet, show the name of the next and previous pet in alphabetical order
    with rank_of_pets AS
    (select Name,
    DENSE_RANK() OVER(Order by Name) from pets)
    
    SELECT rp.Name AS current_pet,
    LAG(rp.Name) OVER (ORDER BY rp.name) AS previous_pet,
    LEAD(rp.Name) OVER (ORDER BY rp.Name) AS Next_pet
    FROM rank_of_pets rp;
    
#Show the average age of pets, partitioned by their kind.  
SELECT Kind,
Avg(Age) OVER (PARTITION BY kind) AS averageAge_by_kind from pets;

#Create a CTE that lists all pets, then select pets older than 5 years from the  CTE. 
WITH Older_pets AS
(SELECT Name,Age,Kind from pets)

SELECT Name, Age, KInd
from older_pets
where age > 5;


    
    

    
    
    
    