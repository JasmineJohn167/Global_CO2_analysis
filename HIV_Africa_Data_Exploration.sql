-- Combining people living with HIV, dying due to HIV, women's share of population aged 15 and over with HIV, Pregnant women percentage and mother to child transmission into 1 table called HIV
CREATE TABLE HIV AS
SELECT
    L.Country,
    L.living_2017, L.living_2016, L.living_2015, L.living_2014, L.living_2013,
    L.living_2012, L.living_2011, L.living_2010, L.living_2009, L.living_2008,
    D.dying_2017, D.dying_2016, D.dying_2015, D.dying_2014, D.dying_2013,
    D.dying_2012, D.dying_2011, D.dying_2010, D.dying_2009, D.dying_2008,
    M.m_2008, M.m_2009, M.m_2010, M.m_2011,
    M.m_2012, M.m_2013, M.m_2014, M.m_2015,
    M.m_2016, M.m_2017,
    W.w_2008, W.w_2009, W.w_2010, W.w_2011,
    W.w_2012, W.w_2013, W.w_2014, W.w_2015,
    W.w_2016, W.w_2017,
    PW.p_2008, PW.p_2009, PW.p_2010, PW.p_2011,
    PW.p_2012, PW.p_2013, PW.p_2014, PW.p_2015,
    PW.p_2016, PW.p_2017
FROM
    HIV_Africa.L
JOIN HIV_Africa.D ON L.Country = D.Country
JOIN HIV_Africa.M ON L.Country = M.Country
JOIN HIV_Africa.W ON L.Country = W.Country
JOIN HIV_Africa.PW ON L.Country = PW.Country;

-- Creating new table for Population, GDP and Unemployment
CREATE TABLE Economy AS
SELECT
    P.Country,
    P.pop_2008, P.pop_2009, P.pop_2010, P.pop_2011, P.pop_2012,
    P.pop_2013, P.pop_2014, P.pop_2015, P.pop_2016, P.pop_2017,
    U.e_2008, U.e_2009, U.e_2010, U.e_2011, U.e_2012,
    U.e_2013, U.e_2014, U.e_2015, U.e_2016, U.e_2017,
    G.gdp_2008, G.gdp_2009, G.gdp_2010, G.gdp_2011, G.gdp_2012,
    G.gdp_2013, G.gdp_2014, G.gdp_2015, G.gdp_2016, G.gdp_2017
FROM
    HIV_Africa.P
JOIN
    HIV_Africa.U ON P.Country = U.Country
JOIN
    HIV_Africa.G ON P.Country = G.Country;

-- Estimated number of people living with HIV
SELECT
    Country,
    SUM(living_2017 + living_2016 + living_2015 + living_2014 + living_2013 + living_2012 + living_2011 + living_2010 + living_2009 + living_2008) AS People_with_HIV
FROM
    HIV_Africa.L
WHERE
    Country IN ('Angola', 'Botswana', 'Eswatini', 'Lesotho', 'Madagascar', 'Malawi', 'Mozambique', 'Namibia', 'South Africa', 'Zambia', 'Zimbabwe')
GROUP BY
    Country
ORDER BY
    Country;
    
-- Estimated number of people dying due to HIV
SELECT
    Country,
    SUM(dying_2017 + dying_2016 + dying_2015 + dying_2014 + dying_2013 + dying_2012 + dying_2011 + dying_2010 + dying_2009 + dying_2008) AS People_dying_HIV
FROM
    HIV_Africa.D
WHERE
    Country IN ('Angola', 'Botswana', 'Eswatini', 'Lesotho', 'Madagascar', 'Malawi', 'Mozambique', 'Namibia', 'South Africa', 'Zambia', 'Zimbabwe')
GROUP BY
    Country
ORDER BY
    Country;
    
-- Percent of pregnant women with HIV
SELECT
    Country,
    AVG(p_2008 + p_2009 + p_2010 + p_2011 + p_2012 + p_2013 + p_2014 + p_2015 + p_2016 + p_2017) / 10 AS "Percent of Pregnant Women with HIV"
FROM
    HIV_Africa.PW
WHERE
    Country IN ('Angola', 'Botswana', 'Eswatini', 'Lesotho', 'Madagascar', 'Malawi', 'Mozambique', 'Namibia', 'South Africa', 'Zambia', 'Zimbabwe')
GROUP BY
    Country
ORDER BY
    Country;

-- Women's share of population ages 15+ living with HIV(%)
SELECT
    Country,
    ROUND(AVG(w_2008 + w_2009 + w_2010 + w_2011 + w_2012 + w_2013 + w_2014 + w_2015 + w_2016 + w_2017) / 10, 2) AS "Women's share of population ages 15+ living with HIV(%)"
FROM
    HIV_Africa.W
