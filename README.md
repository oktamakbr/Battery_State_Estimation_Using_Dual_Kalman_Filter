# Battery State Estimation
I made this personal project to estimate battery parameters and state of charge (SOC). I modified original code from Plett [1] and implement it by using open published data from Stanford [2]. The goal is to get root mean square error (RMSE) as minimum as possible between the true and estimation SOC. At this project, I utilize cell W8. First, I extract the cell capacity (Q) and the SOC and OCV relationship curve from diagnostic test 1 since the cell is still pristine. Second, by using Urban Dynamometer Driving Schedule (UDDS) cycle cell W8 data test 1, I get the battery parameters with recursive least square method. Third, I successfully estimate SOC and internal resistivity (R0) using dual sigma point kalman filter and get good rms error.

![Voltage estimation using SPKF](https://github.com/user-attachments/assets/c68a3824-7ac8-456a-96ac-9d67003f98b2)
![SOC estimation using SPKF](https://github.com/user-attachments/assets/4b8978d4-8dd2-4e95-a026-dd92c9980471)
![R0 estimation using SPKF](https://github.com/user-attachments/assets/42fe622f-16c8-47ec-9abd-05369c246cc5)

[1] Plett, G.L., Battery Management Systems, Volume II: Equivalent-Circuit Methods (Artech House, 2015).

[2] Pozzato, G., Allam, A., and Onori, S. (2022). Lithium-ion battery aging dataset based on electric vehicle real-driving profiles. Data Brief 41, 107995.
