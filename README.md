# Battery State Estimation
I made this personal project to estimate state of charge and internal resistivity of a battery in MATLAB. I use the algorithm by modifying the orginial code from Plett [1] and implement it by using open published data from Stanford [2]. The goal is to get root mean square error (rms) as mininum as possible between the soc measurement and estimation. I use W8 cell data. First, I extract the SOC and OCV curve from diagnostic test data. Second, by using UDDS cycle test data, I get the battery parameter with recursive least square method. Third, I successfully estimate SOC and R0 using dual sigma point kalman filter and get good rms error.

![SOC estimation using SPKF](https://github.com/user-attachments/assets/4b8978d4-8dd2-4e95-a026-dd92c9980471)

[1] Plett, G.L., Battery Management Systems, Volume II: Equivalent-Circuit Methods (Artech House, 2015).

[2] Pozzato, G., Allam, A., and Onori, S. (2022). Lithium-ion battery aging dataset based on electric vehicle real-driving profiles. Data Brief 41, 107995.