WHERE
    Country IN ('Angola', 'Botswana', 'Eswatini', 'Lesotho', 'Madagascar', 'Malawi', 'Mozambique', 'Namibia', 'South Africa', 'Zambia', 'Zimbabwe')
GROUP BY
    Country
ORDER BY
    Country;

-- Mother to child transmission rate
SELECT
    Country,
    ROUND(AVG(m_2008 + m_2009 + m_2010 + m_2011 + m_2012 + m_2013 + m_2014 + m_2015 + m_2016 + m_2017) / 10,2) AS "Mother to Child transmission rate"
FROM
    HIV_Africa.M
WHERE
    Country IN ('Angola', 'Botswana', 'Eswatini', 'Lesotho', 'Madagascar', 'Malawi', 'Mozambique', 'Namibia', 'South Africa', 'Zambia', 'Zimbabwe')
GROUP BY
    Country
ORDER BY
    Country;

-- Number of people living with HIV/Population
-- Creating a view that joins HIV and Economy data
CREATE VIEW hiv_economy_join AS
SELECT
    h.Country,
    ROUND(
        (
            h.living_2017 + h.living_2016 + h.living_2015 + h.living_2014 +
            h.living_2013 + h.living_2012 + h.living_2011 + h.living_2010 +
            h.living_2009 + h.living_2008
        ) / (
            e.pop_2017 + e.pop_2016 + e.pop_2015 + e.pop_2014 +
            e.pop_2013 + e.pop_2012 + e.pop_2011 + e.pop_2010 +
            e.pop_2009 + e.pop_2008
        ), 3) AS hiv_ratio
FROM
    HIV h
JOIN
    Economy e ON h.Country = e.Country;

-- Select the desired output
SELECT
    Country,
    hiv_ratio
FROM
    hiv_economy_join;

-- Relation between GDP and unemployment rates
SELECT 
    G.Country, 
    ROUND(AVG(G.gdp_2008 + G.gdp_2009 + G.gdp_2010 + G.gdp_2011 + G.gdp_2012 + G.gdp_2013 + G.gdp_2014 + G.gdp_2015 + G.gdp_2016 + G.gdp_2017) / 10, 2) AS AverageGDP, 
    ROUND(AVG(U.e_2008 + U.e_2009 + U.e_2010 + U.e_2011 + U.e_2012 + U.e_2013 + U.e_2014 + U.e_2015 + U.e_2016 + U.e_2017) / 10, 2) AS AverageUnemploymentRate 
FROM 
    Economy G 
JOIN 
    Economy U ON G.Country = U.Country 
GROUP BY 
    G.Country;

-- Relation between number of people living with HIV and dying due to HIV 
SELECT 
    Country, 
    SUM(living_2008 + living_2009 + living_2010 + living_2011 + living_2012 + living_2013 + living_2014 + living_2015 + living_2016 + living_2017) AS total_people_living,
    SUM(dying_2008 + dying_2009 + dying_2010 + dying_2011 + dying_2012 + dying_2013 + dying_2014 + dying_2015 + dying_2016 + dying_2017) AS total_people_dying 
FROM 
    HIV
GROUP BY 
    Country;
    
-- Joining HIV and Economy tables and displaying entire contents
SELECT
    H.Country,
    H.living_2017, H.living_2016, H.living_2015, H.living_2014, H.living_2013, H.living_2012, H.living_2011, H.living_2010, H.living_2009, H.living_2008,
    H.dying_2017, H.dying_2016, H.dying_2015, H.dying_2014, H.dying_2013, H.dying_2012, H.dying_2011, H.dying_2010, H.dying_2009, H.dying_2008,
    H.m_2008, H.m_2009, H.m_2010, H.m_2011, H.m_2012, H.m_2013, H.m_2014, H.m_2015, H.m_2016, H.m_2017,
    H.w_2008, H.w_2009, H.w_2010, H.w_2011, H.w_2012, H.w_2013, H.w_2014, H.w_2015, H.w_2016, H.w_2017,
    H.p_2008, H.p_2009, H.p_2010, H.p_2011, H.p_2012, H.p_2013, H.p_2014, H.p_2015, H.p_2016, H.p_2017,
    E.pop_2008, E.pop_2009, E.pop_2010, E.pop_2011, E.pop_2012, E.pop_2013, E.pop_2014, E.pop_2015, E.pop_2016, E.pop_2017,
    E.e_2008, E.e_2009, E.e_2010, E.e_2011, E.e_2012, E.e_2013, E.e_2014, E.e_2015, E.e_2016, E.e_2017,
    E.gdp_2008, E.gdp_2009, E.gdp_2010, E.gdp_2011, E.gdp_2012, E.gdp_2013, E.gdp_2014, E.gdp_2015, E.gdp_2016, E.gdp_2017
FROM
    HIV H
JOIN
    Economy E ON H.Country = E.Country;